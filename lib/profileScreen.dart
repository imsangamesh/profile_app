import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profile_app/models/userModel.dart';
import 'package:profile_app/profile_fill_up_screen.dart';
import 'package:profile_app/signInScreen.dart';

import 'utilities/constants.dart';

class ProfileScreen extends StatelessWidget {
  static const String routeName = '/profile-screen';

  final UserModel userModel;

  const ProfileScreen(this.userModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('my profile'),
        actions: [
          IconButton(
            onPressed: () => Get.to(() => ProfileFillUpScreen(
                  userModel: userModel,
                  isEdit: true,
                )),
            icon: const Icon(Icons.edit_note_sharp, size: 32),
          ),
          IconButton(
            onPressed: () => Get.offAll(() => const SigninScreen()),
            icon: const Icon(Icons.logout, size: 23),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              // ----------------circle Avatar----------------------
              CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor.withAlpha(80),
                radius: 70,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(userModel.profilepic!),
                ),
              ),
              const SizedBox(height: 10),
              // ---------------- name ----------------------
              MyLabelTile(userModel.name!, Icons.person),
              MyLabelTile(userModel.email!, Icons.email),
              MyLabelTile(userModel.aboutme!, Icons.short_text),
              MyLabelTile(
                userModel.phone!,
                Icons.ring_volume_rounded,
                tStyle: kSmallSizeBoldTextStyle.copyWith(
                  overflow: TextOverflow.fade,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyLabelTile extends StatelessWidget {
  MyLabelTile(
    this.label,
    this.icon, {
    Key? key,
    this.tStyle,
  }) : super(key: key);

  final String label;
  final IconData icon;
  TextStyle? tStyle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.only(right: 10, left: 20, top: 5, bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withAlpha(40),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: Theme.of(context).primaryColor),
            const SizedBox(width: 20),
            Text(
              label,
              style: tStyle ??
                  kNormalSizeTextStyle.copyWith(
                    overflow: TextOverflow.fade,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
