import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/category_ui.dart';

class CreatePostModalWidget extends StatefulWidget {


  const CreatePostModalWidget({super.key});

  @override
  State<CreatePostModalWidget> createState() => _CreatePostModalWidgetState();
}

class _CreatePostModalWidgetState extends State<CreatePostModalWidget> {
  
  ItemType? _postType; 
  Category? _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _stationController = TextEditingController();


  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _stationController.dispose();
    super.dispose();
  }

void _buildScafoldMessenger(String text,Color color) {
  
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
      );
    
}
  Future<void> _submit() async {

  if (!_formKey.currentState!.validate()) return;

  if (_postType == null) {
    _buildScafoldMessenger("Please choose post type",AppColor.error);
    return;
  }

  if (_selectedCategory == null) {
    _buildScafoldMessenger("Please select a category",AppColor.error);
    return;
  }


  final post = ItemModel(
    isActive: true , 
    createdAt: DateTime.now().toIso8601String(),
    userId: FirebaseAuth.instance.currentUser!.uid,
    category: _selectedCategory!,
    title: _titleController.text.trim(),
    description: _descriptionController.text.trim(),
    stationName: _stationController.text.trim(),
    type: _postType!,
  );

await context.read<LostAndFoundCubit>().postLostAndFound(post);


}

@override
Widget build(BuildContext context) {
  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

  return Container(
    
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.9,
    ),
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
          width: 40.w, height: 40.h,
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(51),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.inventory_2_rounded, color: Colors.white, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Post', style: AppStyle.regular18RobotoWhite.copyWith(fontSize: 17.sp, fontWeight: FontWeight.w800,fontFamily: 'Roboto', color: Colors.white)),
              Text('Report lost or found item', style: AppStyle.regular18RobotoWhite.copyWith(fontSize: 12.sp, 
              fontFamily: 'Roboto',color: Colors.white.withAlpha(217))),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 36.w, height: 36.h,
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
        Expanded(
          child: _buildTypeCard(
            ItemType.lost,
            Icons.error_outline_rounded,
            'I Lost\nSomething',
            'Report a lost item',
          ),
        ),
         
         SizedBox(width: 12.w),

        Expanded(
          child: _buildTypeCard(
           ItemType.found,
            Icons.inventory_2_outlined,
            'I Found\nSomething',
            'Report a found item',
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard(
    ItemType type,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = _postType == type;
    final color = type == ItemType.lost ? AppColor.error : AppColor.textSecondary;
    final selectedColor = type == ItemType.lost ?AppColor.error : AppColor.secondary;
    final bgColor = type == ItemType.lost
        ? AppColor.errorContainer
        : AppColor.surfaceVariant;

    return GestureDetector(
      onTap: () => setState(() => _postType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:  EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: isSelected ? bgColor : AppColor.surfaceVariant,
          borderRadius: BorderRadius.circular(14.r),
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
             
             SizedBox(height: 3.h),

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
        prefixIcon:  Icon(
          Icons.title_rounded,
          size: 18.sp,
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
        fontSize: 14.sp,
        color: AppColor.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Describe the item, color, distinguishing features...',
        filled: true,
        fillColor: AppColor.surfaceVariant,
        contentPadding:  EdgeInsets.all(14.sp),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColor.outline, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColor.outline, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColor.secondary, width: 2),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((cat) {

        final isSelected = _selectedCategory == cat.type ;
       
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat.type),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:  EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
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
                  cat.icon,
                  size: 16.sp,
                  color: isSelected ? AppColor.secondary: AppColor.textSecondary,
                ),
                
                 SizedBox(width: 6.w,),
                
                Text(
                  cat.label,
                  style: AppStyle.regular11RobotoGrey.copyWith(
                    fontSize: 13.sp,
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
        fontSize: 14.sp,
        color: AppColor.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: 'Select or type station name',
        prefixIcon:  Icon(
          Icons.location_on_outlined,
          size: 18.sp,
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
      height: 50.h,
      child: BlocConsumer<LostAndFoundCubit, LostFoundState>(
        
        listener: (context, state)  {
          if(state.status == LostFoundStatus.addPostsuccess){
  context.read<LostAndFoundCubit>().getPosts();
          _buildScafoldMessenger("Item posted successfully", AppColor.success);
          Navigator.pop(context);
          } 
        if(state.status == LostFoundStatus.addPostfailure){
          _buildScafoldMessenger(state.errorMsg!,AppColor.error); 
        }
        },
        
        
        builder: (BuildContext context, LostFoundState state) {

       return 
      state.status == LostFoundStatus.addPostloading ? Center(
        child: const CircularProgressIndicator(
        color: AppColor.secondary,
      )) 
      : ElevatedButton(

          onPressed:  _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: AppStyle.brandGradient,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Container(
              alignment: Alignment.center,
              child: 
                    Text(
                      _postType == ItemType.lost ? 'Post Lost Item' : 'Post Found Item',
                      style: AppStyle.regular11RobotoGrey.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        );
          
          },

buildWhen:(previous, current) {

      return current.status == LostFoundStatus.addPostloading
          || current.status == LostFoundStatus.addPostsuccess 
          || current.status == LostFoundStatus.addPostfailure;
          
} ,

      ),
    );
  }


}
