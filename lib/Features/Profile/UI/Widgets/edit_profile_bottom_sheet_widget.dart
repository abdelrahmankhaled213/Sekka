import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Core/Cubit/pick_image_state.dart';
import 'package:sekka/Core/Helper/toast_helper.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Core/theme/app_theme.dart';
import 'package:sekka/Features/Auth/Data/Model/user_update.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';

class EditProfileBottomSheetWidget extends StatefulWidget {

  const EditProfileBottomSheetWidget({super.key});

  @override
  State<EditProfileBottomSheetWidget> createState() =>
      _EditProfileBottomSheetWidgetState();
}

class _EditProfileBottomSheetWidgetState
    extends State<EditProfileBottomSheetWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late List<TransportType> _selectedModes;

  static final List<Map<String, dynamic>> _transportModes = [
    {
      'type': TransportType.metro,
      'label': 'Metro',
      'icon': Icons.subway_rounded,
      'color': AppColor.main,
    },
    {
      'type': TransportType.monorail,
      'label': 'Monorail',
      'icon': Icons.tram_rounded,
      'color': AppColor.darkPurple,
    },
    {
      'type': TransportType.bus,
      'label': 'Bus',
      'icon': Icons.directions_bus_rounded,
      'color': AppColor.green,
    },
    {
      'type': TransportType.microbus,
      'label': 'Microbus',
      'icon': Icons.airport_shuttle_rounded,
      'color': AppColor.orange,
    },
  ];

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().state.userModel;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _selectedModes =
        List.from(context.read<ProfileCubit>().state.selectedTransports);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final pickImageCubit = context.read<PickImageCubit>();

    if (pickImageCubit.state.file != null) {
      // Upload image; _listenForPickImage will call editProfile when done.
      await pickImageCubit.uploadImage();
    } else {
      final request = UpdateUserRequest(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        favTrasnportation: _selectedModes,
        isGetStarted: true,
        clearImage: context.read<ProfileCubit>().state.isImageRemoved,
      );
      context.read<ProfileCubit>().editProfile(request);
    }
  }

  Future<void> _listenForPickImage(
      BuildContext context, PickImageState state) async {
    if (state.pickImageEnum == PickImageEnum.uploadImageLoaded) {
      final request = UpdateUserRequest(
        image: state.imagePathFromSupa,
        clearImage: false,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        favTrasnportation: _selectedModes,
        isGetStarted: true,
      );
      await context.read<ProfileCubit>().editProfile(request);
    } else if (state.pickImageEnum == PickImageEnum.uploadImageError) {
      FlutterToastHelper.showToast(
          text: state.errorMsg!, color: AppColor.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<PickImageCubit, PickImageState>(
      listener: _listenForPickImage,
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.profileStateEnum == ProfileStateEnum.editProfileSuccess) {
            Navigator.of(context).pop();
          } else if (state.profileStateEnum ==
              ProfileStateEnum.editProfileError) {
            FlutterToastHelper.showToast(
                text: state.errorMsg!, color: AppColor.error);
          }
        },
        child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Edit Profile',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _FieldLabel('Full Name'),
                            const SizedBox(height: 6),
                            _buildField(
                              controller: _nameController,
                              hint: 'Your full name',
                              icon: Icons.person_outline,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            _FieldLabel('Phone Number'),
                            const SizedBox(height: 6),
                            _buildField(
                              controller: _phoneController,
                              hint: '+20 100 000 0000',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Phone number is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            _FieldLabel('Email Address'),
                            const SizedBox(height: 6),
                            _buildField(
                              controller: _emailController,
                              hint: 'your.name@email.com',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              readOnly: true,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!v.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _FieldLabel('Favorite Transport Modes'),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _transportModes.map((mode) {
                                final type = mode['type'] as TransportType;
                                final isSelected = _selectedModes.contains(type);
                                final modeColor = mode['color'] as Color;

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isSelected) {
                                        if (_selectedModes.length > 1) {
                                          _selectedModes.remove(type);
                                        }
                                      } else {
                                        _selectedModes.add(type);
                                      }
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 9),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? modeColor
                                          : const Color(0xFFF5F5F5),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? modeColor
                                            : const Color(0xFFE0E0E0),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(mode['icon'] as IconData,
                                            size: 16,
                                            color: isSelected
                                                ? Colors.white
                                                : modeColor),
                                        const SizedBox(width: 6),
                                        Text(
                                          mode['label'] as String,
                                          style: theme.textTheme.labelMedium
                                              ?.copyWith(
                                            color: isSelected
                                                ? Colors.white
                                                : const Color(0xFF424242),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 28),
                            BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, state) {
                                final isSaving = state.profileStateEnum ==
                                    ProfileStateEnum.editProfileLoading;
                                return SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: FilledButton(
                                    onPressed: isSaving ? null : _handleSave,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: AppColor.main,
                                      disabledBackgroundColor:
                                      AppColor.main.withAlpha(153),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(16)),
                                    ),
                                    child: isSaving
                                        ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5),
                                    )
                                        : Text(
                                      'Save Changes',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor:
        readOnly ? const Color(0xFFF0F0F0) : const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColor.main, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColor.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColor.error, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: const Color(0xFF424242),
        fontWeight: FontWeight.w600,
      ),
    );
  }
}