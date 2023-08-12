import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUsers({
    required String email,
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty &&
          fullName.isNotEmpty &&
          phoneNumber.isNotEmpty &&
          password.isNotEmpty) {
        // Create the user
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        await _firestore.collection('buyers').doc(credential.user!.uid).set({
          'email': email,
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'buyerId': credential.user!.uid,
          'address': [],
        });

        res = 'Success';
      } else {
        res = 'Please field must not be empty';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> signInUsers({
    required String email,
    required String password,
  }) async {
    String res = 'Something went wrong!';

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        // Create the user
        UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        res = 'Success';
      } else {
        res = 'Please field must not be empty';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        res = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        res = 'Invalid Password.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

    pickProfileImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();

    XFile? _file = await _imagePicker.pickImage(source: source);

    if(_file != null){
      return await _file.readAsBytes();
    }else{
      print("No Image Selected");
    }
  }
}
