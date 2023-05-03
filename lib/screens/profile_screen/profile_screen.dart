import 'package:cached_network_image/cached_network_image.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/components/button.dart';
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
  void updateProfile(Participant participant, Image? newImage) {
    setState(() {});
    //context.watch<FirestoreHandler>().updateParticipant(participant);
    if (newImage != null) {
      //context.watch<FirestoreHandler>().uploadProfilePicture(newImage);
    }
  }

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pointController = TextEditingController();

  bool isValidName() {
    return nameController.text.characters.length > 5;
  }

  @override
  Widget build(BuildContext context) {
    Participant participant = context.watch<FirestoreHandler>().participant ??
        Participant.loadingParticipant;

    nameController.text = participant.name;
    emailController.text = participant.email;
    pointController.text = participant.points.toString();

    String name = nameController.text;

    return ScreenContainer(title: "Profil", children: [
      Box(
          headline: "Profil",
          child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                    child: Stack(children: [
                  Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                          radius: 100,
                          foregroundImage: participant.profileImage.image)),
                  Positioned(
                    bottom: 1,
                    right: 1,
                    child: ElevatedButton(
                        onPressed: () async {
                          XFile? file = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);

                          if (file == null) return;

                          Image? newImg = Image(image: XFileImage(file));

                          if (newImg == null) return;

                          participant.profileImage = newImg;

                          updateProfile(participant, newImg);
                        },
                        child: Icon(Icons.mode_edit_outlined),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(20))),
                  ),
                ])),
                const SizedBox(height: 30),
                TextField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                        prefixText: 'Name',
                        errorText: isValidName() ? null : '✗ Invalid Name',
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
                    controller: emailController,
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
                      icon: Icon(Icons.published_with_changes_sharp),
                      onPressed: () {
                        setState(() {
                          if (!isValidName()) {
                            return;
                          }
                        });
                        updateProfile(participant, null);
                      },
                      label: Text("Update Profile"),
                    )),
                const SizedBox(height: 10),
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.logout),
                      onPressed: FirebaseAuthHandler.logout,
                      label: Text("Abmelden"),
                    ))
              ])),
    ]);
  }
}
