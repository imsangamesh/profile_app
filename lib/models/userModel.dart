class UserModel {
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? aboutme;
  String? profilepic;
  bool isprofilecomplete = false;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.aboutme,
    required this.profilepic,
    required this.isprofilecomplete,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'aboutme': aboutme,
      'profilepic': profilepic,
      'isprofilecomplete': isprofilecomplete,
    };
  }

  List<String> toList() {
    return [
      uid ?? '',
      name ?? '',
      email ?? '',
      phone ?? '',
      aboutme ?? '',
      profilepic ?? '',
      isprofilecomplete.toString(),
    ];
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    email = map['email'];
    phone = map['phone'];
    aboutme = map['aboutme'];
    profilepic = map['profilepic'];
    isprofilecomplete = map['isprofilecomplete'];
  }
}
