part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class Started extends AuthEvent {
  const Started();
}


class Submitted extends AuthEvent {
  final String email;
  final String password;

  const Submitted(
    this.email,
    this.password,
  );
}
