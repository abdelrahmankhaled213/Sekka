import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/category_ui.dart';

class EditPostModalWidget extends StatefulWidget {
  final ItemModel post;

  const EditPostModalWidget({super.key, required this.post});

  @override
  State<EditPostModalWidget> createState() => _EditPostModalWidgetState();
}

class _EditPostModalWidgetState extends State<EditPostModalWidget> {
  late ItemType _postType;
  late Category _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _stationController;

  // If user picks a new image, this is set. Otherwise we keep the existing imageUrl.
  XFile? _newImage;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _postType = widget.post.type;
    _selectedCategory = widget.post.category;
    _titleController = TextEditingController(text: widget.post.title);
    _descriptionController = TextEditingController(text: widget.post.description);
    _stationController = TextEditingController(text: widget.post.stationName);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: AppStyle.regular16RobotoBlack.copyWith(
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      final cubit = context.read<LostAndFoundCubit>();
      String? imageUrl = widget.post.imageUrl;

      // Only upload a new image if the user picked one
      if (_newImage != null) {
        final userId = FirebaseAuth.instance.currentUser!.uid;
        imageUrl = await cubit.uploadPostImage(File(_newImage!.path), userId);
      }

      final updatedPost = widget.post.copyWith(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        stationName: _stationController.text.trim(),
        category: _selectedCategory,
        type: _postType,
        imageUrl: imageUrl,
      );

      await cubit.updatePost(updatedPost);
    } catch (e) {
      _showSnackBar("Failed to update post: $e", AppColor.error);
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) setState(() => _newImage = picked);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 20.h + bottomInset),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Post Type *'),
                    SizedBox(height: 10.h),
                    _buildPostTypeSelector(),
                    SizedBox(height: 18.h),
                    _buildSectionLabel('Title *'),
                    SizedBox(height: 8.h),
                    _buildTitleField(),
                    SizedBox(height: 18.h),
                    _buildSectionLabel('Description'),
                    SizedBox(height: 8.h),
                    _buildDescriptionField(),
                    SizedBox(height: 18.h),
                    _buildSectionLabel('Category *'),
                    SizedBox(height: 10.h),
                    _buildCategoryGrid(),
                    SizedBox(height: 18.h),
                    _buildSectionLabel('Station *'),
                    SizedBox(height: 8.h),
                    _buildStationField(),
                    SizedBox(height: 18.h),
                    _buildSectionLabel('Image'),
                    SizedBox(height: 8.h),
                    _buildImagePicker(),
                    SizedBox(height: 24.h),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppStyle.brandGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.edit_rounded, color: Colors.white, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Post',
                    style: AppStyle.regular18RobotoWhite.copyWith(
                        fontSize: 17.sp, fontWeight: FontWeight.w800, color: Colors.white)),
                Text('Update your lost or found item',
                    style: AppStyle.regular18RobotoWhite.copyWith(
                        fontSize: 12.sp, color: Colors.white.withAlpha(217))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(color: Colors.white.withAlpha(51), shape: BoxShape.circle),
              child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppStyle.regular16RobotoBlack.copyWith(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'Roboto',
      ),
    );
  }

  Widget _buildPostTypeSelector() {
    return Row(
      children: [
        Expanded(child: _buildTypeCard(ItemType.lost, Icons.error_outline_rounded, 'I Lost\nSomething', 'Report a lost item')),
        SizedBox(width: 12.w),
        Expanded(child: _buildTypeCard(ItemType.found, Icons.inventory_2_outlined, 'I Found\nSomething', 'Report a found item')),
      ],
    );
  }

  Widget _buildTypeCard(ItemType type, IconData icon, String title, String subtitle) {
    final isSelected = _postType == type;
    final selectedColor = type == ItemType.lost ? AppColor.error : AppColor.secondary;
    final bgColor = type == ItemType.lost ? AppColor.errorContainer : AppColor.surfaceVariant;

    return GestureDetector(
      onTap: () => setState(() => _postType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : AppColor.surfaceVariant,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: isSelected ? selectedColor : AppColor.outline, width: isSelected ? 2 : 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28.sp, color: isSelected ? selectedColor : AppColor.muted),
            SizedBox(height: 6.h),
            Text(title,
                textAlign: TextAlign.center,
                style: AppStyle.regular11RobotoGrey.copyWith(
                    fontSize: 13.sp, fontWeight: FontWeight.w700,
                    color: isSelected ? selectedColor : AppColor.textSecondary, height: 1.3)),
            SizedBox(height: 3.h),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: AppStyle.regular11RobotoGrey.copyWith(fontSize: 11.sp, color: AppColor.muted)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: AppStyle.regular11RobotoGrey.copyWith(fontSize: 14, color: AppColor.textPrimary),
      decoration: InputDecoration(
        hintText: 'e.g., Lost Black Wallet',
        prefixIcon: Icon(Icons.title_rounded, size: 18.sp, color: AppColor.muted),
        filled: true,
        fillColor: AppColor.surfaceVariant,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.outline, width: 1.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.outline, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.secondary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColor.error, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColor.error, width: 2)),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Please enter a title';
        if (v.trim().length < 4) return 'Title must be at least 4 characters';
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      maxLines: 3,
      style: AppStyle.regular11RobotoGrey.copyWith(fontSize: 14.sp, color: AppColor.textPrimary),
      decoration: InputDecoration(
        hintText: 'Describe the item, color, distinguishing features...',
        filled: true,
        fillColor: AppColor.surfaceVariant,
        contentPadding: EdgeInsets.all(14.sp),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColor.outline, width: 1.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColor.outline, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r), borderSide: const BorderSide(color: AppColor.secondary, width: 2)),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {
        final isSelected = _selectedCategory == cat.type;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColor.surface : AppColor.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColor.secondary : AppColor.outline, width: isSelected ? 2 : 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat.icon, size: 16.sp, color: isSelected ? AppColor.secondary : AppColor.textSecondary),
                SizedBox(width: 6.w),
                Text(cat.label,
                    style: AppStyle.regular11RobotoGrey.copyWith(
                        fontSize: 13.sp, fontWeight: FontWeight.w600,
                        color: isSelected ? AppColor.secondary : AppColor.textSecondary)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStationField() {
    return TextFormField(
      controller: _stationController,
      style: AppStyle.regular11RobotoGrey.copyWith(fontSize: 14.sp, color: AppColor.textPrimary),
      decoration: InputDecoration(
        hintText: 'Select or type station name',
        prefixIcon: Icon(Icons.location_on_outlined, size: 18.sp, color: AppColor.muted),
        filled: true,
        fillColor: AppColor.surfaceVariant,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.outline, width: 1.5)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.outline, width: 1.5)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.secondary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.error, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColor.error, width: 2)),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Please enter the station name';
        return null;
      },
    );
  }

  Widget _buildImagePicker() {
    // Show new image if picked, otherwise show existing imageUrl
    final hasNewImage = _newImage != null;
    final hasExistingImage = widget.post.imageUrl != null && widget.post.imageUrl!.isNotEmpty;

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 150.h,
        decoration: BoxDecoration(
          color: AppColor.surfaceVariant,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: (hasNewImage || hasExistingImage) ? AppColor.secondary : AppColor.outline,
            width: (hasNewImage || hasExistingImage) ? 2 : 1.5,
          ),
        ),
        child: hasNewImage
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.file(File(_newImage!.path),
                        width: double.infinity, height: 150.h, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _newImage = null),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: Icon(Icons.close, color: Colors.white, size: 16.sp),
                      ),
                    ),
                  ),
                ],
              )
            : hasExistingImage
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(widget.post.imageUrl!,
                            width: double.infinity, height: 150.h, fit: BoxFit.cover),
                      ),
                      // Tap overlay hint
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Container(
                            color: Colors.black.withAlpha(50),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.camera_alt_rounded, color: Colors.white, size: 24.sp),
                                  SizedBox(height: 4.h),
                                  Text('Tap to change',
                                      style: TextStyle(color: Colors.white, fontSize: 11.sp, fontFamily: 'Roboto')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_rounded, color: AppColor.muted, size: 32.sp),
                      SizedBox(height: 8.h),
                      Text('Tap to add image',
                          style: TextStyle(fontSize: 12.sp, fontFamily: 'Roboto', color: AppColor.muted)),
                    ],
                  ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: BlocConsumer<LostAndFoundCubit, LostFoundState>(
        listenWhen: (_, current) =>
            current.status == LostFoundStatus.updatePostSuccess ||
            current.status == LostFoundStatus.updatePostFailure,
        listener: (context, state) {
          if (state.status == LostFoundStatus.updatePostSuccess) {
            context.read<LostAndFoundCubit>().getPosts();
            _showSnackBar("Post updated successfully", AppColor.success);
            Navigator.pop(context);
          }
          if (state.status == LostFoundStatus.updatePostFailure) {
            _showSnackBar(state.errorMsg ?? "Update failed", AppColor.error);
          }
        },
        buildWhen: (_, current) =>
            current.status == LostFoundStatus.updatePostLoading ||
            current.status == LostFoundStatus.updatePostSuccess ||
            current.status == LostFoundStatus.updatePostFailure ||
            current.status == LostFoundStatus.initial,
        builder: (context, state) {
          final isLoading = _isUploading || state.status == LostFoundStatus.updatePostLoading;

          return isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColor.secondary))
              : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: AppStyle.brandGradient,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Save Changes',
                        style: AppStyle.regular11RobotoGrey.copyWith(
                            fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}