// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sekka/Core/Constants/app_color.dart';
// import 'package:sekka/Core/Constants/app_route.dart';
// import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
// import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
// import 'package:sekka/Features/Profile/Logic/profile_state.dart';
// import 'package:sekka/Features/Profile/Logic/trip_history_cubit.dart';
// import 'package:sekka/Features/Profile/UI/Widgets/edit_profile_bottom_sheet_widget.dart';
// import 'package:sekka/Features/Profile/UI/Widgets/notfication_perf.dart';
// import 'package:sekka/Features/Profile/UI/Widgets/profile_account_section_widget.dart';
// import 'package:sekka/Features/Profile/UI/Widgets/profile_footer_section_widget.dart';
// import 'package:sekka/Features/Profile/UI/Widgets/profile_header_widget.dart';
// import 'package:sekka/Features/Profile/UI/Widgets/profile_stats_widget.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../Logic/trip_history_state.dart';
// import 'Widgets/profile_preferences_section_widget.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<ProfileCubit>().getProfile();
//     context.read<TripHistoryCubit>().loadTrips();
//   }

//   // ── Sheet / dialog helpers ──────────────────────────────────────────────

//   void _showEditProfileSheet() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => MultiBlocProvider(
//         providers: [
//           BlocProvider.value(value: context.read<ProfileCubit>()),
//           BlocProvider.value(value: context.read<PickImageCubit>()),
//           BlocProvider.value(value: context.read<TripHistoryCubit>()),
//         ],
//         child: const EditProfileBottomSheetWidget(),
//       ),
//     );
//   }

//   void _showDeleteImageConfirmation() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         title: const Text('Delete Profile Picture?'),
//         content: const Text(
//           'Are you sure you want to delete your profile picture? This action cannot be undone.',
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('Cancel'),
//           ),
//           FilledButton(
//             style: FilledButton.styleFrom(
//               backgroundColor: Colors.red,
//             ),
//             onPressed: () async {
//          await context.read<ProfileCubit>().deleteProfileImage();
//               Navigator.of(ctx).pop();

//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }





//   void _showTripHistory() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (_) => BlocProvider.value(
//         value: context.read<TripHistoryCubit>(),
//         child: const _TripHistoryBottomSheet(),
//       ),
//     );
//   }

