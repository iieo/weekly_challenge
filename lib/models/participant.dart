import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Image defaultProfile =
    const Image(image: AssetImage("assets/images/empty_profile.png"));

class Participant {
  String id;
  String name;
  String email;
  String? profilePictureUrl;
  Image profileImage = defaultProfile;
  CachedNetworkImage? profilePicture;
  int points;

  Participant(
      {required this.id,
      required this.email,
      required this.name,
      this.profilePictureUrl,
      this.points = 0});

  Participant.fromMap(this.id, Map<String, dynamic> map)
      : name = map['name'],
        email = map['email'] ?? "",
        profilePictureUrl = map['profilePictureUrl'],
        points = map['points'] ?? 0;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'points': points,
    };
  }

  static Participant loadingParticipant = Participant(
      id: "loading",
      name: "loading",
      email: "loading",
      profilePictureUrl: "loading",
      points: 0);
}
