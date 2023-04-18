import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weekly_challenge/authentication/authentication.dart';
import 'package:weekly_challenge/authentication/login_container.dart';
import 'package:weekly_challenge/authentication/signup_container.dart';
import 'package:weekly_challenge/challenges_screen/challenges_screen.dart';
import 'package:weekly_challenge/homescreen/homescreen.dart';
import 'package:weekly_challenge/navigation/gorouter_refresh_stream.dart';

final GoRouter router = GoRouter(
  redirect: (context, state) {
    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    const loginLocation = "/login";
    final loggingIn = state.subloc == loginLocation;

    const homeLocation = "/";

    if (!loggedIn) {
      if (state.subloc == "/signup") {
        return null;
      }
      return loginLocation;
    }

    if (loggingIn) {
      state.queryParams['from'];
      return state.queryParams['from'] ?? homeLocation;
    }

    return null;
  },
  refreshListenable:
      GoRouterRefreshStream(FirebaseAuth.instance.authStateChanges()),
  errorBuilder: (context, state) => const NotFoundScreen(),
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          name: 'login',
          path: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthScreen(child: LoginContainer());
          },
        ),
        GoRoute(
          name: 'signup',
          path: 'signup',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthScreen(child: SignUpContainer());
          },
        ),
        GoRoute(
          name: 'challenges',
          path: 'challenges',
          builder: (BuildContext context, GoRouterState state) {
            return const ChallengesScreen();
          },
        ),
      ],
    ),
  ],
);

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          '404 Not Found',
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
