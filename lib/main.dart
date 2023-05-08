import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weekly_challenge/components/loading_indicator.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/task.dart';
import 'package:weekly_challenge/models/task_manager.dart';
import 'package:weekly_challenge/navigation/router.dart';
import 'package:weekly_challenge/notifications/background_processing.dart';
import 'package:weekly_challenge/theme_data.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'notifications/notification_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
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

  await initNotificationPermission();
  init_background_checks();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static const double defaultRadius = 10;
  static const double defaultMargin = 30;
  static const EdgeInsets defaultPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 35);

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
                return const LoadingIndicator();
              } else {
                User? user = snapshot.data;
                if (user != null && user.emailVerified) {
                  context.read<FirestoreHandler>().fetchData(user);
                }
                return MaterialApp.router(
                    routerConfig: router,
                    debugShowCheckedModeBanner: false,
                    title: "Weekly Challenge",
                    theme: themeData2);
              }
            }));
  }
}
