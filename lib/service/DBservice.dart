// ignore_for_file: file_names, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Dbservice {
  final _fire = FirebaseFirestore.instance;

  void createUser(User user, String first, String middle, String last,
      String number, String photo) {
    _fire.collection('users').doc(user.uid).set({
      'first': first,
      'middle': middle,
      'last': last,
      'phone': number,
      'image': photo, // Assuming you want to store the photo URL
    });

    void updateUser(User user, String first, String middle, String last,
        String number, String photo) {
      _fire.collection('users').doc(user.uid).update({
        'first': first,
        'middle': middle,
        'last': last,
        'phone': number,
        'image': photo, // Updating the photo URL
      });
    }
  }
}
