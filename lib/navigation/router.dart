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
    const loginLocation = "/login";
    const signupLocation = "/signup";
    const homeLocation = "/";

    final bool loggedIn = FirebaseAuth.instance.currentUser != null;
    final bool loggingIn =
        state.subloc == loginLocation || state.subloc == signupLocation;

    if (loggedIn &&
        !FirebaseAuth.instance.currentUser!.emailVerified &&
        state.subloc == signupLocation) {
      return loginLocation;
    }

    if (!loggedIn && !loggingIn) {
      return loginLocation;
    }

    if (loggingIn && loggedIn) {
      return homeLocation;
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
          name: 'logout',
          path: 'logout',
          builder: (BuildContext context, GoRouterState state) {
            FirebaseAuth.instance.signOut();
            return const AuthScreen(child: LoginContainer());
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
