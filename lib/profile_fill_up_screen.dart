import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:profile_app/helpers/profile_controller.dart';
import 'package:profile_app/profileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../models/userModel.dart';
import '../../utilities/constants.dart';
import '../../utilities/myDialogBox.dart';
import 'helpers/email_controller.dart';

class ProfileFillUpScreen extends StatefulWidget {
  final UserModel userModel;
  final bool isEdit;

  const ProfileFillUpScreen({
    Key? key,
    required this.userModel,
    required this.isEdit,
  }) : super(key: key);

  @override
  State<ProfileFillUpScreen> createState() => _ProfileFillUpScreenState();
}

class _ProfileFillUpScreenState extends State<ProfileFillUpScreen> {
  //
  File? imageFile;
  bool isImage = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final _profScr = ProfileController();
  CountryCode countryCode = CountryCode(code: 'IN', dialCode: '+91');
  bool settingDataOver = false;

  bool isChanged = false;

  void showPhotoOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          ListTile(
            leading: const Icon(Icons.photo_library_outlined),
            title: const Text('Choose a photo'),
            onTap: () {
              _selectImage(ImageSource.gallery);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_rounded),
            title: const Text('Take a photo'),
            onTap: () {
              _selectImage(ImageSource.camera);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _setUserData() async {
    _nameController.text = widget.userModel.name!;
    _aboutController.text = widget.userModel.aboutme!;
    _emailController.text = widget.userModel.email!;
    _phoneController.text = widget.userModel.phone!;

    setState(() => settingDataOver = true);
  }

  void _selectImage(ImageSource source) async {
    var imageFileRec = await _profScr.selectImageOfController(source);

    if (imageFileRec == null) return;

    setState(() {
      isImage = true;
      imageFile = imageFileRec;
      isChanged = true;
    });
  }

  void _checkValues() {
    if (widget.isEdit) {
      _saveForm();
      return;
    }

    if (imageFile == null || isImage == false) {
      MyDialogBox.showDefaultDialog(
        'OOPS',
        'please make sure that you have added your profile photo.',
      );
      return;
    } else {
      _saveForm();
    }
  }

  void _saveForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();
    uploadUserData();
  }

  void uploadUserData() async {
    try {
      String idToBeUploaded = const Uuid().v1();

      if (widget.userModel.isprofilecomplete) {
        idToBeUploaded = widget.userModel.uid!;
      }
      String imageDownloadUrl = '';
      if (!widget.isEdit) {
        TaskSnapshot taskSnapshot = await store
            .ref()
            .child('profilepictures')
            .child(idToBeUploaded)
            .putFile(imageFile!);

        imageDownloadUrl = await taskSnapshot.ref.getDownloadURL();
      } else {
        imageDownloadUrl = widget.userModel.profilepic!;
      }

      UserModel newlyCompletedUserModel = UserModel(
        uid: idToBeUploaded,
        name: _nameController.text,
        profilepic: imageDownloadUrl,
        email: _emailController.text,
        phone: _phoneController.text,
        aboutme: _aboutController.text,
        isprofilecomplete: true,
      );

      EmailController.uploadUserDataToFirestore(newlyCompletedUserModel);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('usermodel', newlyCompletedUserModel.toList());

      Get.back();
      MyDialogBox.showDefaultDialog(
        'Hurray !',
        'your profile updated successfully.',
      );

      Get.offAll(ProfileScreen(newlyCompletedUserModel));
    } on FirebaseException catch (e) {
      MyDialogBox.showDefaultDialog(e.code, e.message.toString());
    } catch (e) {
      MyDialogBox.showDefaultDialog('OOPS', e.toString());
    }
  }

  @override
  void initState() {
    if (widget.isEdit) {
      Future.delayed(const Duration(milliseconds: 10))
          .then((value) => _setUserData());
    }
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _aboutController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'edit profile' : 'profile fill up'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 30),
                InkWell(
                  // ----------------circle Avatar----------------------
                  customBorder: const CircleBorder(),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    showPhotoOptions();
                  },
                  borderRadius: BorderRadius.circular(60),
                  splashColor: theme.primaryColor.withOpacity(0.5),
                  child: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).primaryColor.withAlpha(80),
                    radius: 70,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: theme.primaryColor.withOpacity(0.25),
                      backgroundImage: isImage ? FileImage(imageFile!) : null,
                      child: widget.isEdit && isChanged == false
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child:
                                  Image.network(widget.userModel.profilepic!))
                          : imageFile == null
                              ? Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 50,
                                  color: theme.colorScheme.secondary,
                                )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  // ----------------name----------------------
                  validator: (v) {
                    final value = v.toString().trim();
                    if (value == '') {
                      return 'please provide your name.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'name',
                    icon: Icon(
                      Icons.person_rounded,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  // ----------------about me----------------------
                  decoration: InputDecoration(
                    labelText: 'about me',
                    icon: Icon(
                      Icons.notes_rounded,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  controller: _aboutController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.name,
                ),
                TextFormField(
                  // ----------------e mail----------------------
                  validator: (v) {
                    final value = v.toString().trim();
                    if (!EmailValidator.validate(value)) {
                      return 'please provide a valid email address.';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'e mail',
                    icon: Icon(
                      Icons.email_outlined,
                      size: 30,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  controller: _emailController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        // ----------------phone number----------------------
                        validator: (v) {
                          final value = v.toString().trim();
                          if (value.length != 10) {
                            return 'your number must be 10 digits long.';
                          } else if (double.tryParse(value) == null) {
                            return 'please provide a valid phone number.';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'phone number',
                          icon: Icon(
                            Icons.phone_in_talk_rounded,
                            size: 30,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        controller: _phoneController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    Container(
                      // ----------------------------country code---------------
                      decoration: BoxDecoration(
                        border: Border.all(
                          // color: Theme.of(context).primaryColor,
                          color: const Color.fromARGB(137, 101, 145, 196),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      width: 100,
                      height: 50,
                      child: CountryCodePicker(
                        onChanged: (code) {
                          FocusScope.of(context).unfocus();
                          countryCode = code;
                        },
                        initialSelection: '+91',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  // ----------------elevated button----------------------
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      _checkValues();
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
