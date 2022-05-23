import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/myuser.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});
  //collect4ion reference

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, String email, int goal) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'goal': goal,
    });
  }

  //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get('name'),
      email: snapshot.get('email'),
      goal: snapshot.get('goal'),
    );
  }

  //get Users Stream
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
