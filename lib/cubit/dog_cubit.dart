import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tot_app/cubit/dog_state.dart';
import 'package:tot_app/services/dog_api_service.dart';
import '../models/dog_model.dart';
import '../services/database_service.dart';

// Cubit
class DogCubit extends Cubit<DogState> {
  final ApiService _apiService;
  final DatabaseService _databaseService;
  List<Dog> _allDogs = [];

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
    } catch (e) {
      emit(DogError(e.toString()));
    }
  }

  Future<void> deleteDog(Dog dog) async {
    try {
      await _databaseService.deleteDog(dog.id);
    } catch (e) {
      emit(DogError(e.toString()));
    }
  }

  Future<void> getSavedDogs() async {
    try {
      emit(DogLoading());
      final dogs = await _databaseService.getSavedDogs();
      emit(DogLoaded(dogs));
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
