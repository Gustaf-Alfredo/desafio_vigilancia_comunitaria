import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:desafio/helpers.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<Started>(
      onStarted,
      transformer: droppable(),
    );
    on<Submitted>(
      onSubmitted,
      transformer: droppable(),
    );
    on<CreatedAccount>(
      onCreatedAccount,
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
  ) async {
    try {
      emit(state.copyWith(status: const StatusLoading()));
      FirebaseAuth.instance.idTokenChanges().listen(
        (User? user) {
          if (user == null) {
            talker.info('Usuário não autenticado');
          } else {
            emit(
              state.copyWith(
                status: const StatusSuccess(),
                user: user,
              ),
            );
            talker.info('Usuário autenticado');
          }
        },
      );
    } on DioException catch (e) {
      talker.error(e.message);
    }
  }

  Future<void> onCreatedAccount(
    CreatedAccount event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(state.copyWith(status: const StatusLoading()));
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      emit(
        state.copyWith(
          status: const StatusSuccess(),
          user: userCredential.user,
        ),
      );

      talker.info('Usuário criado: ${userCredential.user!.email}');
      talker.warning(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(state.copyWith(status: const StatusError('Senha fraca')));
       talker.warning('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(state.copyWith(status: const StatusError('Email já em uso')));
        talker.warning('The account already exists for that email.');
      }
    } catch (e) {
      talker.handle(e);
    }
  }
}
