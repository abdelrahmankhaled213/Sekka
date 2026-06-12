import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';
import 'package:sekka/Features/Profile/Logic/trip_history_cubit.dart';
import 'package:sekka/Features/Profile/UI/Widgets/edit_profile_bottom_sheet_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_account_section_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_footer_section_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_header_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_preferences_section_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_stats_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getProfile();
    context.read<TripHistoryCubit>().loadTrips();
  }

  // ── Sheet / dialog helpers ──────────────────────────────────────────────

  void _showEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<ProfileCubit>()),
          BlocProvider.value(value: context.read<PickImageCubit>()),
          BlocProvider.value(value: context.read<TripHistoryCubit>()),
        ],
        child: const EditProfileBottomSheetWidget(),
      ),
    );
  }

  void _showAboutUsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor.main.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.train_rounded,
                  color: AppColor.main, size: 20),
            ),
            const SizedBox(width: 12),
            Text('About Sekka',
                style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sekka v2.4.1',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColor.main,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Sekka is your intelligent metro and monorail companion. '
                  'Using IR sensors, ML-based crowd prediction, and real-time '
                  'data, we help you navigate urban transit smarter — with less '
                  'waiting, less stress, and a smaller carbon footprint.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF616161),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 Sekka Technologies. All rights reserved.',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) =>
      curr.profileStateEnum == ProfileStateEnum.logoutSuccess,
      listener: (context, state) => Navigator.pushReplacementNamed(context, AppRoute.login),
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {

            if (state.profileStateEnum ==
                ProfileStateEnum.getProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(
                    color: AppColor.main),
              );
            }

            // ── Error ─────────────────────────────────────────────────────
            if (state.profileStateEnum ==
                ProfileStateEnum.getProfileError) {
              return _ErrorView(
                message:
                state.errorMsg ?? 'Failed to load profile',
                onRetry: () =>
                    context.read<ProfileCubit>().getProfile(),
              );
            }

            // ── Content ───────────────────────────────────────────────────
            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColor.main,
                    foregroundColor: Colors.white,
                    expandedHeight: isTablet ? 220 : 200,
                    pinned: true,
                    elevation: 0,
                    scrolledUnderElevation: 2,
                    title: Text(
                      'My Profile',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: _showEditProfileSheet,
                        icon: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(51),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              size: 18, color: Colors.white),
                        ),
                        tooltip: 'Edit Profile',
                      ),
                      const SizedBox(width: 8),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProfileHeaderWidget(
                        onEditTap: _showEditProfileSheet,
                      ),
                      collapseMode: CollapseMode.parallax,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth:
                          isTablet ? 600 : double.infinity,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 0 : 16,
                            vertical: 8,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              const ProfileStatsWidget(),
                              const SizedBox(height: 20),
                              ProfileAccountSectionWidget(
                                onEditProfile: _showEditProfileSheet,
                                onViewHistory: () {},
                              ),
                              const SizedBox(height: 16),
                              const ProfilePreferencesSectionWidget(),
                              const SizedBox(height: 16),
                              ProfileFooterSectionWidget(
                                onAboutUs: _showAboutUsDialog,
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
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
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView(
      {required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 56, color: Color(0xFF9E9E9E)),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: const Color(0xFF9E9E9E))),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                  backgroundColor: AppColor.main,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
            ),
          ],
        ),
      ),
    );
  }
}