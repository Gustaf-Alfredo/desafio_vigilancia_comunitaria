import 'package:bloc/bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<Started>(_onStarted);
  }

  Future<void> _onStarted(
    Started event,
    Emitter<HomeState> emit,
  ) async {}
}
