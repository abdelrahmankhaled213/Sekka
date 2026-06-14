import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Features/Profile/Profile/Logic/profile_cubit.dart';
import 'package:sekka/Features/Profile/Profile/Logic/profile_state.dart';

class ProfileFooterSectionWidget extends StatelessWidget {
  final VoidCallback onAboutUs;

  const ProfileFooterSectionWidget({
    super.key,
    required this.onAboutUs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── About Sekka ──────────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: InkWell(
            onTap: onAboutUs,
            borderRadius: BorderRadius.circular(20),
            splashColor: AppColor.grey.withAlpha(51),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColor.greyBorder,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.info_outline_rounded,
                        color: AppColor.info, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About Sekka',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                color: const Color(0xFF1A1A1A))),
                        const SizedBox(height: 2),
                        Text('App info, version & legal',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                color: const Color(0xFF9E9E9E))),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      color: Color(0xFFBDBDBD), size: 20),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ── Sign Out ──────────────────────────────────────────────────────
        BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final isLoading = state.profileStateEnum ==
                ProfileStateEnum.logoutLoading;

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: AppColor.error.withAlpha(51), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: isLoading
                    ? null
                    : () => _showLogoutDialog(context),
                borderRadius: BorderRadius.circular(20),
                splashColor: AppColor .errorContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColor.errorContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: isLoading
                            ? const Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColor.error),
                        )
                            : const Icon(Icons.logout_rounded,
                            color: AppColor.error, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign Out',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                  color: AppColor.error,
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'You\'ll need to sign in again',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                  color: AppColor.error
                                      .withAlpha(153)),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: AppColor.error.withAlpha(102),
                          size: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: Text('Sign Out',
            style: Theme.of(context).textTheme.titleLarge),
        content: Text(
          'Are you sure you want to sign out of your Sekka account?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF616161),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColor.error,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ProfileCubit>().logout();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
