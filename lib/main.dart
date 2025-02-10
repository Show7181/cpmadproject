import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'screens/cartprovider.dart';
import 'screens/login_page.dart';

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
  options:
DefaultFirebaseOptions.currentPlatform,);
 runApp( ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),);
 
}

class MyApp extends StatelessWidget {
 const MyApp({super.key});
 @override
 Widget build(BuildContext context) {
 return const MaterialApp(
 debugShowCheckedModeBanner: false,
 title: 'Firebase Firestore App',

 home: LoginPage(),
 );
 }
}