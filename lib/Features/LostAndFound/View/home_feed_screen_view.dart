import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_style.dart';
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
        child: CreatePostModalWidget(),
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

      return Scaffold(
   
        body: RefreshIndicator(
          onRefresh: () async => context.read<LostAndFoundCubit>().getPosts(),
          child: Stack(
            children: [
              CustomScrollView(
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

                  
                  if (state.status == LostFoundStatus.getPostLoading)
                    Skeletonizer.sliver(
                      enabled: true,
                      child: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildPostCard(_dummyItem(), index),
                          childCount: 5,
                        ),
                      ),
                    )
                  
                  
                  else if (state.status == LostFoundStatus.getPostFailure)
                    SliverFillRemaining(
                      child: EmptyStateWidget(
                        icon: Icons.error_outline,
                        title: 'حدث خطأ ما',
                        description: 'فشل في تحميل البيانات، يرجى المحاولة مرة أخرى',
                        ctaLabel: 'إعادة المحاولة',
                        onCta: () => context.read<LostAndFoundCubit>().getPosts(),
                      ),
                    )

                     else if (filteredItems.isEmpty)
                    SliverFillRemaining(
                      child: EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'There is nothing here',
                        description: 'You have not posted anything yet.',
                        ctaLabel: 'Post now',
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
                            padding: const EdgeInsets.only(bottom: 100),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => _buildPostCard(filteredItems[index], index),
                                childCount: filteredItems.length,
                              ),
                            ),
                          ),
                ],
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
    id: 0,
    title: 'Loading Title Header',
    description: 'This is a long loading description for skeletonizer',
    type: ItemType.lost,
    createdAt: DateTime.now(),
    category: Category.phone,
    stationName: 'Loading Station',
    userId: '0',
  );
} 

  Widget _buildPostCard(ItemModel post, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + (index * 60).clamp(0, 300)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: PostCardWidget(
        postData: post,  
        onTap: () => Navigator.pushNamed(
          context,
          AppRoute.itemDetailAndChatScreen,
          arguments: post,
        ),
      ),
    );
  }
}
