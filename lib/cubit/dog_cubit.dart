import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_app/cubit/dog_state.dart';
import 'package:tot_app/services/dog_api_service.dart';
import '../models/dog_model.dart';
import '../services/database_service.dart';

class DogCubit extends Cubit<DogState> {
  final ApiService _apiService;
  final DatabaseService _databaseService;
  List<Dog> _allDogs = [];
  List<Dog> _savedDogs = []; // Keep track of saved dogs

  DogCubit(this._apiService, this._databaseService) : super(DogInitial());

  Future<void> fetchDogs() async {
    try {
      emit(DogLoading());
      _allDogs = await _apiService.getDogs();
      emit(DogLoaded(_allDogs));
    } catch (e) {
      emit(DogError(e.toString()));
    }
  }

  Future<void> saveDog(Dog dog) async {
    try {
      await _databaseService.saveDog(dog);
      // Update saved dogs list if we're showing saved dogs
      if (state is DogLoaded && _savedDogs.isNotEmpty) {
        _savedDogs.add(dog);
        emit(DogLoaded(_savedDogs));
      }
    } catch (e) {
      emit(DogError(e.toString()));
    }
  }

  Future<void> deleteDog(Dog dog) async {
    try {
      // Store current state
      final currentState = state;
      if (currentState is DogLoaded) {
        // Optimistically remove the dog from the list
        _savedDogs = currentState.dogs.where((d) => d.id != dog.id).toList();
        emit(DogLoaded(_savedDogs));

        // Actually delete from database
        await _databaseService.deleteDog(dog.id);
      }
    } catch (e) {
      // If deletion fails, revert to previous state
      await getSavedDogs(); // Reload the actual state from database
      emit(DogError('Failed to delete dog: ${e.toString()}'));
    }
  }

  Future<void> getSavedDogs() async {
    try {
      emit(DogLoading());
      _savedDogs = await _databaseService.getSavedDogs();
      emit(DogLoaded(_savedDogs));
    } catch (e) {
      print(e);
      emit(DogError(e.toString()));
    }
  }

  void searchDogs(String query) {
    if (query.isEmpty) {
      emit(DogLoaded(_allDogs));
      return;
    }

    final filteredDogs = _allDogs.where((dog) {
      return dog.name.toLowerCase().contains(query.toLowerCase()) ||
          dog.breedGroup.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(DogLoaded(filteredDogs));
  }
}
