import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../community/domain/entities/post.dart';
import '../providers/popular_posts_providers.dart';
import '../widgets/user_header.dart';
import '../widgets/menu_grid_item.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/lainnya_modal.dart';
import '../widgets/daily_tasks_section.dart';
import '../providers/daily_features_provider.dart';
import '../providers/feature_tracker_provider.dart';
import '../providers/wallet_provider.dart';
import '../../../../features/local_wisdom/presentation/widgets/wisdom_checklist_section.dart';
import '../../../pregnancy/presentation/providers/pregnancy_providers.dart';
import '../../../pregnancy/presentation/widgets/pregnancy_onboarding_sheet.dart';
import '../../../main/presentation/providers/main_tab_provider.dart';
import '../../../screening/data/models/screening_models.dart';
import '../../../screening/presentation/providers/screening_providers.dart';
import '../widgets/meal_plan_home_widget.dart';
import '../widgets/recommended_features_section.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with WidgetsBindingObserver {
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _dailyKey = GlobalKey();
  final GlobalKey _olahragaKey = GlobalKey();
  final GlobalKey _hidrasiKey = GlobalKey();
  final GlobalKey _tipsKey = GlobalKey();
  final GlobalKey _anemiaKey = GlobalKey();
  final GlobalKey _depresiKey = GlobalKey();
  final GlobalKey _udaraKey = GlobalKey();
  final GlobalKey _hplKey = GlobalKey();
  final GlobalKey _lainnyaKey = GlobalKey();

  Timer? _autoRefreshTimer;
  static const _refreshInterval = Duration(minutes: 1);

  String _getGreeting() {
    final now = DateTime.now().toUtc().add(const Duration(hours: 7));
    final hour = now.hour;
    if (hour < 12) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    homePendingActionNotifier.addListener(_consumePendingHomeAction);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
      if (!ref.read(screeningNotifierProvider).isLoaded) {
        ref.read(screeningNotifierProvider.notifier).loadLatest();
      }
      _consumePendingHomeAction();
    });
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    homePendingActionNotifier.removeListener(_consumePendingHomeAction);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _consumePendingHomeAction() {
    if (!mounted) return;
    final action = homePendingActionNotifier.value;
    if (action == 'local_wisdom') {
      homePendingActionNotifier.value = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showDailyTasksBottomSheet(initialTabIndex: 2);
        }
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground → refresh immediately + restart timer
      _refreshAllData();
      _startAutoRefresh();
    } else if (state == AppLifecycleState.paused) {
      // App went to background → stop timer to save battery
      _autoRefreshTimer?.cancel();
    }
  }

  void _startAutoRefresh() {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(_refreshInterval, (_) {
      _refreshAllData();
    });
  }

  void _refreshAllData() {
    if (!mounted) return;
    debugPrint('[HOME] Auto-refresh triggered');
    ref.invalidate(popularPostsProvider);
    ref.invalidate(dailyProgressProvider);
    ref.read(profileNotifierProvider.notifier).loadProfile();
    ref.read(screeningNotifierProvider.notifier).loadLatest();
    // Wallet uses Notifier, rebuild it
    ref.invalidate(walletProvider);
  }

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (innerContext) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final prefs = await SharedPreferences.getInstance();
          final hasSeenTutorial = prefs.getBool('has_seen_tutorial') ?? false;
          if (!hasSeenTutorial && context.mounted) {
            _startTutorial(innerContext);
            await prefs.setBool('has_seen_tutorial', true);
          }
        });

        final authState = ref.watch(authNotifierProvider);
        final user = authState.user;
        final profileState = ref.watch(profileNotifierProvider);
        final profilePhoto = profileState.profile?.photoUrl;
        final screeningState = ref.watch(screeningNotifierProvider);

        // Mandatory screening guard if user somehow enters /home without completing screening
        if (screeningState.isLoaded && !screeningState.hasCompletedScreening) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              context.go('/screening', extra: {'isInitial': true});
            }
          });
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: const Color(0xFFFA6978),
            elevation: 0,
            toolbarHeight: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
          ),
          body: Container(
            color: const Color(0xFFFA6978),
            child: SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                child: CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/gradien.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Showcase(
                                          key: _headerKey,
                                          description:
                                              'Ini profilmu. Ketuk untuk mengedit atau melihat detail.',
                                          child: GestureDetector(
                                            onTap: () =>
                                                context.push('/profile'),
                                            child: UserHeader(
                                              greeting: _getGreeting(),
                                              userName: user?.name ?? 'User',
                                              avatarUrl: profilePhoto,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          top: 8,
                                          right: 4,
                                        ),
                                        child: Row(
                                          children: [
                                            Showcase(
                                              key: _dailyKey,
                                              description:
                                                  'Pantau streak dan selesaikan misi harian di sini!',
                                              child: IconButton(
                                                icon: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .local_fire_department,
                                                      color: Colors.amber,
                                                      size: 28,
                                                    ),
                                                    ref
                                                        .watch(
                                                          dailyProgressProvider,
                                                        )
                                                        .when(
                                                          data: (p) =>
                                                              p.streak > 0
                                                              ? Positioned(
                                                                  right: 0,
                                                                  top: 0,
                                                                  child: Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          2,
                                                                        ),
                                                                    decoration: const BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                    constraints: const BoxConstraints(
                                                                      minWidth:
                                                                          14,
                                                                      minHeight:
                                                                          14,
                                                                    ),
                                                                    child: Text(
                                                                      '${p.streak}',
                                                                      style: const TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                )
                                                              : const SizedBox(),
                                                          loading: () =>
                                                              const SizedBox(),
                                                          error: (context, index) =>
                                                              const SizedBox(),
                                                        ),
                                                  ],
                                                ),
                                                onPressed:
                                                    _showDailyTasksBottomSheet,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.notifications_outlined,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                context.push('/notifications');
                                              },
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.help_outline,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                _startTutorial(innerContext);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _buildMenuGrid(screeningState.latest),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                            if (screeningState.latest != null &&
                                screeningState.latest!.hasCompletedScreening)
                              RecommendedFeaturesSection(
                                screening: screeningState.latest!,
                                onFeatureTap: _openRecommendedFeature,
                              ),
                            _buildPromoSection(),
                            _buildPopularPostsSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
              ),
            ),
          ),
        );
      },
    );
  }



  void _showDailyTasksBottomSheet({int initialTabIndex = 0}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DefaultTabController(
        length: 3,
        initialIndex: initialTabIndex,
        child: DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),
                // Tab bar
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    labelColor: const Color(0xFF424242),
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 13,
                    ),
                    tabs: const [
                      Tab(text: 'Misi Harian'),
                      Tab(text: 'Meal Plan'),
                      Tab(text: 'Kearifan Lokal'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Tab content
                Expanded(
                  child: TabBarView(
                    children: [
                      // Tab 1: Daily Tasks (existing)
                      SingleChildScrollView(
                        controller: controller,
                        child: const DailyTasksSection(),
                      ),
                      // Tab 2: Meal Plan
                      SingleChildScrollView(
                        controller: controller,
                        child: const MealPlanHomeWidget(),
                      ),
                      // Tab 3: Local Wisdom
                      SingleChildScrollView(
                        controller: controller,
                        child: const WisdomChecklistSection(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startTutorial(BuildContext context) {
    final keys = [
      _headerKey,
      _dailyKey,
      _olahragaKey,
      _anemiaKey,
      _depresiKey,
      _udaraKey,
      _hidrasiKey,
      _tipsKey,
      _hplKey,
      _lainnyaKey,
    ].where((k) => k.currentContext != null).toList();
    if (keys.isNotEmpty) {
      ShowCaseWidget.of(context).startShowCase(keys);
    }
  }

  void _handleMenuTap(
    String route, {
    bool requiresPregnancy = false,
    AppFeature? feature,
  }) async {
    if (requiresPregnancy) {
      final pregnancyState = ref.read(pregnancyNotifierProvider);
      if (pregnancyState.isLoading) return;

      if (pregnancyState.pregnancy == null) {
        final result = await showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const PregnancyOnboardingSheet(),
        );
        if (result == true && mounted) {
          if (feature != null) {
            ref.read(featureTrackerProvider).track(feature);
          }
          context.push(route);
        }
        return;
      }
    }
    if (feature != null) {
      ref.read(featureTrackerProvider).track(feature);
    }
    context.push(route);
  }

  void _openRecommendedFeature(RecommendedFeatureModel feature) {
    final tracked = appFeatureFromSlug(feature.featureSlug);
    if (tracked != null) {
      ref.read(featureTrackerProvider).track(tracked);
    }

    if (feature.route == 'tab:community') {
      mainTabIndexNotifier.value = 1;
      return;
    }
    if (feature.route == 'action:local_wisdom') {
      _showDailyTasksBottomSheet(initialTabIndex: 2);
      return;
    }
    if (feature.route.startsWith('/')) {
      _handleMenuTap(feature.route);
    }
  }

  Map<String, _HomeMenuEntry> _buildMenuCatalog() {
    return {
      'olahraga': _HomeMenuEntry(
        slug: 'olahraga',
        label: 'Rekomendasi Olahraga',
        imagePath: 'assets/images/kunjungan.png',
        description: 'Dapatkan rekomendasi olahraga ringan yang aman.',
        showcaseKey: _olahragaKey,
        onTap: () => _handleMenuTap(
          '/rekomendasi-olahraga',
          requiresPregnancy: false,
          feature: AppFeature.olahraga,
        ),
      ),
      'anemia': _HomeMenuEntry(
        slug: 'anemia',
        label: 'Prediksi Anemia',
        imagePath: 'assets/images/anemia.png',
        description: 'Ketahui risiko Anemia dengan mengisi form observasi.',
        showcaseKey: _anemiaKey,
        onTap: () =>
            _handleMenuTap('/deteksi-anemia', feature: AppFeature.anemia),
      ),
      'depresi': _HomeMenuEntry(
        slug: 'depresi',
        label: 'Prediksi Depresi',
        imagePath: 'assets/images/deteksi depresi.png',
        description:
            'Deteksi risiko depresi pasca melahirkan melalui analisis foto wajah menggunakan AI.',
        showcaseKey: _depresiKey,
        onTap: () =>
            _handleMenuTap('/deteksi-depresi', feature: AppFeature.depresi),
      ),
      'stunting': _HomeMenuEntry(
        slug: 'stunting',
        label: 'Risiko Stunting',
        imagePath: 'assets/images/stunting icon.png',
        description: 'Dapatkan analisis risiko stunting anak menggunakan AI.',
        showcaseKey: _udaraKey,
        onTap: () =>
            _handleMenuTap('/stunting/history', feature: AppFeature.stunting),
      ),
      'hidrasi': _HomeMenuEntry(
        slug: 'hidrasi',
        label: 'Rekomendasi Hidrasi',
        imagePath: 'assets/images/glass water.png',
        description: 'Pantau asupan air harian Anda agar tetap terhidrasi.',
        showcaseKey: _hidrasiKey,
        onTap: () {
          ref.read(featureTrackerProvider).track(AppFeature.hidrasi);
          context.push('/hydration');
        },
      ),
      'kalkulator_hpl': _HomeMenuEntry(
        slug: 'kalkulator_hpl',
        label: 'Kalkulator HPL',
        imagePath: 'assets/images/kalkulator hpl.png',
        description:
            'Hitung dan pantau Hari Perkiraan Lahir (HPL) serta perkembangan janin.',
        showcaseKey: _hplKey,
        onTap: () {
          ref.read(featureTrackerProvider).track(AppFeature.kalkulatorHpl);
          context.push('/pregnancy-calculator');
        },
      ),
      'tips': _HomeMenuEntry(
        slug: 'tips',
        label: 'Tips & Gizi',
        imagePath: 'assets/images/tips.png',
        description: 'Tips harian untuk kesehatan ibu dan janin.',
        showcaseKey: _tipsKey,
        onTap: () {
          ref.read(featureTrackerProvider).track(AppFeature.tips);
          context.push('/tips');
        },
      ),
      'appointment': _HomeMenuEntry(
        slug: 'appointment',
        label: 'Janji Temu',
        imagePath: 'assets/images/calendar.png',
        description: 'Atur jadwal konsultasi kehamilan dengan bidan.',
        onTap: () {
          ref.read(featureTrackerProvider).track(AppFeature.appointment);
          context.push('/appointments');
        },
      ),
      'kunjungan': _HomeMenuEntry(
        slug: 'kunjungan',
        label: 'Catatan Kunjungan',
        icon: Icons.assignment_rounded,
        description: 'Catat riwayat pemeriksaan kehamilan Bunda.',
        onTap: () {
          ref.read(featureTrackerProvider).track(AppFeature.kunjungan);
          context.push('/kunjungan');
        },
      ),
      'bidan_map': _HomeMenuEntry(
        slug: 'bidan_map',
        label: 'Peta Bidan',
        icon: Icons.location_on_rounded,
        description: 'Temukan lokasi bidan terdekat dari tempat tinggal Bunda.',
        onTap: () {
          ref.read(featureTrackerProvider).track(AppFeature.bidanMap);
          context.push('/bidan-map');
        },
      ),
      'local_wisdom': _HomeMenuEntry(
        slug: 'local_wisdom',
        label: 'Kearifan Lokal',
        icon: Icons.lightbulb_outline_rounded,
        description: 'Pahami mitos vs fakta kehamilan secara medis.',
        onTap: () {
          ref.read(featureTrackerProvider).track(AppFeature.localWisdom);
          _showDailyTasksBottomSheet(initialTabIndex: 2);
        },
      ),
      'komunitas': _HomeMenuEntry(
        slug: 'komunitas',
        label: 'Komunitas Bunda',
        icon: Icons.groups_rounded,
        description: 'Berbagi pengalaman dan bertanya bersama sesama Bunda.',
        onTap: () {
          ref.read(featureTrackerProvider).track(AppFeature.komunitas);
          mainTabIndexNotifier.value = 1;
        },
      ),
    };
  }

  Widget _buildMenuGrid(ScreeningResultModel? screening) {
    final catalog = _buildMenuCatalog();
    const defaultOrder = [
      'olahraga',
      'anemia',
      'depresi',
      'stunting',
      'hidrasi',
      'kalkulator_hpl',
      'tips',
      'appointment',
      'kunjungan',
      'bidan_map',
      'local_wisdom',
      'komunitas',
    ];

    final recommendedSlugs = <String>[];
    if (screening != null && screening.hasCompletedScreening) {
      for (final f in screening.recommendedFeatures) {
        if (catalog.containsKey(f.featureSlug) &&
            !recommendedSlugs.contains(f.featureSlug)) {
          recommendedSlugs.add(f.featureSlug);
        }
        if (recommendedSlugs.length == 4) break;
      }
    }

    final orderedSlugs = [
      ...recommendedSlugs,
      ...defaultOrder.where((slug) => !recommendedSlugs.contains(slug)),
    ];

    final primarySlugs = orderedSlugs.take(7).toList();
    final overflowSlugs = orderedSlugs.skip(7).toList();

    final List<Widget> items = primarySlugs.map((slug) {
      final entry = catalog[slug]!;
      final isRec = recommendedSlugs.contains(slug);
      final tile = MenuGridItem(
        imagePath: entry.imagePath,
        icon: entry.icon,
        label: entry.label,
        isRecommended: isRec,
        badgeText: 'Utama',
        onTap: entry.onTap,
      );
      if (entry.showcaseKey != null) {
        return Showcase(
          key: entry.showcaseKey!,
          description: entry.description,
          child: tile,
        );
      }
      return tile;
    }).toList();

    items.add(
      Showcase(
        key: _lainnyaKey,
        description:
            'Buka ini untuk melihat semua fitur tambahan yang tersedia!',
        child: MenuGridItem(
          imagePath: 'assets/images/lainnya.png',
          label: 'Lainnya',
          onTap: () {
            final overflowWidgets = overflowSlugs.map((slug) {
              final entry = catalog[slug]!;
              return MenuGridItem(
                imagePath: entry.imagePath,
                icon: entry.icon,
                label: entry.label,
                onTap: () {
                  context.pop();
                  entry.onTap();
                },
              );
            }).toList();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => LainnyaModal(items: overflowWidgets),
            );
          },
        ),
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
        child: GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 6,
          childAspectRatio: 0.85,
          padding: EdgeInsets.zero,
          children: items,
        ),
      ),
    );
  }

  Widget _buildPromoSection() {
    return const BannerCarousel();
  }

  Widget _buildPopularPostsSection() {
    final postsAsync = ref.watch(popularPostsProvider);

    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
            ),
            child: Text(
              'Postingan Populer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF424242),
              ),
            ),
          ),
          const SizedBox(height: 10),
          postsAsync.when(
            loading: () => const SizedBox(
              height: 130,
              child: Center(
                child: CircularProgressIndicator(color: Color(0xFFFA6978)),
              ),
            ),
            error: (context, index) => const SizedBox(
              height: 130,
              child: Center(
                child: Text(
                  'Gagal memuat postingan',
                  style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                ),
              ),
            ),
            data: (posts) {
              if (posts.isEmpty) {
                return const SizedBox(
                  height: 130,
                  child: Center(
                    child: Text(
                      'Belum ada postingan',
                      style: TextStyle(color: Color(0xFF999999), fontSize: 13),
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return _buildPopularPostCard(post);
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _buildPopularPostCard(Post post) {
    String timeAgo = '';
    if (post.createdAt != null) {
      try {
        final date = DateTime.parse(post.createdAt!);
        timeAgo = DateFormat('dd MMM').format(date);
      } catch (_) {
        timeAgo = '';
      }
    }

    return GestureDetector(
      onTap: () => context.push('/community/detail/${post.id}'),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFFFCE4EC),
                  backgroundImage: post.user.profileImage != null
                      ? NetworkImage(post.user.profileImage!)
                      : null,
                  child: post.user.profileImage == null
                      ? const Icon(
                          Icons.person,
                          size: 14,
                          color: Color(0xFFFA6978),
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.user.name,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF333333),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        timeAgo,
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                post.deskripsi,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF555555),
                  height: 1.4,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 14,
                  color: const Color(0xFFFA6978),
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.apresiasi}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.chat_bubble_outline,
                  size: 14,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  '${post.komentar}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeMenuEntry {
  final String slug;
  final String label;
  final String? imagePath;
  final IconData? icon;
  final String description;
  final GlobalKey? showcaseKey;
  final VoidCallback onTap;

  const _HomeMenuEntry({
    required this.slug,
    required this.label,
    this.imagePath,
    this.icon,
    required this.description,
    this.showcaseKey,
    required this.onTap,
  });
}
