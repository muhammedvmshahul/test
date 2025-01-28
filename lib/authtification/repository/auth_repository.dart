import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:msg91/msg91.dart';

import '../../core/common/widgets/failure.dart';
import '../../core/constant/firebase_constant.dart';
import '../../core/constant/provider/firebase_constants.dart';
import '../../core/type_def.dart';
import '../../model/user_model.dart';



final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      firestore: ref.read(firestoreProvider),
      googleSignIn: ref.read(googleSignInProvider),
      auth: ref.read(firebaseAuthProvider),
      storage: ref.read(firebaseStorage)),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  AuthRepository({
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
    required FirebaseAuth auth,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _googleSignIn = googleSignIn,
        _auth = auth,
        _storage = storage;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection(FirebaseConstants.user);

  CollectionReference<Map<String, dynamic>> get _students =>
      _firestore.collection(FirebaseConstants.students);

  FutureEither<Map<String, dynamic>> signInWithGoogle() async {
    UserModel? studentModel;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User user = userCredential.user!;

      if (userCredential.additionalUserInfo!.isNewUser) {
        studentModel = UserModel(
          email: user.email!,
          name: user.displayName!,
          image: user.photoURL!,
          id: user.uid,
          collegeName: '',
          department: '',
          commonCourse: '',
          phone: '',
          search: [],
          favourite: [],
          delete: false,
          password: '',
          course: '',
          semester: '',
        );

        _users.doc(user.uid).set(studentModel.toMap());
        return right({"newUser": true, "user": studentModel});
      } else {
        final checkStudent = await FirebaseFirestore.instance
            .collection(FirebaseConstants.user)
            .where("email", isEqualTo: user.email)
            .get();

        if (checkStudent.docs.isNotEmpty) {
          studentModel = UserModel.fromMap(checkStudent.docs.first.data());

          return right({"newUser": false, "user": studentModel});
        } else {
          studentModel = UserModel(
            email: user.email!,
            name: user.displayName!,
            image: user.photoURL!,
            id: user.uid,
            collegeName: '',
            department: '',
            commonCourse: '',
            phone: '',
            search: [],
            favourite: [],
            delete: false,
            password: '',
            course: '',
            semester: '',
          );
          return right({"newUser": true, "user": studentModel});
        }
      }
    } on FirebaseException catch (ex) {
      throw ex.message!;
    } catch (e, s) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<UserModel> createAccountWithEmailAndPassword(
      {required UserModel studentModel}) async {
    try {
      // Create user with email and password in FirebaseAuth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: studentModel!.email,
        password: studentModel.password,
      );

      User user = userCredential.user!;
      // Check if this is a new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        // Create a new user model
        studentModel = UserModel(
          email: user.email!,
          name: "",
          image: "",
          // Optional: add default image or leave empty
          id: user.uid,
          collegeName: '',
          department: '',
          commonCourse: '',
          phone: '',
          search: [],
          favourite: [],
          delete: false,
          password: studentModel.password,
          course: '',
          semester: '',
        );

        // Save the user to Firestore
        await _users.doc(user.uid).set(studentModel.toMap());
      }

      return right(studentModel!);
    } on FirebaseAuthException catch (ex) {
      // Handle FirebaseAuth-specific exceptions

      return left(Failure(message: ex.message ?? "An error occurred"));
    } catch (e) {
      // Handle other errors

      return left(Failure(message: e.toString()));
    }
  }

  /// signup in Email
  FutureEither createUser({
    required UserModel userModel,
  }) async {
    try {
      var data =
          await _students.where('phone', isEqualTo: userModel.phone).get();

      if (data.docs.isNotEmpty) {
        log('User already exists');
        return right({
          'newUser': false,
          'userData': userModel.copyWith(id: data.docs.first.reference.id)
        });
      } else {
        log("Creating new user...");

        // Create user

        // Send email verification
        // await userCredential.user!.sendEmailVerification();

        // Copy data to studentModel

        log("New user created with ID: ${userModel.id} hiiiii");
        final newStudentDoc = _students.doc();
        await newStudentDoc
            .set(userModel.copyWith(id: newStudentDoc.id).toMap());
        log("login ayitttooo");
        return right({
          'newUser': true,
          'userData': userModel.copyWith(id: newStudentDoc.id),
        });
      }
    } on FirebaseAuthException catch (e) {
      log("FirebaseAuthException: ${e.code}");
      return left(Failure(message: e.message ?? 'Unknown error'));
    } catch (e) {
      log("Exception: $e");
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<Map<String, dynamic>> checkUserData(
      {required String phoneNumber}) async {
    var data = await _students.where('phone', isEqualTo: phoneNumber).get();
    UserModel? user;
    if (data.docs.isNotEmpty) {
      print("vbnm,.");
      user = await UserModel.fromMap(data.docs.first.data());
      log('User already exists');
      print(user);
      return right({'newUser': false, 'userData': user});
    } else {
      print("elaaaaaaaaaaaaa");
      return right({'newUser': false, 'userData': user});
    }
  }

  Future<dynamic> sendOTP(
      {required String phoneNo, required String otp}) async {
    final msg91 = Msg91().initialize(authKey: "437602ARHn5Lp5p1j6781f2daP1");
    final sms = msg91.getSMS();
    final response = sms.send(
      // flowId: "1407173521400451105",
      flowId: "6770579ed6fc051072771342",

      recipient: SmsRecipient(
        mobile: phoneNo,
        key: {"OTP": otp},
      ),
      options: SmsOptions(
        senderId: "LITLAB",
        shortURL: false,
      ),
    );
    return response;
  }

  Future<bool> validateEmail(String email) async {
    final apiUrl =
        'https://api-bdc.net/data/email-verify?emailAddress=$email&key=bdc_91d738db03554259b9ced604bbf43d90';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return jsonResponse[
          'isValid']; // Assuming the API returns a 'valid' field
    } else {
      throw Exception('Failed to validate email');
    }
  }

  /// sign in with password
  Future<Either<Failure, Map<String, dynamic>>> signInWithEmailAndPassword({
    required UserModel userModel,
    bool? google,
  }) async {
    try {
      if (google != null) {
        await _users.doc(userModel.id).update(userModel!.toMap());
        return right({"newUser": true, "user": userModel, "isVerified": true});
      } else {
        /// Sign in with email and password
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
            email: userModel.email, password: userModel.password);
        final userId = userCredential.user?.uid;

        if (userId == null) {
          return left(Failure(message: 'Invalid Email or Password'));
        } else {
          if (userCredential.user!.emailVerified) {
            DocumentSnapshot snapshot = await _users.doc(userId).get();
            if (snapshot.exists) {
              userModel =
                  UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
              return right(
                  {"newUser": false, "user": userModel, "isVerified": true});
            } else {
              UserModel user = userModel.copyWith(id: userId);
              await _users.doc(userId).set(user!.toMap());
              print("hiiiiiiiiiilogin");
              return right(
                  {"newUser": true, "user": userModel, "isVerified": true});
            }
          } else {
            return right({
              "isVerified": false,
              "user": userModel,
              "newUser": true,
            });
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return left(Failure(message: "Invalid login credentials"));
      } else {
        return left(Failure(message: e.message ?? 'Unknown error occurred.'));
      }
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  FutureEither<UserModel> addUsers({required UserModel userModel}) async {
    try {
      if (_auth.currentUser!.emailVerified) {
        await _users.doc(userModel.email).set(userModel.toMap());
      }
    } on FirebaseException catch (ex) {
      throw ex.message!;
    } catch (e, s) {
      return left(Failure(message: e.toString()));
    }

    return right(userModel);
  }

  FutureEither<UserModel?> loginUsers(
      {required String email, required String password}) async {
    UserModel? userModel;
    try {
      var userStream = _users
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .snapshots();
      QuerySnapshot checkStudent = await userStream.first;

      if (checkStudent.docs.isNotEmpty) {
        userModel = UserModel.fromMap(
            checkStudent.docs.first.data() as Map<String, dynamic>);
      } else {}
      return right(userModel);
    } on FirebaseException catch (ex) {
      throw ex.message!;
    } catch (e, s) {
      return left(Failure(message: e.toString()));
    }
  }
deleteUser(String id){
    _students.doc(id).delete();
}
  Stream<UserModel> getUserDetail({required String userId}) {
    return _users.doc(userId).snapshots().map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  Future<UserModel> getCurrentUser(String userId) {
    return _users.doc(userId).get().then(
          (value) => UserModel.fromMap(value.data() as Map<String, dynamic>),
        );
  }

  Future<bool> emailVerification() async {
    _auth.currentUser!.sendEmailVerification();
    await _auth.currentUser!.reload();
    bool isVerification = _auth.currentUser!.emailVerified;
    // Refresh the user objec
    return isVerification;
  }

  editProfile(String courseId, UserModel userModel) async {
    _firestore
        .doc(courseId)
        .collection('students')
        .doc(userModel.id)
        .update(userModel.toMap());
  }
}
