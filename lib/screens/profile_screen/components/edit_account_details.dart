import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/firebase/firebase_auth_handler.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/models/participant.dart';

class EditAccountDetails extends StatefulWidget {
  const EditAccountDetails({super.key});

  @override
  State<EditAccountDetails> createState() => _EditAccountDetailsState();
}

class _EditAccountDetailsState extends State<EditAccountDetails> {
  final TextEditingController nameController = TextEditingController();

  bool _isValidName() {
    return nameController.text.characters.length > 2;
  }

  void _saveChanges() {
    if (_isValidName()) {
      context
          .read<FirestoreHandler>()
          .updateParticipantName(nameController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Ungültiger Name: Zu kurz"),
        duration: Duration(seconds: 1),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Participant participant = context.watch<FirestoreHandler>().participant;

    nameController.text = participant.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
            decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                prefixText: 'Name',
                errorText: _isValidName() ? null : 'Ungültiger Name',
                hintText: 'Max Mustermann',
                hintStyle: Theme.of(context).textTheme.titleMedium,
                prefixStyle: Theme.of(context).textTheme.titleMedium),
            readOnly: false,
            onFieldSubmitted: (name) => _saveChanges(),
            textAlign: TextAlign.center,
            controller: nameController,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: App.defaultBoxMargin * 2),
        TextField(
            decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                prefixIcon: const Icon(
                  Icons.email,
                  color: Colors.white,
                ),
                prefixText: 'Email:',
                prefixStyle: Theme.of(context).textTheme.titleMedium),
            enabled: false,
            controller: TextEditingController(
                text: FirebaseAuthHandler.getEmailAddress()),
            textAlign: TextAlign.center,
            readOnly: true,
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        TextField(
            decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                prefixIcon: const Icon(
                  Icons.star_outline_sharp,
                  color: Colors.white,
                ),
                prefixText: 'Points:',
                prefixStyle: Theme.of(context).textTheme.titleMedium),
            enabled: false,
            controller:
                TextEditingController(text: participant.points.toString()),
            textAlign: TextAlign.center,
            readOnly: true,
            style: Theme.of(context).textTheme.titleMedium)
      ],
    );
  }
}
