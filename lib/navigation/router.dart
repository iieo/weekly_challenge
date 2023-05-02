import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weekly_challenge/authentication/authentication.dart';
import 'package:weekly_challenge/authentication/login_container.dart';
import 'package:weekly_challenge/authentication/signup_container.dart';
import 'package:weekly_challenge/screens/bottom_navigation_shell.dart';
import 'package:weekly_challenge/screens/challenges_screen/challenges_screen.dart';
import 'package:weekly_challenge/screens/homescreen/homescreen.dart';
import 'package:weekly_challenge/navigation/gorouter_refresh_stream.dart';
import 'package:weekly_challenge/screens/profile_screen/profile_screen.dart';
import 'package:weekly_challenge/screens/tasks_screen/tasks_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  initialLocation: "/",
  navigatorKey: _rootNavigatorKey,
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
      path: '/login',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(
            child: AuthScreen(child: LoginContainer()));
      },
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (BuildContext context, GoRouterState state) {
        return const NoTransitionPage(
            child: AuthScreen(child: SignUpContainer()));
      },
    ),
    GoRoute(
      path: '/logout',
      pageBuilder: (BuildContext context, GoRouterState state) {
        FirebaseAuth.instance.signOut();
        return const NoTransitionPage(
            child: AuthScreen(child: LoginContainer()));
      },
    ),
    ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return NoTransitionPage(child: BottomNavigationShell(child: child));
        },
        routes: [
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/challenges',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: ChallengesScreen());
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/profil',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: ProfileScreen());
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: '/tasks',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: TasksScreen());
            },
          ),
          GoRoute(
            parentNavigatorKey: _shellNavigatorKey,
            path: "/",
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
        ])
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
