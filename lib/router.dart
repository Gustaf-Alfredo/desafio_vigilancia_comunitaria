import 'package:desafio/auth/bloc/auth_bloc.dart';
import 'package:desafio/auth/view/auth_page.dart';
import 'package:desafio/auth/widgets/auth_create.dart';
import 'package:desafio/home/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPage(),
        routes: [
          GoRoute(
            path: 'create-account',
            builder: (context, state) => BlocProvider(
              create: (_) => AuthBloc(),
              child: const AuthCreate(isCreateAccount: true),
            ),
          )
        ]),
  ],
);
