// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_text.dart';
import 'package:sekka/Core/Widget/custom_text_field.dart';
import 'package:sekka/Features/Routes/Data/Model/Transport.dart';
import 'package:sekka/Features/Routes/Logic/routes_cubit.dart';
import 'package:sekka/Features/Routes/Logic/routes_state.dart';
import 'package:sekka/core/constants/app_style.dart';
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
        position: Tween(begin: const Offset(0, .25), end: Offset.zero)
            .animate(animation),
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

  late AnimationController animationController;
  bool _isSheetOpen = false;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _scroll.addListener(() {
      if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 100) {
        if (!widget.isLoading && widget.hasMore) widget.onLoadMore();
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
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

   animationController.forward(from: 0);

 
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildSheet(),
    ).whenComplete(() => setState(() => _isSheetOpen = false));
 
if ((cubit.state.transports?.isEmpty ?? true)) {    
         await cubit.fetchTransports();
  }
 
 
  }

  Widget _buildSheet() {
    
    return BlocProvider.value(
      value: context.read<RoutesCubit>(),
      child: DraggableScrollableSheet(
        initialChildSize: .75,
        maxChildSize: .95,
        minChildSize: .5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              
              const SizedBox(height: 12),

              Container(
                height: 5.h,
                width: 40.w,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: MyTextFormField(
                  hint: AppText.search,
                  onChange: _onSearchChanged,
                  prefixIcon: Icon(Icons.search, size: 20.sp),
                ),
              ),
              SizedBox(height: 12.h),
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

        final list = state.searchResults.isEmpty
            ? state.transports ?? []
            : state.searchResults;

        if (isFirstLoad) {

          return Skeletonizer(
            containersColor: Colors.grey.shade400,
            enabled: true,
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, __) => _fakeItem(),
            ),
          );
        }

        return ListView.builder(
          controller: _scroll,
          itemCount: list.length + (isPaginationLoading ? 1 : 0),
          itemBuilder: (_, index) {
            if (index >= list.length) return _paginationLoader();

            final item = list[index];
            final selected = widget.isStart
                ? item.id == state.selectedTransportStart?.id
                : item.id == state.selectedTransportEnd?.id;

            return AnimatedListItem(
              controller: animationController,
              index: index,
              child: _RippleScaleItem(
                onTap: () {
                  widget.onSelected(item);
                  Navigator.pop(context);
                  context.read<RoutesCubit>().resetSearch();
                },
                child: _itemUI(item.name, selected),
              ),
            );
          },
        );
      },
    );
  }

  Widget _paginationLoader() => Padding(
        padding: EdgeInsets.all(20.sp),
        child: const Center(child: CircularProgressIndicator()),
      );

  Widget _fakeItem() => _itemUI("Loading station", false);

  Widget _itemUI(String name, bool selected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: selected ? context.read<RoutesCubit>().state.selectedTransportSwitching?.color1??AppColor.darkBlue.withOpacity(0.4) 
        : Colors.transparent,
        border: Border.all(
          color: selected ? context.read<RoutesCubit>().state.selectedTransportSwitching?.color1??AppColor.darkBlue 
          : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: ListTile(
        title: Text(
          name,
          style: AppStyle.regular16RobotoBlack.copyWith(
              fontSize: 14.sp, color: selected ? Colors.white : AppColor.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
 
    return BlocBuilder<RoutesCubit, RoutesState>(
 
      builder: (context, state) =>
      MyTextFormField(
        readonly: true,
        backGroundColor: AppColor.offWhite,
        hint: widget.hint,
        controller: widget.controller,
        onTap: _openSheet,
        icon: AnimatedRotation(
          turns: _isSheetOpen ? 0.5 : 0,
          duration: const Duration(milliseconds: 600),
          child: const Icon(Icons.keyboard_arrow_down, color: AppColor.grey),
        ),
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
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 120));
    _scale = Tween(begin: 1.0, end: .96)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
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
            borderRadius: BorderRadius.circular(14),
            onTap: widget.onTap,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}