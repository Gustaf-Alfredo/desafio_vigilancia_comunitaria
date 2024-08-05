import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:desafio/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  ) async {
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) {
        if (user == null) {
          talker.info('Usuário não autenticado');
        } else {
          talker.info('Usuário autenticado');
        }
      },
    );
  }

  Future<void> onSubmitted(
    Submitted event,
    Emitter<AuthState> emit,
  ) async {}
}
