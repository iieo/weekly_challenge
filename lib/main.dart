import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/navigation/router.dart';
import 'package:weekly_challenge/theme_data.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseAuth.instance.authStateChanges().listen((User? user) async {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  static const double defaultMargin = 30;
  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 35);
  static const Color primaryColor = Color.fromARGB(255, 11, 25, 46);
  static const Color primaryColorBrighter = Color.fromARGB(255, 24, 43, 69);
  static const Color whiteColor = Color.fromARGB(255, 205, 215, 245);
  static const Color whiteColorDarker = Color.fromARGB(255, 144, 150, 172);
  static const Color secondaryColor = Color.fromARGB(255, 61, 194, 143);
  static const Color secondaryColorDarker = Color.fromARGB(255, 11, 51, 65);
  static const String name = 'Challenge';
  static const String version = '0.0.1';
  static const String buildNumber = '1';
  static const Duration animationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FirestoreHandler()),
        ],
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                User? user = snapshot.data;
                if (user != null) {
                  context.read<FirestoreHandler>().fetchData();
                }
                return MaterialApp.router(
                    routerConfig: router,
                    debugShowCheckedModeBanner: false,
                    title: App.name,
                    theme: themeData);
              }
            }));
  }
}
