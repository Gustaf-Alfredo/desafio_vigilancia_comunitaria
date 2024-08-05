import 'package:flutter/material.dart';
import 'router.dart'; // Certifique-se de que a importação está correta

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        routerConfig:
            router, // Certifique-se de que o router está configurado corretamente no arquivo router.dart
        title: 'Vigilância Comunitária',
        debugShowCheckedModeBanner:
            false, // Normalmente queremos ocultar a faixa de debug para uma aplicação de produção
        theme: ThemeData(
          filledButtonTheme: FilledButtonThemeData(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(
                const Color.fromARGB(255, 50, 51, 51),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey[300],
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ));
  }
}