//   // ── About Us Dialog مع Link ─────────────────────────────────────────────
//   void _showAboutUsDialog() {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20.r),
//         ),
//         title: Row(
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: AppColor.main.withAlpha(30),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const Icon(Icons.train_rounded,
//                   color: AppColor.main, size: 20),
//             ),
//             const SizedBox(width: 12),
//             Text('About Sekka',
//                 style: Theme.of(context).textTheme.titleLarge),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Sekka v2.4.1',
//               style: Theme.of(context).textTheme.labelMedium?.copyWith(
//                 color: AppColor.main,
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'Sekka is your intelligent metro and monorail companion. '
//               'Using IR sensors, ML-based crowd prediction, and real-time '
//               'data, we help you navigate urban transit smarter — with less '
//               'waiting, less stress, and a smaller carbon footprint.',
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                 color: const Color(0xFF616161),
//                 height: 1.6,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               '© 2026 Sekka Technologies. All rights reserved.',
//               style: Theme.of(context).textTheme.labelSmall?.copyWith(
//                 color: const Color(0xFF9E9E9E),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('Later'),
//           ),
//           FilledButton(
//             style: FilledButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             onPressed: () async {
//             await  _launchWebsite();
//               Navigator.of(ctx).pop();
//             },
//             child: const Text('Visit Website'),
//           ),
//         ],
//       ),
//     );
//   }

//   // ── Launch Website ───────────────────────────────────────────────────────
  

//   // ── Launch Website ───────────────────────────────────────────────────────
//   Future<void> _launchWebsite() async {
//     final Uri url = Uri.parse('https://sekka8.netlify.app/');
    
//     try {
//       // بنجرب نفتح اللينك مباشرة في متصفح خارجي
//       final bool launched = await launchUrl(
//         url,
//         mode: LaunchMode.externalApplication,
//       );
      
//       if (!launched && mounted) {
//         _showErrorSnackBar('Could not open website');
//       }
//     } catch (e) {
//       if (mounted) {
//         _showErrorSnackBar('Error: $e');
//       }
//     }
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: const Duration(seconds: 2),
//         backgroundColor: Colors.redAccent,
//       ),
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isTablet = MediaQuery.of(context).size.width >= 600;

//     return BlocListener<ProfileCubit, ProfileState>(
//       listenWhen: (prev, curr) =>
//           curr.profileStateEnum == ProfileStateEnum.logoutSuccess,
//       listener: (context, state) =>
//           Navigator.pushReplacementNamed(context, AppRoute.authWrapper),
//       child: Scaffold(
//         body: BlocBuilder<ProfileCubit, ProfileState>(
//           builder: (context, state) {
//             if (state.profileStateEnum ==
//                 ProfileStateEnum.getProfileLoading) {
//               return const Center(
//                 child: CircularProgressIndicator(
//                   color: AppColor.main,
//                 ),
//               );
//             }

//             if (state.profileStateEnum ==
//                 ProfileStateEnum.getProfileError) {
//               return _ErrorView(
//                 message: state.errorMsg ?? 'Failed to load profile',
//                 onRetry: () =>
//                     context.read<ProfileCubit>().getProfile(),
//               );
//             }

//             return SafeArea(
//               child: CustomScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 slivers: [
//                   SliverAppBar(
//                     backgroundColor: AppColor.main,
//                     foregroundColor: Colors.white,
//                     expandedHeight: isTablet ? 220 : 200,
//                     pinned: true,
//                     elevation: 0,
//                     scrolledUnderElevation: 2,
//                     title: Text(
//                       'My Profile',
//                       style: theme.textTheme.titleLarge?.copyWith(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     actions: [
//                       IconButton(
//                         onPressed: _showEditProfileSheet,
//                         icon: Container(
//                           padding: const EdgeInsets.all(6),
//                           decoration: BoxDecoration(
//                             color: Colors.white.withAlpha(51),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: const Icon(Icons.edit_rounded,
//                               size: 18, color: Colors.white),
//                         ),
//                         tooltip: 'Edit Profile',
//                       ),
//                       const SizedBox(width: 8),
//                     ],
//                     flexibleSpace: FlexibleSpaceBar(
//                       background: ProfileHeaderWidget(
//                         onEditTap: _showEditProfileSheet,
//                         onDeleteImageTap: _showDeleteImageConfirmation,
//                       ),
//                       collapseMode: CollapseMode.parallax,
//                     ),
//                   ),
//                   SliverToBoxAdapter(
//                     child: Center(
//                       child: ConstrainedBox(
//                         constraints: BoxConstraints(
//                           maxWidth:
//                               isTablet ? 600 : double.infinity,
//                         ),
//                         child: Padding(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: isTablet ? 0 : 16,
//                             vertical: 8,
//                           ),
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 8),
//                               const ProfileStatsWidget(),
//                               const SizedBox(height: 20),
//                               ProfileAccountSectionWidget(
//                                 onEditProfile: _showEditProfileSheet,
//                                 onViewHistory: _showTripHistory,
//                               ),
//                               const SizedBox(height: 16),
//                               const ProfilePreferencesSectionWidget(),
//                               const SizedBox(height: 16),
//                               const NotificationPreferencesWidget(),
//                               const SizedBox(height: 16),
//                               ProfileFooterSectionWidget(
//                                 onAboutUs: _showAboutUsDialog,
//                               ),
//                               const SizedBox(height: 32),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// // ── Trip History Bottom Sheet ───────────────────────────────────────────
// class _TripHistoryBottomSheet extends StatelessWidget {
//   const _TripHistoryBottomSheet();

