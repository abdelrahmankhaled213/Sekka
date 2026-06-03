import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/transport_type_helper.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
import 'package:sekka/Core/Localization/locale_cubit.dart';
import 'package:sekka/core/theme/app_colors.dart';
import 'package:sekka/core/theme/app_radius.dart';
import 'package:sekka/core/theme/app_spacing.dart';
import 'package:sekka/core/theme/app_text_styles.dart';
import 'package:sekka/core/widgets/app_button.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';
import 'package:sekka/Features/Profile/UI/Widgets/preferred_transport_section.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_section_card.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_stack_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenView extends StatelessWidget {
  
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final user = state.userModel;
        final preferred = user?.favTrasnportation ?? const <TransportType>[];
        final recentTrips = const [
          ('Central Station -> University Station', 'May 1', 'Metro', '\$2.50'),
          ('Airport Hub -> Downtown Plaza', 'Apr 30', 'Monorail', '\$4.00'),
          ('Market Square -> Shopping Center', 'Apr 29', 'Bus', '\$1.50'),
        ];

        return CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: ProfileStack()),
            SliverToBoxAdapter(
  child: Transform.translate(
                offset: Offset(0, -AppSpacing.xl.h),
                child: Column(
                  children: [
                    SizedBox(height: AppSpacing.lg.h),
                    Padding(
                      padding: AppSpacing.horizontalLG,
                      child: preferred.isEmpty
                          ? const PreferredTransportSection()
                          : _PreferredTransportDynamic(preferred: preferred),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    Padding(
                      padding: AppSpacing.horizontalLG,
                      child: _RecentTripsSection(recentTrips: recentTrips),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    Padding(
                      padding: AppSpacing.horizontalLG,
                      child: _ActionsSection(
                        onAboutUsTap: _openWebsite,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg.h),
                    Padding(
                      padding: AppSpacing.horizontalLG,
                      child: _LogoutButton(),
  ),
                    SizedBox(height: AppSpacing.xxl.h),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openWebsite(BuildContext context) async {

    final uri = Uri.parse('https://sekka.up.railway.app/');
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppText.somethingWentWrong)),
      );
    }
  }
}



class _PreferredTransportDynamic extends StatelessWidget {

  const _PreferredTransportDynamic({required this.preferred});

  final List<TransportType?> preferred;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
  Text(AppText.preferredTransport, style: AppTextStyles.titleMedium(context)),
          SizedBox(height: AppSpacing.xl.h),
  Wrap(
            spacing: AppSpacing.md.w,
            runSpacing: AppSpacing.md.h,
            children: preferred.map((type) {
  return Container(
                width: 80.w,
                padding: EdgeInsets.all(AppSpacing.md.sp),
                decoration: BoxDecoration(
                  color: TransportUIHelper.color(type!).withOpacity(0.2),
                  borderRadius: AppRadius.allXL,
                  border: Border.all(color: TransportUIHelper.color(type)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
  Icon(TransportUIHelper.icon(type), color: TransportUIHelper.color(type), size: 18.sp),
                    SizedBox(height: AppSpacing.sm.h),
                    Text(TransportUIHelper.label(type), style: AppTextStyles.labelMedium(context)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }



}

class _RecentTripsSection extends StatelessWidget {
  const _RecentTripsSection({required this.recentTrips});

  final List<(String title, String date, String mode, String price)> recentTrips;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        children: [
  Row(
            children: [
              Icon(Icons.history, size: 18.sp, color: AppColors.grey),
              SizedBox(width: AppSpacing.sm.w),
              Text(AppText.recentTrips, style: AppTextStyles.labelLarge(context)),
              const Spacer(),
              Text(AppText.seeAll, style: AppTextStyles.labelSmall(context).copyWith(color: AppColors.primary)),
            ],
          ),
          SizedBox(height: AppSpacing.md.h),
          ...recentTrips.map((trip) {
  return Container(
              margin: EdgeInsets.only(bottom: AppSpacing.md.h),
              padding: EdgeInsets.all(AppSpacing.md.sp),
              decoration: BoxDecoration(
                color: AppColors.offWhite,
                borderRadius: AppRadius.allLG,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
  Text(trip.$1, style: AppTextStyles.labelSmall(context)),
                        SizedBox(height: AppSpacing.xs.h),
                        Text('${trip.$2} - ${trip.$3}', style: AppTextStyles.caption(context)),
                      ],
                    ),
                  ),
  Text(trip.$4, style: AppTextStyles.labelMedium(context)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ActionsSection extends StatelessWidget {
  const _ActionsSection({required this.onAboutUsTap});

  final Future<void> Function(BuildContext context) onAboutUsTap;

  @override
  Widget build(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final isArabic = context.watch<LocaleCubit>().state.languageCode == 'ar';

    return ProfileSectionCard(
      child: Column(
        children: [
          _ActionRow(
            icon: Icons.info_outline,
            title: AppText.aboutUs,
            onTap: () => onAboutUsTap(context),
          ),
          _ActionRow(
            icon: Icons.language,
            title: AppText.language,
  trailing: Switch(
              value: isArabic,
              activeColor: AppColors.primary,
              onChanged: (_) => localeCubit.toggleLanguage(),
            ),
          ),
          _ActionRow(
            icon: Icons.notifications_none,
            title: AppText.notificationsTitle,
  trailing: Container(
              padding: AppSpacing.horizontalLG,
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.2),
                borderRadius: AppRadius.allXL,
              ),
              child: Text(AppText.onLabel, style: AppTextStyles.caption(context).copyWith(color: AppColors.darkGreen)),
            ),
          ),
          _ActionRow(icon: Icons.settings_outlined, title: AppText.settings),
          _ActionRow(icon: Icons.help_outline, title: AppText.helpAndSupport, showChevron: false),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.showChevron = true,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
  return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.allMD,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm.h),
        child: Row(
  children: [
            Icon(icon, size: 18.sp, color: AppColors.grey),
            SizedBox(width: AppSpacing.md.w),
            Expanded(child: Text(title, style: AppTextStyles.labelLarge(context))),
            if (trailing != null) trailing!,
            if (showChevron && trailing == null) Icon(Icons.chevron_right, color: AppColors.grey, size: 18.sp),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.profileStateEnum == ProfileStateEnum.logoutSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
        if (state.profileStateEnum == ProfileStateEnum.logoutError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMsg ?? AppText.somethingWentWrong)),
          );
        }
      },
      builder: (context, state) {
        return AppButton(
          text: AppText.logOut,
          variant: AppButtonVariant.secondary,
          icon: Icons.logout,
          fullWidth: true,
          isLoading: state.profileStateEnum == ProfileStateEnum.logoutLoading,
          onPressed: () {
            _showLogoutDialog(context);
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppText.logOut),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().logout();
            },
            child: Text('Logout', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}