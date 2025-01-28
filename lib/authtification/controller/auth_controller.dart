import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/src/either.dart';

import 'package:uuid/uuid.dart';

import '../../../core/common/widgets/common_snack_bar.dart';
import '../../../core/constant/provider/common_provider.dart';
import '../../../model/user_model.dart';


import '../../home/screen.dart';
import '../repository/auth_repository.dart';
import '../repository/local_repository.dart';

final currentUser = StreamProvider.family(
  (ref, String userId) => ref
      .watch(authControllerProvider.notifier)
      .streamCurrentUser(userId: userId),
);
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authRepository: ref.read(authRepositoryProvider),

      ref: ref);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  final Ref _ref;

  AuthController(
      {required AuthRepository authRepository,

      required Ref ref})
      : _authRepository = authRepository,

        _ref = ref,
        super(false);

  // signInWithGoogle(BuildContext context) async {
  //   state = true;
  //
  //   // Get the result from the repository
  //   final user = await _authRepository.signInWithGoogle();
  //
  //   state = false;
  //
  //   // If there's an error, show a snack bar
  //   user.fold(
  //         (l) =>
  //         showSnackBar(
  //           message: l.message,
  //           context: context,
  //           icon: null,
  //           color: null,
  //         ),
  //
  //         (studentModel) async {
  //       // If the user is new (no id), navigate to RegistrationWeb
  //       if (studentModel["newUser"]==true) {
  //         _ref.read(userProvider.notifier).update((state) => studentModel["user"]);
  //
  //         // Navigate to the registration screen
  //         Navigator.pushNamed(context, 'registration_google');
  //       } else {
  //
  //         // If user details exist, set shared preferences and userProvider values
  //         await _ref.read(userProvider.notifier).update((state) => studentModel["user"]);
  //         UserModel? userModel=_ref.watch(userProvider);
  //         // Navigate to the main body screen
  //         var box = await Hive.openBox('userBox');
  //         box.put('currentUser', studentModel["user"]);
  //         if(userModel?.id==''||userModel?.course==''||userModel?.commonCourse==""){
  //           Navigator.pushNamedAndRemoveUntil(context, "onBody_screen", (route) => false,);
  //         }else{
  //           Navigator.pushNamedAndRemoveUntil(context, "sideBar_Page", (route) => false,);
  //         }
  //         // Navigate to the main body screen
  //
  //       }
  //     },
  //   );
  // }
  // createSignup( {required BuildContext context,
  //   required UserModel userModel,required Function clear}) async {
  //   state = true;
  //
  //   // Get the result from the repository
  //   final user = await _authRepository.signInWithGoogle();
  //
  //   state = false;
  //
  //   // If there's an error, show a snack bar
  //   user.fold(
  //         (l) =>
  //         showSnackBar(
  //           message: l.message,
  //           context: context,
  //           icon: null,
  //           color: null,
  //         ),
  //
  //         (studentModel) async {
  //       // If the user is new (no id), navigate to RegistrationWeb
  //
  //       _ref.read(userProvider.notifier).update((state) => studentModel["user"]);
  //
  //       // Navigate to the registration screen
  //       Navigator.pushNamed(context, 'RegistrationWeb');
  //
  //     },
  //   );
  // }
  // editUser(UserModel userModel, BuildContext context) async {
  //   try {
  //     await _authRepository.editUser(userModel);
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Profile Updated!'),
  //         backgroundColor: Colors.green,
  //       ),
  //     );
  //     Navigator.pop(context);
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to edit profile. Please try again.'),
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }

  Future<dynamic> sendOTP(
      {required String phoneNo, required String otp}) async {
    return await _authRepository.sendOTP(phoneNo: phoneNo, otp: otp);
  }

  Future<String> uploadImage(String userId, String filePath) async {
    try {
      // Get the file name from the file path
      final fileName = filePath.split('/').last;
      final FirebaseStorage _storage = FirebaseStorage.instance;
      // Create a reference to Firebase Storage with the path
      final ref = _storage.ref().child('user_images/$userId/$fileName');

      // Upload the image file
      await ref.putFile(File(filePath));

      // Get the download URL for the uploaded image
      final imageUrl = await ref.getDownloadURL();
      print('Image uploaded successfully: $imageUrl');
      return imageUrl;
    } catch (e) {
      print('Failed to upload image: $e');
      throw Exception('Failed to upload image: $e');
    }
  }

  // Example method to update user profile in Firestore (as previously defined)
  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> data) async {
    try {
      // Logic to update Firestore with user data
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(data);
      print('User profile updated successfully!');
    } catch (e) {
      print('Failed to update user profile: $e');
      throw Exception('Failed to update user profile: $e');
    }
  }

  addUser(
      {required BuildContext context,
      required UserModel userModel,
      required Function clear}) async {
    state = true; // Show loading state

    // Try to add the user and handle the result
    final result = await _authRepository.createUser(userModel: userModel);

    state = false; // Hide loading state

    // Handle success or failure using fold
    result.fold(
      (failure) {
        // If there's an error, show a snack bar with the error message
        showSnackBar(
          message: failure.message,
          context: context,
          icon: null,
          color: Colors.red,
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => DeleteAccountPage(),
          ),
          (route) => false,
        );
      },
      (user) async {
        // If the user was successfully added
        if (user != null) {
          if (user['newUser'] == true) {
            // Show success message
            _ref
                .read(userProvider.notifier)
                .update((state) => user["userData"]);

            final studentDetials = _ref.read(userProvider);






            showSnackBar(
              message: "Student  Register",
              context: context,
              icon: null,
              color: Colors.green,
            );
            // Optionally, update the user state in the app

            // Optionally, store user data in local storage (Hive/SharedPreferences)
            // var box = await Hive.openBox('userBox');
            // await box.put('currentUser', user["userData"]);
            // Navigate to the main screen after successful registration
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => DeleteAccountPage(),
                ),
                (route) => false);
            clear();
          } else {
            showSnackBar(
              message: "User Already registered !",
              context: context,
              icon: null,
              color: Colors.green,
            );
            // Optionally, update the user state in the app
            // _ref.read(userProvider.notifier).update((state) => userModel);
            // Optionally, store user data in local storage (Hive/SharedPreferences)
            // var box = await Hive.openBox('userBox');
            // await box.put('currentUser', userModel);
            // Navigate to the main screen after successful registration
            Navigator.pushNamedAndRemoveUntil(
                context, 'login_page', (route) => false);
          }
        } else {
          // Show error message if the user was not added
          showSnackBar(
            message: "User registration failed!",
            context: context,
            icon: null,
            color: Colors.red,
          );
        }
      },
    );
  }
  checkUserDataDemo(
      {required String phoneNumber,
        required BuildContext context,
      }) async {
    print(phoneNumber);
    final userData =
    await _authRepository.checkUserData(phoneNumber: phoneNumber);
    userData.fold(
            (l) => showSnackBar(
          message: l.message,
          context: context,
          icon: null,
          color: null,
        ), (studentModel) async {
      // If the user is new (no id), navigate to RegistrationWeb
      if (studentModel["userData"] != null) {
        _ref
            .read(userProvider.notifier)
            .update((state) => studentModel["userData"]);
        final studentDetails = _ref.read(userProvider);




        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DeleteAccountPage(),
          ),
          result: (route) => false,
        );
      } else {
        // Navigate to the registration screen
       showSnackBar(message: "User not exist", context: context, icon: null, color: Colors.red);
      }
    });
  }
  checkUserData(
      {required String phoneNumber,
      required BuildContext context,
     }) async {
    print(phoneNumber);
    print("99999999999999999999999999");
    final userData =
        await _authRepository.checkUserData(phoneNumber: phoneNumber);
    print("88888888888888888888888");
    userData.fold(
        (l) => showSnackBar(
              message: l.message,
              context: context,
              icon: null,
              color: null,
            ), (studentModel) async {
      // If the user is new (no id), navigate to RegistrationWeb
      if (studentModel["userData"] != null) {
        _ref
            .read(userProvider.notifier)
            .update((state) => studentModel["userData"]);


print(studentModel["userData"]);



        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DeleteAccountPage(),
          ),
          result: (route) => false,
        );
      } else {
        // Navigate to the registration screen

        showSnackBar(message: "User not exist", context: context, icon: null, color: Colors.red);
      }
    });
  }

  // loginUser(
  //     {required BuildContext context, required UserModel userModel,bool? google}) async {
  //   state = true;
  //
  //   // Get the result from the repository
  //   final user = google!=null?await _authRepository.signInWithEmailAndPassword(userModel: userModel,google: true):await _authRepository.signInWithEmailAndPassword(userModel: userModel);
  //
  //   state = false;
  //
  //   // If there's an error, show a snack bar
  //   user.fold(
  //           (l) =>
  //           showSnackBar(
  //             message: l.message,
  //             context: context,
  //             icon: null,
  //             color: null,
  //           ),
  //
  //           (studentModel) async {
  //         // If the user is new (no id), navigate to RegistrationWeb
  //         if (studentModel["user"]==null) {
  //
  //           // Navigate to the registration screen
  //           showSnackBar(
  //             message: "Unavailable to Login Please Register  ",
  //             context: context,
  //             icon: null,
  //             color: null,
  //           );
  //         } else {
  //           if (studentModel["newUser"] == true) {
  //             showSnackBar(
  //               message: "User registered successfully!",
  //               context: context,
  //               icon: null,
  //               color: Colors.green,
  //             );
  //             // Optionally, update the user state in the app
  //             _ref.read(userProvider.notifier).update((state) => studentModel["user"]);
  //             // Optionally, store user data in local storage (Hive/SharedPreferences)
  //             UserModel? userModel=await _ref.watch(userProvider);
  //             var box = await Hive.openBox('userBox');
  //
  //             await box.put('currentUser', userModel);
  //             // Navigate to the main screen after successful registration
  //             Navigator.pushNamedAndRemoveUntil(
  //                 context, 'onBody_screen', (route) => false);
  //           }
  //           if(studentModel["isVerified"]==false){
  //             showSnackBar(
  //               message: "Unavailable to  Register Please Verified Your Email  ",
  //               context: context,
  //               icon: null,
  //               color: null,
  //             );
  //           }
  //           else {
  //             // If user details exist, set shared preferences and userProvider values
  //             currentUserId = studentModel["user"].id;
  //
  //             _ref.read(userProvider.notifier).update((state) => studentModel["user"]);
  //             // Navigate to the main body screen
  //             var box = await Hive.openBox('userBox');
  //             box.put('currentUser', studentModel["user"]);
  //             studentModel["user"].department == '' ? Navigator
  //                 .pushNamedAndRemoveUntil(
  //                 context, 'onBody_screen', (route) => false) : Navigator
  //                 .pushNamedAndRemoveUntil(
  //                 context, 'sideBar_Page', (route) => false);
  //
  //           }
  //         }
  //       });
  // }
  Stream<UserModel> streamCurrentUser({required String userId}) {
    return _authRepository.getUserDetail(userId: userId);
  }

  logout({required BuildContext context}) async {
    Navigator.pushNamedAndRemoveUntil(
      context,
      "login_page",
      (route) => false,
    );
    Future.delayed(Duration(seconds: 5)).then(
      (value) async {
        _ref.read(userProvider.notifier).state = null;
        // var box = await Hive.openBox('userBox');
        // await box.delete('currentUser');
      },
    );
  }
  // getCurrentUser(String userId) async {
  //   final user=await _authRepository.getCurrentUser(userId);
  //   _ref.read(userProvider.notifier).state = user;
  //   var box = await Hive.openBox('userBox');
  //   await  box.get('currentUser') as UserModel?;
  //
  // }
  // emailVerification({required BuildContext context}) async {
  //   bool isVerification=await _authRepository.emailVerification();
  //   _ref.read(isVerified.notifier).state=isVerification;
  //   if(isVerification==true){
  //     UserModel? userModel=_ref.watch(userProvider);
  //     _ref.read(authControllerProvider.notifier).loginUser(context: context, userModel: userModel!);
  //   }else{
  //     showSnackBar(
  //       message: "Please Verified You Email ",
  //       context: context,
  //       icon: null,
  //       color: null,
  //     );
  //   }
  // }

  // Future<void> launchUrlWhatsappSupport() async {
  //   final Uri _url = Uri.parse('https://wa.me/+918137851545');
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }
  editProfile(
      String courseId, UserModel userModel, BuildContext context) async {
    try {
      await _authRepository.editProfile(courseId, userModel);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('profile updated'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      // Show error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to edit profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
