import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sport_recommendation_providers.dart';
import '../widgets/assessment_form_view.dart';
import '../widgets/recommendation_result_view.dart';

class RekomendasiGerakanPage extends ConsumerStatefulWidget {
  const RekomendasiGerakanPage({super.key});

  @override
  ConsumerState<RekomendasiGerakanPage> createState() =>
      _RekomendasiGerakanPageState();
}

class _RekomendasiGerakanPageState
    extends ConsumerState<RekomendasiGerakanPage> {
  bool _sheetOpened = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(sportRecommendationNotifierProvider.notifier).fetchRecommendations();
    });
  }

  void _showAssessmentSheet({bool showUpdateBanner = false, String? errorMessage}) {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sportRecommendationNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFA6978),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Rekomendasi Olahraga',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: _buildBody(state),
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

    if (state.error != null && state.recommendations.isEmpty) {
      if (!_sheetOpened) {
        _sheetOpened = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showAssessmentSheet(errorMessage: state.error);
        });
      }
      return _buildPlaceholderBody();
    }

    if (state.needUpdateData || state.recommendations.isEmpty) {
      if (!_sheetOpened) {
        _sheetOpened = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showAssessmentSheet(showUpdateBanner: state.needUpdateData);
        });
      }
      return _buildPlaceholderBody();
    }

    return RecommendationResultView(
      recommendations: state.recommendations,
      onRetakeAssessment: () {
        ref.read(sportRecommendationNotifierProvider.notifier).clearMessages();
        _sheetOpened = true;
        _showAssessmentSheet();
      },
    );
  }

  Widget _buildPlaceholderBody() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 120,
          margin: const EdgeInsets.fromLTRB(20, 16, 20, 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.image_outlined, size: 40, color: Color(0xFFBDBDBD)),
          ),
        ),
        Container(
          width: double.infinity,
          height: 50,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(Icons.image_outlined, size: 24, color: Color(0xFFBDBDBD)),
          ),
        ),
      ],
    );
  }
}
