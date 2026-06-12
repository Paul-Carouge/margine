import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;

import '../../../core/theme/forge_colors.dart';
import '../../../features/update/providers/update_providers.dart';
import '../../../features/update/ui/update_bottom_sheet.dart';
import '../../../data/database/app_database.dart';
import '../../providers/app_providers.dart';
import 'widgets/stats_grid.dart';
import 'widgets/filter_pills.dart';
import 'widgets/sort_button.dart';
import 'widgets/action_icon.dart';
import 'widgets/empty_state.dart';
import 'widgets/product_detail_sheet.dart';
import 'widgets/swipeable_card.dart';

/// Home screen — "L'Atelier" — Forge v3.0.
///
/// A single scrollable gallery. No bottom nav, no tabs.
///   • Stats cockpit: individual cards with icons
///   • Filter pills (20px radius)
///   • Vertical scroll of 220px photo-hero product cards (16px gap)
///   • Full-width FAB in Crimson
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(dashboardStatsProvider);
    final filter = ref.watch(filterStatusProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final showSearch = ref.watch(showSearchProvider);
    final sortOption = ref.watch(sortOptionProvider);
    final productsAsync = filter == 'all'
        ? ref.watch(productsStreamProvider)
        : ref.watch(productsByStatusProvider(filter));

    // Vérifier les mises à jour automatiquement — une seule fois par session
    ref.watch(updateCheckProvider);
    ref.listen(updateCheckProvider, (_, next) {
      next.whenOrNull(data: (release) {
        if (release != null) {
          final alreadyShown = ref.read(updateShownForVersionProvider);
          if (release.version != alreadyShown) {
            ref.read(updateShownForVersionProvider.notifier).state = release.version;
            showUpdateSheet(context, release);
          }
        }
      });
    });

    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── Header row ──────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "L'Établi",
                              style: textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            // Search toggle
                            ActionIcon(
                              icon: showSearch
                                  ? Icons.close_rounded
                                  : Icons.search_rounded,
                              onTap: () {
                                if (showSearch) {
                                  _searchCtrl.clear();
                                  ref
                                      .read(searchQueryProvider.notifier)
                                      .state = '';
                                }
                                ref
                                    .read(showSearchProvider.notifier)
                                    .state = !showSearch;
                              },
                            ),
                            const SizedBox(width: 4),
                            // Sort popup
                            SortButton(
                              current: sortOption,
                              onSelected: (s) => ref
                                  .read(sortOptionProvider.notifier)
                                  .state = s,
                            ),
                            const SizedBox(width: 4),
                            ActionIcon(
                              icon: Icons.bar_chart_rounded,
                              onTap: () => context.push('/analytics'),
                            ),
                            const SizedBox(width: 4),
                            ActionIcon(
                              icon: Icons.settings_rounded,
                              onTap: () => context.push('/settings'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Subtle separator line — the edge of the workbench
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: ForgeColors.outlineSubtle,
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Search bar (conditional) ───────────────────────────
                if (showSearch)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: TextField(
                        autofocus: true,
                        controller: _searchCtrl,
                        onChanged: (v) =>
                            ref.read(searchQueryProvider.notifier).state =
                                v.toLowerCase(),
                        decoration: InputDecoration(
                          hintText: 'Rechercher un article…',
                          prefixIcon: const Icon(Icons.search_rounded,
                              size: 20),
                          suffixIcon: searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 18),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    ref
                                        .read(searchQueryProvider.notifier)
                                        .state = '';
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),

                // ── Stats cockpit ───────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: statsAsync.when(
                      data: (s) => StatsGrid(stats: s),
                      loading: () => const SizedBox(height: 100),
                      error: (e, _) => SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            'Impossible de charger les stats',
                            style: textTheme.bodyMedium
                                ?.copyWith(color: cs.error),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Filter pills ────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: FilterPills(
                      current: filter,
                      onChanged: (f) =>
                          ref.read(filterStatusProvider.notifier).state = f,
                    ),
                  ),
                ),

                // ── Product gallery ─────────────────────────────────────
                productsAsync.when(
                  data: (products) {
                    // Apply search filter + sort
                    var filtered = products.where((p) {
                      if (searchQuery.isEmpty) return true;
                      return p.name.toLowerCase().contains(searchQuery);
                    }).toList();

                    switch (sortOption) {
                      case SortOption.dateDesc:
                        break;
                      case SortOption.profitDesc:
                        filtered.sort((a, b) {
                          final pa = profitFor(a);
                          final pb = profitFor(b);
                          return pb.compareTo(pa);
                        });
                        break;
                      case SortOption.priceDesc:
                        filtered.sort(
                            (a, b) => b.purchasePrice.compareTo(a.purchasePrice));
                        break;
                      case SortOption.nameAsc:
                        filtered.sort((a, b) => a.name.compareTo(b.name));
                        break;
                    }

                    if (filtered.isEmpty) {
                      return SliverFillRemaining(
                        hasScrollBody: false,
                        child: EmptyState(filter: filter),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = filtered[index];
                          return Padding(
                            padding: EdgeInsets.fromLTRB(
                              20,
                              index == 0 ? 0 : 0,
                              20,
                              index == filtered.length - 1 ? 100 : 16,
                            ),
                            child: SwipeableCard(
                              product: product,
                              onTap: () =>
                                  _showDetail(context, product),
                              onMarkSold: () =>
                                  _quickMarkSold(product.id),
                            ),
                          );
                        },
                        childCount: filtered.length,
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'Erreur : $e',
                        style: textTheme.bodyMedium
                            ?.copyWith(color: cs.error),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ── Full-width FAB — Primary ─────────────────────────────────
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                context.push('/article/ajouter');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: ForgeColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 22),
              label: const Text(
                'Nouvel achat',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context, Product product) {
    HapticFeedback.lightImpact();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ProductDetailSheet(product: product),
    );
  }

  void _quickMarkSold(int id) {
    final dao = ref.read(productDaoProvider);
    dao.updateProduct(ProductsCompanion(
      id: Value(id),
      status: const Value('sold'),
      saleDate: Value(DateTime.now()),
    ));
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Marqué comme vendu ✓'),
        backgroundColor: ForgeColors.teal,
      ),
    );
  }
}
