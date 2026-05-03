import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Widget/empty_state_widget.dart';
import 'package:sekka/Features/LostAndFound/Data/Model/item.model.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found_state.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/create_post_model_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/home_header_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/home_search_filter_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/home_stats.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/post_card_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen>
    with SingleTickerProviderStateMixin {
  String _activeFilter = 'All';
  String _activeCategory = 'All';
  String _searchQuery = '';

  bool _showFab = true;
  late ScrollController _scrollController;
  late AnimationController _fabAnimController;

  @override
  void initState() {
    super.initState();

    context.read<LostAndFoundCubit>().getPosts();

    _scrollController = ScrollController();
    _fabAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fabAnimController.forward();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final direction = _scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse && _showFab) {
      setState(() => _showFab = false);
      _fabAnimController.reverse();
    } else if (direction == ScrollDirection.forward && !_showFab) {
      setState(() => _showFab = true);
      _fabAnimController.forward();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _fabAnimController.dispose();
    super.dispose();
  }

  void _openCreatePostModal(BuildContext context) {
    final cubit = context.read<LostAndFoundCubit>();
    showModalBottomSheet(

      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: const CreatePostModalWidget(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;

    return BlocBuilder<LostAndFoundCubit, LostFoundState>(
      builder: (context, state) {
        final allItems = state.items ?? [];

    final filteredItems = allItems.where((post) {
          final matchesFilter = _activeFilter == 'All' ||
              (_activeFilter == 'Lost' && post.type == ItemType.lost) ||
              (_activeFilter == 'Found' && post.type == ItemType.found);

          final matchesCategory = _activeCategory == 'All' ||
              post.category.name.toLowerCase() == _activeCategory.toLowerCase();

          final matchesSearch = _searchQuery.isEmpty ||
              post.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              post.stationName.toLowerCase().contains(_searchQuery.toLowerCase());

          return matchesFilter && matchesCategory && matchesSearch;
        }).toList();

        final lostCount = allItems.where((e) => e.type == ItemType.lost).length;
        final foundCount = allItems.where((e) => e.type == ItemType.found).length;

        final bool isInitialLoading = state.status == LostFoundStatus.getPostLoading && allItems.isEmpty;

        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async => await context.read<LostAndFoundCubit>().getPosts(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: HomeHeaderWidget(
                    onAddPressed: () => _openCreatePostModal(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: HomeSearchFilterWidget(
                    activeFilter: _activeFilter,
                    activeCategory: _activeCategory,
                    searchQuery: _searchQuery,
                    onFilterChanged: (f) => setState(() => _activeFilter = f),
                    onCategoryChanged: (c) => setState(() => _activeCategory = c),
                    onSearchChanged: (q) => setState(() => _searchQuery = q),
                  ),
                ),
                
                SliverToBoxAdapter(
                  child: HomeStatsWidget(
                    lostCount: lostCount,
                    foundCount: foundCount,
                  ),
                ),

                
                if (isInitialLoading)
                  Skeletonizer.sliver(
                    enabled: true,
                    child: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildPostCard(_dummyItem(), index, isSkeleton: true),
                        childCount: 5,
                      ),
                    ),
                  )
                
                
                else if (state.status == LostFoundStatus.getPostFailure && allItems.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      icon: Icons.error_outline,
                      title: 'Failure to load posts',
                      description: 'Please try again later',
                      ctaLabel: 'Try again',
                      onCta: () => context.read<LostAndFoundCubit>().getPosts(),
                    ),
                  )

                 else if (filteredItems.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'There are no posts',
                      description: 'There are no posts matching your search criteria',
                      ctaLabel: 'Create a post',
                      onCta: () => _openCreatePostModal(context),
                    ),
                  )

              
                else
                  isTablet
                      ? SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildPostCard(filteredItems[index], index),
                              childCount: filteredItems.length,
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding:  EdgeInsets.only(bottom: 100.h),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => _buildPostCard(filteredItems[index], index),
                              childCount: filteredItems.length,
                            ),
                          ),
                        ),
              ],
            ),
          ),
        );
      },
    );
  }

  ItemModel _dummyItem() {
    return ItemModel(
      id: -1, 
      title: 'Loading Title Header',
      description: 'This is a long loading description for skeletonizer',
      type: ItemType.lost,
      createdAt: DateTime.now().toIso8601String(),
      category: Category.phone,
      stationName: 'Loading Station',
      userId: '0',
    );
  }

  Widget _buildPostCard(ItemModel post, int index, {bool isSkeleton = false}) {
    return TweenAnimationBuilder<double>(
      
      key: ValueKey(post.id == -1 ? "skeleton_$index" : post.id),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: isSkeleton ? 200 : 350 + (index * 40).clamp(0, 200)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 15 * (1 - value)),
            child: child,
          ),
        );
      },
      child: PostCardWidget(
        postData: post,
        onTap: isSkeleton
            ? null
            : () => Navigator.pushNamed(
                  context,
                  AppRoute.itemDetailAndChatScreen,
                  arguments: {
                    'item': post,
                    'cubit':BlocProvider.of<LostAndFoundCubit>(context),
                    'id':null
                  },
                ),
      ),
    );
  }
}