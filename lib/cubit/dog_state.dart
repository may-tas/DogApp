import 'package:tot_app/models/dog_model.dart';

abstract class DogState {}

class DogInitial extends DogState {}

class DogLoading extends DogState {}

class DogLoaded extends DogState {
  final List<Dog> dogs;

  DogLoaded(this.dogs);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DogLoaded &&
          runtimeType == other.runtimeType &&
          dogs.length == other.dogs.length &&
          dogs.every((dog) => other.dogs.contains(dog));

  @override
  int get hashCode => dogs.hashCode;
}

class DogError extends DogState {
  final String message;

  DogError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DogError &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
