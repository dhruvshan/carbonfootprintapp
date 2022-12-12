class MyUser {
  final String uid;
  MyUser({required this.uid});
}

class UserData {
  final String? uid;
  final String name;
  final String email;
  final num goal;
  final String petName;
  final num score;
  final String petType;
  final Object waterHeight;
  final Object scoreProgress;
  final Object recoList;
  final String lastCalcTime;
  final int killCount;
  final Object pickedOptions;

  UserData(
      {required this.uid,
      required this.name,
      required this.email,
      required this.goal,
      required this.petName,
      required this.score,
      required this.petType,
      required this.waterHeight,
      required this.scoreProgress,
      required this.recoList,
      required this.lastCalcTime,
      required this.killCount,
      required this.pickedOptions});
}
