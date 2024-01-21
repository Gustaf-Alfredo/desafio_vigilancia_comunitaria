import 'package:flutter/material.dart';
import 'package:desafio/my_app.dart';
import 'package:desafio/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => AuthService()),
  ], child: const MyApp()));
}
