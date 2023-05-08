import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/participant.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key});

  void _changeProfilePicture(BuildContext context) {
    FilePicker.platform
        .pickFiles(type: FileType.image, allowMultiple: false)
        .then((result) {
      if (result == null) return;

      if (kIsWeb) {
        context.read<FirestoreHandler>().uploadProfilePicture(
            result.files.single.bytes, result.files.single.name);
      } else {
        File file = File(result.files.single.path!);
        context.read<FirestoreHandler>().uploadProfilePicture(
            file.readAsBytesSync(), result.files.single.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Participant participant = context.watch<FirestoreHandler>().participant;

    return Center(
        child: Stack(children: [
      CircleAvatar(
        radius: 100,
        foregroundImage: participant.profilePictureUrl != null
            ? CachedNetworkImageProvider(participant.profilePictureUrl!,
                scale: 1.0)
            : const AssetImage("/images/empty_profile.png") as ImageProvider,
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
              onPressed: () => _changeProfilePicture(context),
              icon: const Icon(Icons.mode_edit_outlined),
              iconSize: 30,
            )),
      ),
    ]));
  }
}
