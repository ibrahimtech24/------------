
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/institution_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/quick_categories.dart';
import '../widgets/sub_tabs_bar.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/home_states.dart';
import '../widgets/results_header.dart';
import '../data/constants.dart';
import 'detail_screen.dart';
import 'edit_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final prov = context.watch<AppProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filtered = prov.filteredInstitutions;
    final screenW = MediaQuery.of(context).size.width;
    final bgColor = isDark ? const Color(0xFF0D1117) : const Color(0xFFF8FAFF);
    final cardColor = isDark ? const Color(0xFF161B22) : Colors.white;
    final hasSubTabs = _getSubTabs(prov.currentTab) != null;

    return Directionality(
      textDirection: Directionality.of(context),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => prov.fetchFromApi(),
              color: AppTheme.primary,
              backgroundColor: cardColor,
              strokeWidth: 2.5,
              child: CustomScrollView(
                controller: _scrollController,
                cacheExtent: 500,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverToBoxAdapter(
                    child: GreetingHeader(
                      prov: prov,
                      isDark: isDark,
                      onToggleTheme: () => prov.toggleTheme(),
                      onShowFavorites: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                      ),
                      favoritesCount: prov.favoritesCount,
                    ),
                  ),
                  SliverToBoxAdapter(child: QuickCategories(prov: prov, isDark: isDark)),
                  if (hasSubTabs)
                    SliverToBoxAdapter(child: SubTabsBar(prov: prov, isDark: isDark)),
                  if (!prov.isLoading && filtered.isNotEmpty)
                    SliverToBoxAdapter(child: ResultsHeader(count: filtered.length, isDark: isDark)),
                  if (prov.isLoading)
                    SliverToBoxAdapter(child: LoadingShimmer(isDark: isDark))
                  else if (prov.hasError && filtered.isEmpty)
                    SliverToBoxAdapter(child: HomeErrorState(prov: prov, isDark: isDark))
                  else if (filtered.isEmpty)
                    SliverToBoxAdapter(child: HomeEmptyState(prov: prov, isDark: isDark, searchController: _searchController))
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenW > 600 ? 3 : 2,
                          mainAxisSpacing: 6,
                          crossAxisSpacing: 6,
                          childAspectRatio: 1.2,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, i) {
                            final inst = filtered[i];
                            return RepaintBoundary(
                              child: InstitutionCard(
                                institution: inst,
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(institution: inst))),
                                onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EditScreen(institution: inst))),
                              ),
                            );
                          },
                          childCount: filtered.length,
                          addRepaintBoundaries: true,
                          addAutomaticKeepAlives: false,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>>? _getSubTabs(String tabId) {
    final tab = AppConstants.tabDefs.where((t) => t['id'] == tabId).firstOrNull;
    if (tab == null || tab['subs'] == null) return null;
    return (tab['subs'] as List).cast<Map<String, dynamic>>();
  }
}

