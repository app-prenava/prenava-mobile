import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prenava_mobile/features/stunting/data/models/stunting_models.dart';
import 'package:prenava_mobile/features/stunting/data/repositories/stunting_repository_impl.dart';
import 'package:prenava_mobile/features/stunting/domain/repositories/stunting_repository.dart';

// --- Form Notifier ---

class StuntingFormState {
  final int currentStep;
  final List<StuntingQuestion> questions;
  final Map<String, dynamic> answers;
  final bool isLoading;
  final String? error;

  StuntingFormState({
    this.currentStep = 0,
    this.questions = const [],
    this.answers = const {},
    this.isLoading = false,
    this.error,
  });

  StuntingFormState copyWith({
    int? currentStep,
    List<StuntingQuestion>? questions,
    Map<String, dynamic>? answers,
    bool? isLoading,
    String? error,
  }) {
    return StuntingFormState(
      currentStep: currentStep ?? this.currentStep,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class StuntingFormNotifier extends Notifier<StuntingFormState> {
  @override
  StuntingFormState build() {
    return StuntingFormState();
  }

  StuntingRepository get _repository => ref.read(stuntingRepositoryProvider);

  Future<void> fetchQuestions() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final questions = await _repository.getQuestions();
      state = state.copyWith(questions: questions, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void nextStep() {
    if (state.currentStep < state.questions.length - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void reset() {
    state = StuntingFormState();
  }

  void removeAnswer(String key) {
    final newAnswers = Map<String, dynamic>.from(state.answers);
    newAnswers.remove(key);
    state = state.copyWith(answers: newAnswers);
  }

  void updateAnswer(String key, dynamic value) {
    final newAnswers = Map<String, dynamic>.from(state.answers);
    newAnswers[key] = value;
    state = state.copyWith(answers: newAnswers);
  }

  bool isCurrentStepValid() {
    if (state.questions.isEmpty) return false;
    final currentQuestion = state.questions[state.currentStep];
    return state.answers.containsKey(currentQuestion.key);
  }

  double get progress => state.questions.isEmpty
      ? 0
      : (state.currentStep + 1) / state.questions.length;
}

final stuntingFormProvider =
    NotifierProvider<StuntingFormNotifier, StuntingFormState>(() {
  return StuntingFormNotifier();
});

// --- Prediction Notifier ---

enum PredictionStatus { initial, loading, success, failure }

class PredictionState {
  final PredictionStatus status;
  final PredictionResult? result;
  final String? error;

  PredictionState({
    this.status = PredictionStatus.initial,
    this.result,
    this.error,
  });
}

class StuntingPredictionNotifier extends Notifier<PredictionState> {
  @override
  PredictionState build() {
    return PredictionState();
  }

  StuntingRepository get _repository => ref.read(stuntingRepositoryProvider);

  Future<void> submit(Map<String, dynamic> answers) async {
    state = PredictionState(status: PredictionStatus.loading);
    try {
      final result = await _repository.predict(answers);
      state = PredictionState(status: PredictionStatus.success, result: result);
    } catch (e) {
      state = PredictionState(status: PredictionStatus.failure, error: e.toString());
    }
  }

  void reset() {
    state = PredictionState();
  }
}

final stuntingPredictionProvider =
    NotifierProvider<StuntingPredictionNotifier, PredictionState>(() {
  return StuntingPredictionNotifier();
});

// --- Recommendation Notifier ---

class RecommendationState {
  final bool isLoading;
  final RecommendationData? data;
  final String? error;

  RecommendationState({
    this.isLoading = false,
    this.data,
    this.error,
  });
}

class StuntingRecommendationNotifier extends Notifier<RecommendationState> {
  @override
  RecommendationState build() {
    return RecommendationState();
  }

  StuntingRepository get _repository => ref.read(stuntingRepositoryProvider);

  Future<void> fetch(int predictionId) async {
    state = RecommendationState(isLoading: true);
    try {
      final response = await _repository.getRecommendations(predictionId);
      state = RecommendationState(data: response.data, isLoading: false);
    } catch (e) {
      state = RecommendationState(isLoading: false, error: e.toString());
    }
  }
}

final stuntingRecommendationProvider =
    NotifierProvider<StuntingRecommendationNotifier, RecommendationState>(() {
  return StuntingRecommendationNotifier();
});
