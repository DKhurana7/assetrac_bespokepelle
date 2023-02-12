import 'package:assetrac_bespokepelle/screens/homepage.dart';
import 'package:assetrac_bespokepelle/screens/login.dart';
import 'package:assetrac_bespokepelle/services/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Color(0XFF0A233E)));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something Went Wrong!'));
            } else if(snapshot.hasData) {
              return const VerifyEmailPage();
            } else {
              return const AuthPage();
            }
          }
        ),
      )
    );
  }
}
