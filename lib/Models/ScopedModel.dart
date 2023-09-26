// Example: Firebase authentication using Email and Password
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/Models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class MyScopedModel extends Model {
  UserProfile? authenticatdUser;
  List<UserProfile> doctors = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      return null;
    }
  }

  Future<UserProfile?> getUserProfile(String id) async {
    if (id != "") {
      final docRef = _firestore.collection('users').doc(id);
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        return UserProfile.fromMap(docSnapshot.data() as Map<String, dynamic>);
      }
    }
    return null; // User not found or no data in Firestore
  }

  Future<String> addUserProfile(UserProfile userProfile) async {
    try {
      if (userProfile.id != null) {
        final docRef = _firestore.collection('users').doc(userProfile.id);
        await docRef.set(userProfile.toMap());
      }
      authenticatdUser = userProfile;
      return "Success";
    } catch (ex) {
      return ex.toString();
    }
  }

  Future<List<UserProfile>> getDoctorProfiles() async {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'doctor')
            .get();

    final List<UserProfile> doctorProfiles = [];

    for (final DocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      final userProfile = UserProfile.fromMap(document.data()!);
      doctorProfiles.add(userProfile);
    }
    doctors = doctorProfiles;
    return doctorProfiles;
  }

  Future<UserProfile?> signIn(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      var res = await getUserProfile(result.user!.uid);
      authenticatdUser = res;
      return res;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  Future<bool> isEmailExists(String email) async {
    try {
      // Query the Firestore collection to check if the email exists
      final QuerySnapshot result = await _firestore
          .collection("doctors")
          .where("email", isEqualTo: email)
          .get();

      // If there are no documents matching the query, return false
      return result.docs.isNotEmpty;
    } catch (error) {
      print("Error checking email existence: $error");
      return false; // Return false in case of an error
    }
  }

  Future<bool> adminSignIn(String email, String password) async {
    try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // var res = await getUserProfile(result.user!.uid);
      //authenticatdUser = res;
      return true;
    } catch (e) {
      return false;
    }
  }
}
