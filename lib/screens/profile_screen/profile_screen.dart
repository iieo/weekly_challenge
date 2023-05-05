import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/firebase/firebase_auth_handler.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/participant.dart';
import 'package:weekly_challenge/screens/homescreen/components/box.dart';
import 'package:weekly_challenge/screens/screen_container.dart';

final _formKey = GlobalKey<FormState>();

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController pointController = TextEditingController();

  bool _isValidName() {
    return nameController.text.characters.length > 5;
  }

  void _changeProfilePicture() {
    FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false)
        .then((result) {
      if (result == null) return;
      context.read<FirestoreHandler>().uploadProfilePicture(
          result.files.single.bytes, result.files.single.name);
    });
  }

  @override
  Widget build(BuildContext context) {
    Participant participant = context.watch<FirestoreHandler>().participant;

    nameController.text = participant.name;
    pointController.text = participant.points.toString();

    return ScreenContainer(title: "Profil", children: [
      Box(
          headline: "Profil",
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                    child: Stack(children: [
                  CircleAvatar(
                    radius: 100,
                    foregroundImage: participant.profilePictureUrl != null
                        ? NetworkImage(
                            participant.profilePictureUrl!,
                            scale: 1.0,
                          )
                        : const AssetImage("/images/empty_profile.png")
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                        decoration: ShapeDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: const CircleBorder(),
                        ),
                        child: IconButton(
                          onPressed: _changeProfilePicture,
                          icon: const Icon(Icons.mode_edit_outlined),
                          iconSize: 30,
                        )),
                  ),
                ])),
                const SizedBox(height: 30),
                TextField(
                    decoration: InputDecoration(
                        border: const UnderlineInputBorder(),
                        prefixIcon: const Icon(Icons.person),
                        prefixText: 'Name',
                        errorText: _isValidName() ? null : '✗ Invalid Name',
                        hintText: 'Enter valid name.'),
                    readOnly: false,
                    key: _formKey,
                    onChanged: (String name) {
                      participant.name = name;
                    },
                    textAlign: TextAlign.center,
                    controller: nameController,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                TextField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                        prefixText: 'Email:'),
                    enabled: false,
                    controller: TextEditingController(
                        text: FirebaseAuthHandler.getEmailAddress()),
                    textAlign: TextAlign.center,
                    readOnly: true,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 10),
                TextField(
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        prefixIcon: Icon(Icons.star_outline_sharp),
                        prefixText: 'Points:'),
                    enabled: false,
                    controller: pointController,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 35),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.published_with_changes_sharp),
                      onPressed: () {},
                      label: Text("Update Profile",
                          style: Theme.of(context).textTheme.labelMedium),
                    )),
                const SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.logout),
                      onPressed: FirebaseAuthHandler.logout,
                      label: Text("Abmelden",
                          style: Theme.of(context).textTheme.labelMedium),
                    ))
              ])),
    ]);
  }
}
