import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../models/userModel.dart';
import '../../utilities/myDialogBox.dart';

class EmailController {
  static Future<void> uploadUserDataToFirestore(
    UserModel recUserModel,
  ) async {
    MyDialogBox.loading(message: 'processing...');
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recUserModel.uid)
          .set(recUserModel.toMap());
    } on FirebaseException catch (e) {
      Get.back();
      MyDialogBox.showDefaultDialog(e.code, e.message.toString());
    } catch (e) {
      Get.back();
      MyDialogBox.showDefaultDialog('OOPS', e.toString());
    }
    Get.back();
  }
}
