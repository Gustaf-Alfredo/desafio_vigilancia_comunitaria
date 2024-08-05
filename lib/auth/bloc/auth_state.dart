part of 'auth_bloc.dart';

class AuthState {
  const AuthState();
}

class Initial extends AuthState {
  const Initial();
}

class Loading extends AuthState {
  const Loading();
}

class Logged extends AuthState {
  const Logged();
}