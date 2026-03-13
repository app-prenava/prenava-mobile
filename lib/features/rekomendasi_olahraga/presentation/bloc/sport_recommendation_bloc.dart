import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/sport_recommendation_repository.dart';
import 'sport_recommendation_event.dart';
import 'sport_recommendation_state.dart';

class SportRecommendationBloc extends Bloc<SportRecommendationEvent, SportRecommendationState> {
  final SportRecommendationRepository repository;

  SportRecommendationBloc({required this.repository}) : super(SportRecommendationInitial()) {
    on<GetSportRecommendationEvent>(_onGetSportRecommendation);
    on<SubmitSportAssessmentEvent>(_onSubmitSportAssessment);
  }

  Future<void> _onGetSportRecommendation(
      GetSportRecommendationEvent event, Emitter<SportRecommendationState> emit) async {
    emit(SportRecommendationLoading());

    final failureOrResponse = await repository.getSportRecommendation();

    failureOrResponse.fold(
      (failure) {
        final errorMsg = failure.message.toLowerCase();

        if (errorMsg.contains('tanggal lahir tidak ditemukan')) {
          emit(SportRecommendationNeedsProfile(failure.message));
        } else if (errorMsg.contains('lmp') || errorMsg.contains('pregnancy')) {
           emit(SportRecommendationNeedsLmp(failure.message));
        } else if (errorMsg.contains('assessment')) {
           emit(SportRecommendationNeedsAssessment(failure.message));
        } else {
           emit(SportRecommendationError(failure.message));
        }
      },
      (response) {
        final needsUpdate = response.needUpdateData ?? false;
        
        // If data is stale, we indicate to show assessment update prompt
        emit(SportRecommendationLoaded(response, showUpdateAssessmentPrompt: needsUpdate));
      },
    );
  }

  Future<void> _onSubmitSportAssessment(
      SubmitSportAssessmentEvent event, Emitter<SportRecommendationState> emit) async {
    emit(SportRecommendationLoading());

    final failureOrResponse = await repository.createSportRecommendation(event.request);

    failureOrResponse.fold(
      (failure) => emit(SportRecommendationError(failure.message)),
      (response) {
         emit(SportRecommendationLoaded(response, showUpdateAssessmentPrompt: false));
      },
    );
  }
}