//   @override
//   Widget build(BuildContext context) {
//     return DraggableScrollableSheet(
//       initialChildSize: 0.7,
//       minChildSize: 0.5,
//       maxChildSize: 0.9,
//       builder: (context, scrollController) {
//         return Container(
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(20),
//             ),
//           ),
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Trip History Overview',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: BlocBuilder<TripHistoryCubit, TripHistoryState>(
//                   builder: (context, state) {
//                     if (state.tripStateEnum == TripStateEnum.loading) {
//                       return const Center(
//                         child: CircularProgressIndicator(
//                           color: AppColor.main,
//                         ),
//                       );
//                     }

//                     return SingleChildScrollView(
//                       controller: scrollController,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             GridView.count(
//                               crossAxisCount: 2,
//                               shrinkWrap: true,
//                               physics:
//                                   const NeverScrollableScrollPhysics(),
//                               mainAxisSpacing: 12,
//                               crossAxisSpacing: 12,
//                               children: [
//                                 _StatCard(
//                                   title: 'Total Trips',
//                                   count: state.totalTripsCount,
//                                   icon: Icons.train_rounded,
//                                   color: AppColor.main,
//                                 ),
//                                 _StatCard(
//                                   title: 'Metro',
//                                   count: state.metroTripsCount,
//                                   icon: Icons.directions_subway,
//                                   color: Colors.blue,
//                                 ),
//                                 _StatCard(
//                                   title: 'Monorail',
//                                   count: state.monorailTripsCount,
//                                   icon: Icons.train_rounded,
//                                   color: Colors.orange,
//                                 ),
//                                 _StatCard(
//                                   title: 'Bus',
//                                   count: state.busTripsCount,
//                                   icon: Icons.directions_bus,
//                                   color: Colors.green,
//                                 ),
//                                 _StatCard(
//                                   title: 'Microbus',
//                                   count: state.microbusTripsCount,
//                                   icon: Icons.directions_bus,
//                                   color: Colors.purple,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final String title;
//   final int count;
//   final IconData icon;
//   final Color color;

//   const _StatCard({
//     required this.title,
//     required this.count,
//     required this.icon,
//     required this.color,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color.withAlpha(15),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: color.withAlpha(30),
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: color, size: 24),
//           const SizedBox(height: 8),
//           Text(
//             '$count',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.w700,
//               color: color,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             title,
//             style: const TextStyle(
//               fontSize: 12,
//               color: Colors.grey,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _ErrorView extends StatelessWidget {
//   final String message;
//   final VoidCallback onRetry;

