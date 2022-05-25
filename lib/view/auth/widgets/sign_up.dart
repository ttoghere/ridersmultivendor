import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ridersmultivendor/controllers/global.dart';
import 'package:ridersmultivendor/view/shared/custom_text_field.dart';
import 'package:ridersmultivendor/view/shared/error_dialog.dart';
import 'package:ridersmultivendor/view/shared/loading_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailControl = TextEditingController();
  TextEditingController passwordControl = TextEditingController();
  TextEditingController cPasswordControl = TextEditingController();
  TextEditingController phoneControl = TextEditingController();
  TextEditingController nameControl = TextEditingController();
  TextEditingController locationControl = TextEditingController();
  String sellerImageUrl = "";
  String completeAddress = "";
  Future<void> _getImage() async {
    imageXFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    position = newPosition;
    placeMark = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );
    Placemark pMark = placeMark![0];
    completeAddress =
        "${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea} ${pMark.administrativeArea}, ${pMark.postalCode} ${pMark.country}";
    locationControl.text = completeAddress;
  }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
        context: context,
        builder: (context) => const ErrorDialog(
          message: "Please select an image",
        ),
      );
    } else {
      if (passwordControl.text == cPasswordControl.text) {
        if (cPasswordControl.text.isNotEmpty &&
            emailControl.text.isNotEmpty &&
            phoneControl.text.isNotEmpty &&
            locationControl.text.isNotEmpty &&
            nameControl.text.isNotEmpty) {
          //Upload img
          showDialog(
              context: context,
              builder: (context) => const LoadingDialog(
                    message: "Registering Account",
                  ));
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();
          fStorage.Reference reference = fStorage.FirebaseStorage.instance
              .ref()
              .child("riders")
              .child(fileName);
          fStorage.UploadTask uploadTask =
              reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot =
              await uploadTask.whenComplete(() {});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url;
            //Save to firestore
            authenticateridersignUp();
          });
        } else {
          showDialog(
            context: context,
            builder: (context) => const ErrorDialog(
              message: "Please fill the required fields...",
            ),
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => const ErrorDialog(
            message: "Passwords do not match",
          ),
        );
      }
    }
  }

  void authenticateridersignUp() async {
    User? currentUser;
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailControl.text.trim(),
      password: passwordControl.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => ErrorDialog(
          message: "An error occured: $error",
        ),
      );
    });
    if (currentUser != null) {
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.of(context).pop();
        //Send user to homepage
        // Route newRoute =
        //     MaterialPageRoute(builder: (context) => const HomeScreen());
        // Navigator.of(context).pushReplacement(newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("riders").doc(currentUser.uid).set({
      "riderUid": currentUser.uid,
      "riderEmail": currentUser.email,
      "riderName": nameControl.text.trim(),
      "riderAvatarUrl": sellerImageUrl,
      "phone": phoneControl.text.trim(),
      "address": completeAddress,
      "status": "approved",
      "earnings": 0.0,
      "lat": position!.latitude,
      "lng": position!.longitude,
    });
    //Save Data Locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email.toString());
    await sharedPreferences!.setString("name", nameControl.text.trim());
    await sharedPreferences!.setString("photoUrl", sellerImageUrl);
  }

  Position? position;
  List<Placemark>? placeMark;
  XFile? imageXFile;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage: imageXFile == null
                    ? null
                    : FileImage(
                        File(imageXFile!.path),
                      ),
                child: imageXFile == null
                    ? Icon(
                        Icons.add_a_photo_outlined,
                        size: MediaQuery.of(context).size.width * 0.2,
                        color: Colors.red[900],
                      )
                    : null,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    iconData: Icons.email,
                    textEditingController: emailControl,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    iconData: Icons.person,
                    textEditingController: nameControl,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    iconData: Icons.lock,
                    textEditingController: passwordControl,
                    hintText: "Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    iconData: Icons.lock,
                    textEditingController: cPasswordControl,
                    hintText: "Confirm Password",
                    isObsecure: true,
                  ),
                  CustomTextField(
                    iconData: Icons.phone,
                    textEditingController: phoneControl,
                    hintText: "Phone",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    iconData: Icons.gps_fixed,
                    textEditingController: locationControl,
                    hintText: "Location",
                    isObsecure: false,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.orange[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () {
                        getCurrentLocation();
                      },
                      label: const Text("Get My Location"),
                      icon: const Icon(Icons.gps_fixed),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                formValidation();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 10,
                ),
                primary: Colors.black,
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
