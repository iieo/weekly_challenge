import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/task.dart';
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
  if (kIsWeb) {
    FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }

  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  static const double defaultMargin = 30;
  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 35);

  static const String name = 'Challenge';
  static const String version = '0.0.1';
  static const String buildNumber = '1';
  static const Duration animationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => FirestoreHandler(),
            lazy: true,
          ),
          ChangeNotifierProvider(create: (_) => TaskManager()),
        ],
        child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary);
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
