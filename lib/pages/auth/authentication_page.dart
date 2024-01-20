import "package:desafio/components/decoration_field_authentication.dart";
import 'package:desafio/services/authentication_service.dart';
import "package:desafio/utils/my_colors.dart";
import "package:flutter/material.dart";
import "package:desafio/utils/my_snackbar.dart";

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool authenticated = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _nameController = TextEditingController();

// ! Obeservação
  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.policy,
                      color: Colors.black,
                      size: 100,
                    ),
                    const Text(
                      "LOGIN",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: getAuthenticationInputDecoration("E-mail"),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: getAuthenticationInputDecoration("Password"),
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Visibility(
                        visible: !authenticated,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _passwordConfirmController,
                              decoration: getAuthenticationInputDecoration(
                                  "Confirm passsword"),
                              obscureText: true,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _nameController,
                              decoration:
                                  getAuthenticationInputDecoration("Name"),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        )),
                    TextButton(
                      onPressed: () {
                        buttomValidateForm();
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              MyColors.purpleColor)),
                      child: Text((authenticated) ? "Entrar" : "Cadastrar",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700)),
                    ),
                    const Divider(),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            authenticated = !authenticated;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                MyColors.secondaryColor)),
                        child: Text(
                          (authenticated)
                              ? "Ainda não tem uma conta? Cadastre-se"
                              : "Já tem uma conta? Entre",
                          style: const TextStyle(color: Colors.black),
                        ))
                  ],
                ),
              ),
            )),
      ),
    );
  }

  buttomValidateForm() {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      if (authenticated) {
        // ignore: avoid_print
        print("Entrada validada");
        _authService
            .loginUsers(email: email, password: password)
            .then((String? erro) {
          if (erro != null) {
            showSnackBar(context: context, text: erro);
          }
        });
      } else {
        // ignore: avoid_print
        print("Cadastro Validado");
        // ignore: avoid_print
        print(
            "${_emailController.text},${_passwordController.text},${_nameController.text}");
        _authService
            .registerUser(name: name, password: password, email: email)
            .then(
          (String? erro) {
            // Returned with error
            if (erro != null) {
              showSnackBar(context: context, text: erro);
            }
          },
        );
      }
    } else {
      // ignore: avoid_print
      print("form inválido");
    }
  }
}
