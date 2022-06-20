import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:profile_app/signInScreen.dart';

class Four0Four extends StatelessWidget {
  const Four0Four({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset('images/404.jpg'),
              Card(
                margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'it seems that you didn\'t complete with your profile last time, or you are lost somewhere.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Card(
                color: Theme.of(context).colorScheme.secondary.withAlpha(100),
                margin: const EdgeInsets.only(top: 8, left: 25, right: 25),
                elevation: 10,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.5, vertical: 4),
                  child: Text(
                    'please go back to login page and complete your profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                child: const Text('Go back to Login page'),
                onPressed: () async {
                  Get.offAll(() => const SigninScreen());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
