import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<Started>(
      onStarted,
      transformer: droppable(),
    );
  }
  Future<void> onStarted(
    Started event,
    Emitter<AuthState> emit,
  ) async {}
  Future<void> onSubmitted(
    Submitted event,
    Emitter<AuthState> emit,
  ) async {}
}
