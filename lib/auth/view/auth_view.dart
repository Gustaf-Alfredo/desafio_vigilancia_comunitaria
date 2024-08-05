import 'package:desafio/auth/bloc/auth_bloc.dart';
import 'package:desafio/widgets/button_loading.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status is StatusSuccess) {
          GoRouter.of(context).go('/');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Entrar na sua conta'),
            ),
            body: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 40,
                      ),
                      child: Image.asset(
                        'assets/app_icon.png',
                        width: 256,
                        height: 256,
                      ),
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira um email';
                        } else if (!EmailValidator.validate(value)) {
                          return 'Por favor, insira um email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma senha';
                        }
                        return null;
                      },
                    ),
                    /*  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilledButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            context.read<AuthBloc>().add(
                                  Submitted(
                                    _emailController.text,
                                    _passwordController.text,
                                  ),
                                );
                          }
                        },
                        child: const Text('Entrar'),
                      ),
                    ), */
                    ButtonLoading(
                      textButton: 'Entrar2',
                      textLoading: 'Carregando...',
                      validator: true,
                      onPressed: () {},
                    ), 
                    FilledButton(
                      onPressed: () {
                        context.go('/auth/create-account');
                      },
                      child: const Text('Fazer Cadastro'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