//   const _ErrorView({
//     required this.message,
//     required this.onRetry,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.wifi_off_rounded,
//                 size: 56, color: Color(0xFF9E9E9E)),
//             const SizedBox(height: 16),
//             Text(message,
//                 textAlign: TextAlign.center,
//                 style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: const Color(0xFF9E9E9E))),
//             const SizedBox(height: 24),
//             FilledButton.icon(
//               onPressed: onRetry,
//               icon: const Icon(Icons.refresh_rounded),
//               label: const Text('Retry'),
//               style: FilledButton.styleFrom(
//                 backgroundColor: AppColor.main,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Cubit/pick_image_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Logic/profile_state.dart';
import 'package:sekka/Features/Profile/Logic/trip_history_cubit.dart';
import 'package:sekka/Features/Profile/UI/Widgets/edit_profile_bottom_sheet_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/notfication_perf.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_account_section_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_footer_section_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_header_widget.dart';
import 'package:sekka/Features/Profile/UI/Widgets/profile_stats_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Logic/trip_history_state.dart';
import 'Widgets/profile_preferences_section_widget.dart';

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

  void _showDeleteImageConfirmation() {
    // بناخد نسخة من الـ Cubit برة عشان نضمن الـ Context الأصلي للشاشة
    final profileCubit = context.read<ProfileCubit>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Delete Profile Picture?'),
        content: const Text(
          'Are you sure you want to delete your profile picture? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              // بنقفل الـ Dialog فوراً والـ Cubit هيمسح في الخلفية والـ UI هيحدث نفسه بالتبعية
              Navigator.of(ctx).pop();
              profileCubit.deleteProfileImage();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showTripHistory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<TripHistoryCubit>(),
        child: const _TripHistoryBottomSheet(),
      ),
    );
  }

  void _showAboutUsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColor.main.withAlpha(30),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.train_rounded, color: AppColor.main, size: 20),
            ),
            const SizedBox(width: 12),
            Text('About Sekka', style: Theme.of(context).textTheme.titleLarge),
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
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Later'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              // بنقفل الـ Dialog الأول وبعدها نفتح الويب سايت منعاً لأي تعليق في الـ Context
              Navigator.of(ctx).pop();
              _launchWebsite();
            },
            child: const Text('Visit Website'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchWebsite() async {
    final Uri url = Uri.parse('https://sekka8.netlify.app/');
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        _showErrorSnackBar('Could not open website');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Error: $e');
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (prev, curr) => curr.profileStateEnum == ProfileStateEnum.logoutSuccess,
      listener: (context, state) => Navigator.pushReplacementNamed(context, AppRoute.authWrapper),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<ProfileCubit, ProfileState>(
            buildWhen: (prev, curr) =>
                curr.profileStateEnum == ProfileStateEnum.getProfileLoading ||
                curr.profileStateEnum == ProfileStateEnum.getProfileError ||
                curr.profileStateEnum == ProfileStateEnum.getProfileSuccess ||
                curr.profileStateEnum == ProfileStateEnum.imageDeleteSuccess, // بنسمع للنجاح هنا عشان يحدث الـ UI كله
            builder: (context, state) {
              if (state.profileStateEnum == ProfileStateEnum.getProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.main),
                );
              }

              if (state.profileStateEnum == ProfileStateEnum.getProfileError) {
                return _ErrorView(
                  message: state.errorMsg ?? 'Failed to load profile',
                  onRetry: () => context.read<ProfileCubit>().getProfile(),
                );
              }

              // الشاشة الأساسية بتتبني لما الداتا تكون جاهزة ومبتتحذفش مع الـ Loading الخفيف
              return CustomScrollView(
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
                          child: const Icon(Icons.edit_rounded, size: 18, color: Colors.white),
                        ),
                        tooltip: 'Edit Profile',
                      ),
                      const SizedBox(width: 8),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: ProfileHeaderWidget(
                        onEditTap: _showEditProfileSheet,
                        onDeleteImageTap: _showDeleteImageConfirmation,
                      ),
                      collapseMode: CollapseMode.parallax,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: isTablet ? 600 : double.infinity,
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
                                onViewHistory: _showTripHistory,
                              ),
                              const SizedBox(height: 16),
                              const ProfilePreferencesSectionWidget(),
                              const SizedBox(height: 16),
                              const NotificationPreferencesWidget(),
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
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── Trip History Bottom Sheet ───────────────────────────────────────────
class _TripHistoryBottomSheet extends StatelessWidget {
  const _TripHistoryBottomSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Trip History Overview',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<TripHistoryCubit, TripHistoryState>(
                  builder: (context, state) {
                    if (state.tripStateEnum == TripStateEnum.loading) {
                      return const Center(
                        child: CircularProgressIndicator(color: AppColor.main),
                      );
                    }

                    return SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: [
                                _StatCard(
                                  title: 'Total Trips',
                                  count: state.totalTripsCount,
                                  icon: Icons.train_rounded,
                                  color: AppColor.main,
                                ),
                                _StatCard(
                                  title: 'Metro',
                                  count: state.metroTripsCount,
                                  icon: Icons.directions_subway,
                                  color: Colors.blue,
                                ),
                                _StatCard(
                                  title: 'Monorail',
                                  count: state.monorailTripsCount,
                                  icon: Icons.train_rounded,
                                  color: Colors.orange,
                                ),
                                _StatCard(
                                  title: 'Bus',
                                  count: state.busTripsCount,
                                  icon: Icons.directions_bus,
                                  color: Colors.green,
                                ),
                                _StatCard(
                                  title: 'Microbus',
                                  count: state.microbusTripsCount,
                                  icon: Icons.directions_bus,
                                  color: Colors.purple,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: Color(0xFF9E9E9E)),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: const Color(0xFF9E9E9E))),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColor.main,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}