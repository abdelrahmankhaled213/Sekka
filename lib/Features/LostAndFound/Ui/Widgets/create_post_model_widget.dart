import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';

class CreatePostModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostCreated;

  const CreatePostModalWidget({super.key, required this.onPostCreated});

  @override
  State<CreatePostModalWidget> createState() => _CreatePostModalWidgetState();
}

class _CreatePostModalWidgetState extends State<CreatePostModalWidget> {
  // TODO: Replace with Riverpod/Bloc for production
  String _postType = 'lost'; // lost or found
  String _selectedCategory = '';
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stationController = TextEditingController();
  bool _isSubmitting = false;

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Phone', 'icon': Icons.phone_android_rounded},
    {'label': 'Wallet', 'icon': Icons.account_balance_wallet_outlined},
    {'label': 'Bag/Backpack', 'icon': Icons.work_outline_rounded},
    {'label': 'Keys', 'icon': Icons.key_outlined},
    {'label': 'Other', 'icon': Icons.inventory_2_outlined},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a category',
            style: AppStyle.regular16RobotoBlack.copyWith(
              fontSize: 14.sp
            ),
          ),
          backgroundColor: AppColor.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 800));
    if (mounted) {
      final catLabel = _selectedCategory.replaceAll('/', '');
      widget.onPostCreated({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'posterName': 'You',
        'posterAvatar':
            'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?w=100',
        'posterAvatarSemanticLabel': 'Your profile photo',
        'postType': _postType,
        'timeAgo': 'Just now',
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'station': _stationController.text.trim(),
        'messageCount': 0,
        'status': 'active',
        'category': catLabel,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppStyle.brandGradient,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:  Icon(
                    Icons.inventory_2_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Post',
                        style: AppStyle.regular18RobotoWhite.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Report lost or found item',
                        style: AppStyle.regular18RobotoWhite.copyWith(
                          fontSize: 12,
                          color: Colors.white.withAlpha(217),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36.w,
                    height: 36.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Form body
          Container(
            color: AppColor.surface,
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 20 + bottomInset),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Post Type *'),
                    const SizedBox(height: 10),
                    _buildPostTypeSelector(),
                    const SizedBox(height: 18),
                    _buildSectionLabel('Title *'),
                    const SizedBox(height: 8),
                    _buildTitleField(),
                    const SizedBox(height: 18),
                    _buildSectionLabel('Description'),
                    const SizedBox(height: 8),
                    _buildDescriptionField(),
                    const SizedBox(height: 18),
                    _buildSectionLabel('Category *'),
                    const SizedBox(height: 10),
                    _buildCategoryGrid(),
                    const SizedBox(height: 18),
                    _buildSectionLabel('Station *'),
                    const SizedBox(height: 8),
                    _buildStationField(),
                    const SizedBox(height: 24),
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: AppStyle.regular16RobotoBlack.copyWith(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,

      ),
    );
  }

  Widget _buildPostTypeSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildTypeCard(
            'lost',
            Icons.error_outline_rounded,
            'I Lost\nSomething',
            'Report a lost item',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTypeCard(
            'found',
            Icons.inventory_2_outlined,
            'I Found\nSomething',
            'Report a found item',
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard(
    String type,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = _postType == type;
    final color = type == 'lost' ? AppColor.error : AppColor.textSecondary;
    final selectedColor = type == 'lost' ?AppColor.error : AppColor.secondary;
    final bgColor = type == 'lost'
        ? AppColor.errorContainer
        : AppColor.surfaceVariant;

    return GestureDetector(
      onTap: () => setState(() => _postType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : AppColor.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? selectedColor : AppColor.outline,
            width: isSelected ? 2 : 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28.sp,
              color: isSelected ? selectedColor : AppColor.muted,
            ),

             SizedBox(height: 6.h),
            
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppStyle.regular11RobotoGrey.copyWith(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isSelected ? selectedColor : AppColor.textSecondary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppStyle.regular11RobotoGrey.copyWith(
                fontSize: 11,
                color: AppColor.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      style: AppStyle.regular11RobotoGrey.copyWith(
        fontSize: 14,
        color: AppColor.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'e.g., Lost Black Wallet',
        prefixIcon: const Icon(
          Icons.title_rounded,
          size: 18,
          color: AppColor.muted,
        ),
        filled: true,
        fillColor: AppColor.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.outline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.error, width: 2),
        ),
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
      style: AppStyle.regular11RobotoGrey.copyWith(
        fontSize: 14,
        color: AppColor.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Describe the item, color, distinguishing features...',
        filled: true,
        fillColor: AppColor.surfaceVariant,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.outline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.secondary, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _categories.map((cat) {
        final label = cat['label'] as String;
        final icon = cat['icon'] as IconData;
        final isSelected = _selectedCategory == label;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = label),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColor.surface
                  : AppColor.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColor.secondary : AppColor.outline,
                width: isSelected ? 2 : 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? AppColor.secondary: AppColor.textSecondary,
                ),
                 SizedBox(width: 6.w,),
                Text(
                  label,
                  style: AppStyle.regular11RobotoGrey.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? AppColor.secondary
                        : AppColor.textSecondary,
                  ),
                ),
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
      style: AppStyle.regular11RobotoGrey.copyWith(
        fontSize: 14,
        color: AppColor.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Select or type station name',
        prefixIcon: const Icon(
          Icons.location_on_outlined,
          size: 18,
          color: AppColor.muted,
        ),
        filled: true,
        fillColor: AppColor.surfaceVariant,
        contentPadding:  EdgeInsets.symmetric(
          horizontal: 14.w,
          vertical: 14.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.outline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColor.error, width: 2),
        ),
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'Please enter the station name';
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: AppStyle.brandGradient,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    _postType == 'lost' ? 'Post Lost Item' : 'Post Found Item',
                    style: AppStyle.regular11RobotoGrey.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
