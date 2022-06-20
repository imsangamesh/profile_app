import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profile_app/helpers/email_controller.dart';
import 'package:profile_app/profile_fill_up_screen.dart';
import 'package:profile_app/utilities/constants.dart';
import 'package:profile_app/utilities/myDialogBox.dart';

import 'models/userModel.dart';

class SigninScreen extends StatelessWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('images/signin.jpg'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              label: const Text(
                '  Signin anonymously  ',
                style: kSmallSizeBoldTextStyle,
              ),
              icon: const Icon(Icons.person_rounded),
              onPressed: myAnonymousSignin,
              style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 7,
                    horizontal: 10,
                  )),
            ),
            const SizedBox(height: 100),
          ],
        )),
      ),
    );
  }

  static myAnonymousSignin() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final user = userCredential.user;

      final newUserModel = UserModel(
        uid: user!.uid,
        name: 'guest',
        aboutme: '',
        profilepic:
            'https://as2.ftcdn.net/v2/jpg/02/29/75/83/1000_F_229758328_7x8jwCwjtBMmC6rgFzLFhZoEpLobB6L8.jpg',
        email: 'guest@gmail.com',
        phone: '',
        isprofilecomplete: false,
      );

      await EmailController.uploadUserDataToFirestore(newUserModel);
      Get.to(() => ProfileFillUpScreen(isEdit: false, userModel: newUserModel));
      //
    } on FirebaseAuthException catch (e) {
      MyDialogBox.showDefaultDialog('OOPS', e.message.toString());
    } catch (e) {
      MyDialogBox.normalDialog();
    }
  }
}
// pending_actions_rounded
// perm_phone_msg_rounded