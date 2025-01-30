import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/database_service.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final DatabaseService _databaseService;

  HistoryCubit(this._databaseService) : super(HistoryInitial());

  Future<void> loadJourneys() async {
    try {
      emit(HistoryLoading());
      final journeys = await _databaseService.getSavedJourneys();
      emit(HistoryLoaded(journeys));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> deleteJourney(int journeyId) async {
    try {
      // Add delete journey method to DatabaseService first
      await _databaseService.deleteJourney(journeyId);
      // Reload journeys after deletion
      await loadJourneys();
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }
}
