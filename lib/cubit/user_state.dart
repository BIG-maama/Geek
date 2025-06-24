abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {}

class UserFailure extends UserState {
  final String message;
  final String details;
  UserFailure(this.message, this.details);
}

class UserGenderUpdated extends UserState {
  final String gender;
  UserGenderUpdated(this.gender);
}
