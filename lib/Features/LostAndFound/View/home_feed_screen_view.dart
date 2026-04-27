import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sekka/Core/Constants/app_color.dart';
import 'package:sekka/Core/Constants/app_route.dart';
import 'package:sekka/Core/Constants/app_style.dart';
import 'package:sekka/Core/Widget/empty_state_widget.dart';
import 'package:sekka/Features/LostAndFound/Logic/lost_found.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/create_post_model_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/home_header_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/home_search_filter_widget.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/home_stats.dart';
import 'package:sekka/Features/LostAndFound/Ui/Widgets/post_card_widget.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen>
    with SingleTickerProviderStateMixin {

  String _activeFilter = 'All'; // All, Lost, Found
  String _activeCategory = 'All'; // All, Phone, Wallet, Bag, Keys, Other
  String _searchQuery = '';
  final bool _isLoading = false;
  bool _showFab = true;
  late ScrollController _scrollController;
  late AnimationController _fabAnimController;

  final List<Map<String, dynamic>> _postMaps = [
    {
      'id': '1',
      'posterName': 'Sara Ali',
      'posterAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_19c86455a-1763301095993.png',
      'posterAvatarSemanticLabel':
          'Professional headshot of Arab woman with dark hair wearing blue top',
      'postType': 'found',
      'timeAgo': '3h ago',
      'title': 'Found iPhone 13',
      'description':
          'Found an iPhone 13 Pro on the Blue Line train. It has a blue case. Contact me to claim it.',
      'station': 'Downtown Station',
      'messageCount': 8,
      'status': 'active',
      'category': 'Phone',
    },
    {
      'id': '2',
      'posterName': 'Ahmed Mohamed',
      'posterAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_18b8a61b5-1772542028452.png',
      'posterAvatarSemanticLabel':
          'Middle-aged Egyptian man with short black hair in casual shirt',
      'postType': 'lost',
      'timeAgo': '5h ago',
      'title': 'Lost Black Wallet',
      'description':
          'Lost my black leather wallet at Central Metro Station around 5 PM yesterday. It has my ID card and credit cards inside.',
      'station': 'Central Metro Station',
      'messageCount': 3,
      'status': 'active',
      'category': 'Wallet',
    },
    {
      'id': '3',
      'posterName': 'Fatima Hassan',
      'posterAvatar':
          'https://images.unsplash.com/photo-1718041127108-d477a9e6a155',
      'posterAvatarSemanticLabel':
          'Young woman with hijab smiling warmly at camera',
      'postType': 'found',
      'timeAgo': '1d ago',
      'title': 'Found Navy Blue Backpack',
      'description':
          'Found a navy blue Adidas backpack near the exit of North Gate Station. Has some textbooks inside.',
      'station': 'North Gate Station',
      'messageCount': 1,
      'status': 'active',
      'category': 'Bag',
    },
    {
      'id': '4',
      'posterName': 'Omar Khalil',
      'posterAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1ce1ecc21-1763296439790.png',
      'posterAvatarSemanticLabel':
          'Young Sudanese man in white shirt with confident expression',
      'postType': 'lost',
      'timeAgo': '2d ago',
      'title': 'Lost Car Keys with Red Tag',
      'description':
          'Lost my car keys with a distinctive red keychain tag. Last seen at Platform 3 of East Terminal.',
      'station': 'East Terminal',
      'messageCount': 0,
      'status': 'active',
      'category': 'Keys',
    },
    {
      'id': '5',
      'posterName': 'Layla Nasser',
      'posterAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1caf054c3-1763292717428.png',
      'posterAvatarSemanticLabel':
          'Libyan woman with shoulder-length hair in professional attire',
      'postType': 'found',
      'timeAgo': '2d ago',
      'title': 'Found Silver Bracelet',
      'description':
          'Found a silver charm bracelet near the ticket machines at Westside Junction. Engraved initials visible.',
      'station': 'Westside Junction',
      'messageCount': 5,
      'status': 'resolved',
      'category': 'Other',
    },
    {
      'id': '6',
      'posterName': 'Khalid Ibrahim',
      'posterAvatar':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1fa3031cd-1772460293995.png',
      'posterAvatarSemanticLabel':
          'Moroccan man in his 30s with beard wearing navy jacket',
      'postType': 'lost',
      'timeAgo': '3d ago',
      'title': 'Lost Brown Leather Wallet',
      'description':
          'Lost a brown leather bifold wallet on the Red Line. Contains important documents and a family photo.',
      'station': 'Red Line — Southbound',
      'messageCount': 2,
      'status': 'active',
      'category': 'Wallet',
    },
  ];

  List<Map<String, dynamic>> get _filteredPosts {
    return _postMaps.where((post) {
      final matchesFilter =
          _activeFilter == 'All' ||
          (_activeFilter == 'Lost' && post['postType'] == 'lost') ||
          (_activeFilter == 'Found' && post['postType'] == 'found');
      final matchesCategory =
          _activeCategory == 'All' || post['category'] == _activeCategory;
      final matchesSearch =
          _searchQuery.isEmpty ||
          post['title'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          post['description'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          ) ||
          post['station'].toString().toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesFilter && matchesCategory && matchesSearch;
    }).toList();
  }

  int get _lostCount => _postMaps
      .where((p) => p['postType'] == 'lost' && p['status'] == 'active')
      .length;
  int get _foundCount => _postMaps
      .where((p) => p['postType'] == 'found' && p['status'] == 'active')
      .length;

  @override
  void initState() {
    super.initState();
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

  void _openCreatePostModal(BuildContext
      context) {
    final cubit = context.read<LostAndFoundCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: CreatePostModalWidget(
          onPostCreated: (postData) {
            setState(() {
              _postMaps.insert(0, postData);
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final isTablet = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: HomeHeaderWidget(onAddPressed: () => _openCreatePostModal(context),),
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
                  lostCount: _lostCount,
                  foundCount: _foundCount,
                ),
              ),
              _filteredPosts.isEmpty
                  ? SliverFillRemaining(
                      child: EmptyStateWidget(
                        icon: Icons.search_off_rounded,
                        title: 'No items found',
                        description:
                            'Try adjusting your filters or search terms, or post a new item.',
                        ctaLabel: 'Post an Item',
                        onCta:() =>  _openCreatePostModal,
                      ),
                    )
                  : isTablet
                  ? SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.1,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildPostCard(index, isTablet),
                          childCount: _filteredPosts.length,
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.only(bottom: 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _buildPostCard(index, isTablet),
                          childCount: _filteredPosts.length,
                        ),
                      ),
                    ),
            ],
          ),
          // Floating FAB
          Positioned(
            bottom: 24,
            right: 16,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _fabAnimController,
                curve: Curves.easeOutBack,
              ),
              child: FloatingActionButton.extended(
                onPressed: () => _openCreatePostModal(context),
                backgroundColor: AppColor.secondary,
                foregroundColor: Colors.white,
                elevation: 4,
                icon: const Icon(Icons.add_rounded),
                label: Text(
                  'Post Item',
                  style: AppStyle.regular16RobotoBlack.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(int index, bool isTablet) {
    final post = _filteredPosts[index];
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
