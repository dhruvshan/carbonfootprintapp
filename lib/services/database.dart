import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/models/myuser.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference petCollection =
      FirebaseFirestore.instance.collection('pets');

  Future updateUserData(
      String? name,
      String? email,
      num? goal,
      String? petName,
      num? score,
      String? petType,
      Object? waterHeight,
      Object? scoreProgress,
      Object? recoList,
      String? lastCalcTime,
      int? killCount,
      Object? pickedOptions) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'goal': goal,
      'petName': petName,
      'score': score,
      'petType': petType,
      'waterHeight': waterHeight,
      'scoreProgress': scoreProgress,
      'recoList': recoList,
      'lastCalcTime': lastCalcTime,
      'killCount': killCount,
      'pickedOptions': pickedOptions,
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.get('name'),
        email: snapshot.get('email'),
        goal: snapshot.get('goal'),
        petName: snapshot.get('petName'),
        score: snapshot.get('score'),
        petType: snapshot.get('petType'),
        waterHeight: snapshot.get('waterHeight'),
        scoreProgress: snapshot.get('scoreProgress'),
        recoList: snapshot.get('recoList'),
        lastCalcTime: snapshot.get('lastCalcTime'),
        killCount: snapshot.get('killCount'),
        pickedOptions: snapshot.get('pickedOptions'));
  }

  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
