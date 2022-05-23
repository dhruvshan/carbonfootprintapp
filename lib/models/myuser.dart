class MyUser {
  final String uid;
  MyUser({required this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String email;
  final int goal;

  UserData(
      {required this.uid,
      required this.name,
      required this.email,
      required this.goal});
}
