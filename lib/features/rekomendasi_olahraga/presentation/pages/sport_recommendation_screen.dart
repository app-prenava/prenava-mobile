import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../pregnancy/presentation/providers/pregnancy_providers.dart';
import '../bloc/sport_recommendation_bloc.dart';
import '../bloc/sport_recommendation_event.dart';
import '../bloc/sport_recommendation_state.dart';
import '../widgets/lmp_bottom_sheet.dart';
import '../widgets/assessment_bottom_sheet.dart';

class SportRecommendationScreen extends ConsumerStatefulWidget {
  const SportRecommendationScreen({super.key});

  @override
  ConsumerState<SportRecommendationScreen> createState() => _SportRecommendationScreenState();
}

class _SportRecommendationScreenState extends ConsumerState<SportRecommendationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<SportRecommendationBloc>().add(GetSportRecommendationEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showLmpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => LmpBottomSheet(
        onSuccess: (hpht, gestationalAge, isMultiple) async {
          // Close the sheet first
          if (sheetContext.mounted) {
            Navigator.of(sheetContext).pop();
          }

          // Step 1: Save to pregnancy_calculators
          final success = await ref.read(pregnancyNotifierProvider.notifier).savePregnancy(
            hpht: hpht,
            babyGender: null,
          );

          if (success && mounted) {
            // Step 2: Create record in pregnancies table for sport recommendations
            await ref.read(pregnancyNotifierProvider.notifier).createPregnancyRecord(
              lmpDate: hpht,
              gestationalAgeWeeks: gestationalAge,
              multipleGestation: isMultiple,
            );

            // Step 3: Small delay then refetch recommendations
            await Future.delayed(const Duration(milliseconds: 500));
            this.context.read<SportRecommendationBloc>().add(GetSportRecommendationEvent());
          }
        },
      ),
    );
  }

  void _showAssessmentBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AssessmentBottomSheet(
        onSuccess: () {
          Navigator.pop(context);
          context.read<SportRecommendationBloc>().add(GetSportRecommendationEvent());
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi Olahraga'),
        backgroundColor: const Color(0xFFC75166), 
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: BlocConsumer<SportRecommendationBloc, SportRecommendationState>(
        listener: (context, state) {
          if (state is SportRecommendationNeedsProfile) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            // TODO: Route to Add Profile
          } else if (state is SportRecommendationNeedsLmp) {
            _showLmpBottomSheet();
          } else if (state is SportRecommendationNeedsAssessment) {
            _showAssessmentBottomSheet();
          } else if (state is SportRecommendationLoaded && state.showUpdateAssessmentPrompt) {
            _showAssessmentBottomSheet();
          } else if (state is SportRecommendationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is SportRecommendationLoading || state is SportRecommendationInitial) {
            return const Center(child: CircularProgressIndicator());
          } 
          
          if (state is SportRecommendationLoaded) {
            return Column(
              children: [
                TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFFC75166),
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: const Color(0xFFC75166),
                  tabs: const [
                    Tab(text: "Rekomendasi"),
                    Tab(text: "Semua Olahraga"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tab 1: Rekomendasi
                      ListView.builder(
                        itemCount: state.response.modelResponse?.recommendations.length ?? 0,
                        itemBuilder: (context, index) {
                          final item = state.response.modelResponse!.recommendations[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.network(item.picture1, width: 50, height: 50, fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.fitness_center)),
                              title: Text(item.activity),
                              subtitle: const Text('Tap untuk detail'),
                              onTap: () {
                                // TODO: Navigate to detail
                              },
                            ),
                          );
                        },
                      ),
                      // Tab 2: All Sports
                      ListView.builder(
                        itemCount: state.response.modelResponse?.allRanked.length ?? 0,
                        itemBuilder: (context, index) {
                          final item = state.response.modelResponse!.allRanked[index];
                          return Card(
                            margin: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Image.network(item.picture1, width: 50, height: 50, fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.fitness_center)),
                              title: Text(item.activity),
                              subtitle: Text('Score: ${item.score.toStringAsFixed(2)}'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            );
          }
          return const Center(child: Text('Gagal memuat data / Data belum lengkap.'));
        },
      ),
    );
  }
}
