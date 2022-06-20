import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:profile_app/Four_O_Four.dart';
import 'package:profile_app/models/userModel.dart';
import 'package:profile_app/profileScreen.dart';
import 'package:profile_app/signInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  final List<String>? userModelList = prefs.getStringList('usermodel');

  if (userModelList == null) {
    runApp(MyApp(const SigninScreen()));
  } else {
    if (userModelList[6].toLowerCase() == 'true') {
      //
      final existUM = UserModel(
        uid: userModelList[0],
        name: userModelList[1],
        email: userModelList[2],
        phone: userModelList[3],
        aboutme: userModelList[4],
        profilepic: userModelList[5],
        isprofilecomplete: userModelList[6].toLowerCase() == 'true',
      );
      runApp(MyApp(ProfileScreen(existUM)));
    } else {
      runApp(MyApp(const Four0Four()));
    }
  }
}

class MyApp extends StatelessWidget {
  MyApp(this.screen, {Key? key}) : super(key: key);
  dynamic screen;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: const Color.fromARGB(255, 235, 123, 255),
      ),
      home: screen,
    );
  }
}
