import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../pregnancy/presentation/providers/pregnancy_providers.dart';
import '../providers/sport_recommendation_providers.dart';
import '../widgets/assessment_form_view.dart';
import '../../../rekomendasi_olahraga/presentation/widgets/lmp_bottom_sheet.dart';
import '../../domain/entities/sport_recommendation.dart';

class RekomendasiGerakanPage extends ConsumerStatefulWidget {
  const RekomendasiGerakanPage({super.key});

  @override
  ConsumerState<RekomendasiGerakanPage> createState() =>
      _RekomendasiGerakanPageState();
}

class _RekomendasiGerakanPageState
    extends ConsumerState<RekomendasiGerakanPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _sheetOpened = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(sportRecommendationNotifierProvider.notifier).fetchRecommendations();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showAssessmentSheet({bool showUpdateBanner = false, String? errorMessage}) {
    if (_sheetOpened) return;
    _sheetOpened = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: AssessmentFormView(
              onSubmit: (payload) {
                Navigator.of(context).pop();
                ref
                    .read(sportRecommendationNotifierProvider.notifier)
                    .submitAssessment(payload);
              },
              isSubmitting: false,
              showUpdateBanner: showUpdateBanner,
              errorMessage: errorMessage,
              scrollController: scrollController,
            ),
          );
        },
      ),
    ).whenComplete(() {
      _sheetOpened = false;
    });
  }

  void _showLmpSheet() {
    if (_sheetOpened) return;
    _sheetOpened = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (sheetContext) => LmpBottomSheet(
        onSuccess: (hpht, gestationalAge, isMultiple) async {
          // Step 1: Save to pregnancy_calculators
          final success = await ref.read(pregnancyNotifierProvider.notifier).savePregnancy(
            hpht: hpht,
            babyGender: null,
          );

          if (success && sheetContext.mounted) {
            Navigator.of(sheetContext).pop();
          }

          if (success && mounted) {
            // Step 2: Create record in pregnancies table for sport recommendations
            await ref.read(pregnancyNotifierProvider.notifier).createPregnancyRecord(
              lmpDate: hpht,
              gestationalAgeWeeks: gestationalAge,
              multipleGestation: isMultiple,
            );

            // Step 3: Refresh pregnancy data
            await ref.read(pregnancyNotifierProvider.notifier).loadMyPregnancy();

            // Step 4: Small delay then submit default assessment
            await Future.delayed(const Duration(milliseconds: 500));
            if (mounted) {
              _submitDefaultAssessment();
            }
          }
        },
      ),
    ).whenComplete(() {
      _sheetOpened = false;
    });
  }

  void _submitDefaultAssessment() {
    // Submit with default values to get recommendations
    // BMI 22.0 is considered normal/healthy range
    final payload = SportAssessmentPayload(
      bmi: 22.0,
      hypertension: false,
      isDiabetes: false,
      gestationalDiabetes: false,
      isFever: false,
      isHighHeartRate: false,
      previousComplications: false,
      mentalHealthIssue: false,
      lowImpactPref: true,
      waterAccess: false, // water_access_rupture - false means no water rupture issue
      backPain: false,
      placentaPositionRestriction: false,
    );
    ref.read(sportRecommendationNotifierProvider.notifier).submitAssessment(payload);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sportRecommendationNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F6),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFFFA6978),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFA6978), Color(0xFFE85A75)],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Rekomendasi Olahraga',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'Untukmu'),
                  Tab(text: 'Semua Olahraga'),
                ],
              ),
            ),
          ];
        },
        body: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(SportRecommendationState state) {
    if (state.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFFFA6978)),
            SizedBox(height: 16),
            Text(
              'Memuat rekomendasi...',
              style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
            ),
          ],
        ),
      );
    }

    // Check if LMP is needed first
    if (state.needsLmp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_sheetOpened) {
          _showLmpSheet();
        }
      });
      return _buildPlaceholderBody();
    }

    // Check if Profile is needed
    if (state.needsProfile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Silakan lengkapi profil Anda terlebih dahulu')),
        );
      });
      return _buildPlaceholderBody();
    }

    if (state.error != null && state.recommendations.isEmpty && !state.needsLmp && !state.needsProfile) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_sheetOpened) {
          _showAssessmentSheet(errorMessage: state.error);
        }
      });
      return _buildPlaceholderBody();
    }

    if (state.needUpdateData || state.recommendations.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_sheetOpened) {
          _showAssessmentSheet(showUpdateBanner: state.needUpdateData);
        }
      });
      return _buildPlaceholderBody();
    }

    return TabBarView(
      controller: _tabController,
      children: [
        _buildRecommendationsList(state.recommendations),
        _buildAllSportsList(state.recommendations),
      ],
    );
  }

  Widget _buildRecommendationsList(List recommendations) {
    if (recommendations.isEmpty) {
      return const Center(
        child: Text('Belum ada rekomendasi'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: recommendations.length,
      itemBuilder: (context, index) {
        final item = recommendations[index];
        return _buildSportCard(item, index + 1);
      },
    );
  }

  Widget _buildAllSportsList(List recommendations) {
    if (recommendations.isEmpty) {
      return const Center(
        child: Text('Belum ada data olahraga'),
      );
    }

    // Sort by score descending for "all sports" view
    final sortedRecs = List.from(recommendations)..sort((a, b) => b.score.compareTo(a.score));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sortedRecs.length,
      itemBuilder: (context, index) {
        final item = sortedRecs[index];
        return _buildSportCard(item, index + 1);
      },
    );
  }

  Widget _buildSportCard(dynamic item, int rank) {
    final score = (item.score * 100).round();
    final activity = item.activity ?? 'Tanpa nama';
    final picture = item.picture1;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          if (picture != null && picture.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                picture,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.fitness_center, size: 40, color: Color(0xFFBDBDBD)),
                    ),
                  );
                },
              ),
            ),
          // Content section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF424242),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Olahraga aman untuk ibu hamil',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFA6978),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderBody() {
    return const Center(
      child: Text(
        'Belum ada rekomendasi',
        style: TextStyle(fontSize: 14, color: Color(0xFF757575)),
      ),
    );
  }
}
