import 'package:desafio/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            FilledButton(
              onPressed: () {
                context.go('/auth');
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }
}
