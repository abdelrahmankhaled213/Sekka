import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Widget/custom_text_field.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Logic/routes_state.dart';
import 'package:skeletonizer/skeletonizer.dart';


class AnimatedListItem extends StatelessWidget {
  final int index;
  final AnimationController controller;
  final Widget child;

  const AnimatedListItem({
    super.key,
    required this.index,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(
      parent: controller,
      curve: Interval((index * .05).clamp(0, 1), 1, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position:
            Tween(begin: const Offset(0, .25), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}


class PaginatedSearchDropdown extends StatefulWidget {
  final bool isLoading;
  final bool isStart;
  final bool hasMore;
  final Future<void> Function() onLoadMore;
  final Future<void> Function(String) onSearch;
  final Function(Transport transport) onSelected;
  final String hint;
  final TextEditingController controller;

  const PaginatedSearchDropdown({
    required this.controller,
    required this.isStart,
    super.key,
    required this.isLoading,
    required this.hasMore,
    required this.onLoadMore,
    required this.onSearch,
    required this.onSelected,
    required this.hint,
  });

  @override
  State<PaginatedSearchDropdown> createState() =>
      _PaginatedSearchDropdownState();
}

class _PaginatedSearchDropdownState extends State<PaginatedSearchDropdown>
    with SingleTickerProviderStateMixin {
  final ScrollController _scroll = ScrollController();
  Timer? _debounce;
  late AnimationController _animController;
  bool _isSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 100) {
        if (!widget.isLoading && widget.hasMore) widget.onLoadMore();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _scroll.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String? value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      widget.onSearch(value ?? '');
    });
  }

  Future<void> _openSheet() async {
    final cubit = context.read<RoutesCubit>();
    setState(() => _isSheetOpen = true);
    _animController.forward(from: 0);

    cubit.resetSearch();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildSheet(),
    ).whenComplete(() {
      if (mounted) setState(() => _isSheetOpen = false);
    });

    // Always fetch fresh — cubit guards duplicate calls via isLoading flag
    await cubit.fetchTransports();
  }


  Widget _buildSheet() {
    final cubit = context.read<RoutesCubit>();
    final accentColor =
        cubit.state.selectedTransportSwitching?.color1 ?? AppColor.darkBlue;

    return BlocProvider.value(
      value: cubit,
      child: DraggableScrollableSheet(
        initialChildSize: .75,
        maxChildSize: .95,
        minChildSize: .5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(top: 12.h, bottom: 4.h),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),

              // Title row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: Row(
                  children: [
                    Icon(
                      widget.isStart
                          ? Icons.radio_button_checked
                          : Icons.location_on_rounded,
                      color: widget.isStart ? accentColor : AppColor.error,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      widget.isStart
                          ? "Start"
                          : "End",
                      style: AppStyle.regular16RobotoBlack.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey.shade100),

              // Search field
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 8.h),
                child: MyTextFormField(
                  hint: AppText.search,
                  onChange: _onSearchChanged,
                  prefixIcon: Icon(Icons.search_rounded, size: 20.sp,
                      color: Colors.grey.shade400),
                ),
              ),

              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<RoutesCubit, RoutesState>(
      builder: (context, state) {
        final isFirstLoad =
            state.isLoading && (state.transports?.isEmpty ?? true);

        final isPaginationLoading =
            state.isLoading && (state.transports?.isNotEmpty ?? false);

        final isSearchLoading = state.isSearchLoading;

        final list = state.searchResults.isNotEmpty
            ? state.searchResults
            : state.transports ?? [];

        if (isFirstLoad) {
          return Skeletonizer(
            containersColor: Colors.grey.shade300,
            enabled: true,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              itemCount: 10,
              itemBuilder: (_, __) => _fakeItem(context),
            ),
          );
        }

        if (isSearchLoading!) {
          return const Center(child: CircularProgressIndicator());
        }
        if (list.isEmpty) {
          return _EmptySearchState();
        }
        return ListView.builder(
          controller: _scroll,
          padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 24.h),
          itemCount: list.length + (isPaginationLoading ? 1 : 0),
          itemBuilder: (_, index) {
            if (index >= list.length) {
              return Padding(
                padding: EdgeInsets.all(20.sp),
                child: const Center(child: CircularProgressIndicator()),
              );
            }

            final item = list[index];
            final selected = widget.isStart
                ? item.id == state.selectedTransportStart?.id
                : item.id == state.selectedTransportEnd?.id;

            return AnimatedListItem(
              controller: _animController,
              index: index,
              child: _RippleScaleItem(
                onTap: () {
                  widget.onSelected(item);
                  Navigator.pop(context);
                  context.read<RoutesCubit>().resetSearch();
                },
                child: _itemUI(context, item.name, selected),
              ),
            );
          },
        );
      },
    );
  }

  Widget _fakeItem(BuildContext context) => _itemUI(context, 'Loading station name', false);

  Widget _itemUI(BuildContext context, String name, bool selected) {
    final accentColor =
        context.read<RoutesCubit>().state.selectedTransportSwitching?.color1 ??
            AppColor.darkBlue;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      decoration: BoxDecoration(
        color: selected ? accentColor.withOpacity(0.1) : Colors.transparent,
        border: Border.all(
          color: selected ? accentColor : Colors.transparent,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
        leading: Icon(
          Icons.place_outlined,
          size: 18.sp,
          color: selected ? accentColor : Colors.grey.shade400,
        ),
        title: Text(
          name,
          style: AppStyle.regular16RobotoBlack.copyWith(
            fontSize: 14.sp,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            color: selected ? accentColor : AppColor.black,
          ),
        ),
        trailing: selected
            ? Icon(Icons.check_circle_rounded, color: accentColor, size: 16.sp)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoutesCubit, RoutesState>(
      builder: (context, state) => MyTextFormField(
        readonly: true,
        backGroundColor: AppColor.offWhite,
        hint: widget.hint,
        controller: widget.controller,
        onTap: _openSheet,
        icon: AnimatedRotation(
          turns: _isSheetOpen ? 0.5 : 0,
          duration: const Duration(milliseconds: 400),
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty search state
// ─────────────────────────────────────────────────────────────────────────────

class _EmptySearchState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded,
              size: 48, color: Colors.grey.shade300),
          SizedBox(height: 12.h),
          Text(
            'No stops found',
            style: AppStyle.regular16RobotoBlack.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF444444),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Try a different name',
            style: AppStyle.w60012RobotoGrey.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}


class _RippleScaleItem extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const _RippleScaleItem({required this.child, required this.onTap});

  @override
  State<_RippleScaleItem> createState() => _RippleScaleItemState();
}

class _RippleScaleItemState extends State<_RippleScaleItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween(begin: 1.0, end: .97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12.r),
            onTap: widget.onTap,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}