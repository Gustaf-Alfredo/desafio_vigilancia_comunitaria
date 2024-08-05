part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

class Started extends HomeEvent {
  const Started();
}

class Refresh extends HomeEvent {
  const Refresh();
}
