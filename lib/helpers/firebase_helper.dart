import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../models/userModel.dart';
import '../utilities/constants.dart';
import '../utilities/myDialogBox.dart';

class FirebaseHelper {
  //

  static Future<UserModel?> fetchUserDetailsByUid({
    required String uid,
    bool? no,
  }) async {
    //
    if (no == null) MyDialogBox.loading();
    final DocumentSnapshot userDocumentSnapshot =
        await fire.collection('users').doc(uid).get();

    if (!userDocumentSnapshot.exists) return null;

    final userData = userDocumentSnapshot.data() as Map<String, dynamic>;

    final fetchedUserModel = UserModel(
      uid: uid,
      name: userData['name'],
      profilepic: userData['profilepic'],
      email: userData['email'],
      phone: userData['phone'],
      aboutme: userData['aboutme'],
      isprofilecomplete: userData['isprofilecomplete'],
    );
    if (no == null) Get.back();
    return fetchedUserModel;
  }
}
