part of 'auth_bloc.dart';

class AuthState {
  final AuthStatus status;
  final User? user;

  AuthState({
    this.status = const StatusInitial(),
    this.user,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}

class AuthStatus {
  const AuthStatus();
}
class StatusInitial extends AuthStatus {
  const StatusInitial();
}

class StatusLoading extends AuthStatus {
  const StatusLoading();
}

class StatusSuccess extends AuthStatus {
  const StatusSuccess();
}

class StatusError extends AuthStatus {
  final String message;

  const StatusError(this.message);
}