// States
import 'package:tot_app/models/dog_model.dart';

abstract class DogState {}

class DogInitial extends DogState {}

class DogLoading extends DogState {}

class DogLoaded extends DogState {
  final List<Dog> dogs;
  DogLoaded(this.dogs);
}

class DogError extends DogState {
  final String message;
  DogError(this.message);
}
