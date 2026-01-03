class UserModel {
  final String uid;
  final String name;
  final String nim;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.nim,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'nim': nim,
      'email': email,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      nim: map['nim'],
      email: map['email'],
    );
  }
}
