import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:weekly_challenge/firebase/firebase_auth_handler.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/screens/homescreen/components/box.dart';
import 'package:weekly_challenge/screens/profile_screen/components/edit_account_details.dart';
import 'package:weekly_challenge/screens/profile_screen/components/profile_avatar.dart';
import 'package:weekly_challenge/screens/screen_container.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ScreenContainer(title: "Profil", children: [
      Box(
          headline: "Profil",
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                ProfileAvatar(),
                SizedBox(height: 30),
                EditAccountDetails(),
              ])),
      const SizedBox(height: App.defaultBoxMargin),
      Box(
        headline: "Theme",
        child: ToggleSwitch(
          minWidth: 90.0,
          minHeight: 40.0,
          animationDuration: 150,
          totalSwitches: 2,
          cornerRadius: 20.0,
          activeBgColor: [
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.secondary
          ],
          curve: Curves.easeIn,
          animate: true,
          activeFgColor: Theme.of(context).colorScheme.onSecondary,
          inactiveBgColor: Theme.of(context).colorScheme.primaryContainer,
          inactiveFgColor: Theme.of(context).colorScheme.onPrimary,
          labels: const ['Light', 'Dark'],
          centerText: true,
          icons: const [Icons.wb_sunny, Icons.nightlight_round],
          onToggle: (index) {
            if (index == 0) {
              //light
            } else {
              //dark
            }
          },
        ),
      ),
      const SizedBox(height: App.defaultBoxMargin),
      Box(
        headline: "Einstellungen",
        child: Column(children: [
          SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                onPressed: FirebaseAuthHandler.logout,
                label: Text("Abmelden",
                    style: Theme.of(context).textTheme.labelMedium),
              ))
        ]),
      )
    ]);
  }
}
