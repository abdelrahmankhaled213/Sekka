import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Helper/transport_ui_helper.dart';
import 'package:sekka/Core/Localization/locale_cubit.dart';
import 'package:sekka/Features/Auth/Logic/transport_model.dart';
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
                offset: Offset(0, -14.h),
                child: Column(
                  
                  children: [
                    
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: preferred.isEmpty
                          ? const PreferredTransportSection()
                          : _PreferredTransportDynamic(preferred: preferred),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _RecentTripsSection(recentTrips: recentTrips),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _ActionsSection(
                        onAboutUsTap: _openWebsite,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: _LogoutButton(),
                    ),
                    SizedBox(height: 24.h),
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

  final List<TransportType> preferred;

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Text(AppText.preferredTransport, style: AppStyle.regular16RobotoBlack),

          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: preferred.map((type) {
              return Container(
                width: 80.w,
                padding: EdgeInsets.all(10.sp),
                decoration: BoxDecoration(
                  color: TransportUIHelper.color(type).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: TransportUIHelper.color(type)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(TransportUIHelper.icon(type), color: TransportUIHelper.color(type), size: 18.sp),
                    SizedBox(height: 8.h),
                    Text(TransportUIHelper.label(type), style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 13.sp)),
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
              Icon(Icons.history, size: 18.sp, color: AppColor.grey),
              SizedBox(width: 8.w),
              Text(AppText.recentTrips, style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 14.sp)),
              const Spacer(),
              Text(AppText.seeAll, style: AppStyle.regular16RobotoGrey.copyWith(color: AppColor.main, fontSize: 12.sp)),
            ],
          ),
          SizedBox(height: 12.h),
          ...recentTrips.map((trip) {
            return Container(
              margin: EdgeInsets.only(bottom: 10.h),
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: AppColor.offWhite,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trip.$1, style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 12.sp)),
                        SizedBox(height: 4.h),
                        Text('${trip.$2} - ${trip.$3}', style: AppStyle.regular11RobotoGrey),
                      ],
                    ),
                  ),
                  Text(trip.$4, style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 13.sp)),
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
              activeColor: AppColor.main,
              onChanged: (_) => localeCubit.toggleLanguage(),
            ),
          ),
          _ActionRow(
            icon: Icons.notifications_none,
            title: AppText.notificationsTitle,
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppColor.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Text(AppText.onLabel, style: AppStyle.regular11RobotoGrey.copyWith(color: AppColor.darkGreen)),
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
      borderRadius: BorderRadius.circular(10.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: AppColor.grey),
            SizedBox(width: 10.w),
            Expanded(child: Text(title, style: AppStyle.regular16RobotoBlack.copyWith(fontSize: 14.sp))),
            if (trailing != null) trailing!,
            if (showChevron && trailing == null) Icon(Icons.chevron_right, color: AppColor.grey, size: 18.sp),
          ],
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColor.errorContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout, color: AppColor.error, size: 18.sp),
          SizedBox(width: 8.w),
          Text(AppText.logOut, style: AppStyle.regular16RobotoBlack.copyWith(color: AppColor.error)),
        ],
      ),
    );
  }
}