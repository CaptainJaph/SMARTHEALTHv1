import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String id;
  final String photoUrl;
  final String firstName;
  final String lastName;
  final String email;
  final String phoneNumber;
  final String role;
  final DateTime dob;
  final String category; // Added category
  final String experience; // Added experience

  UserProfile({
    required this.id,
    required this.photoUrl,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    required this.dob,
    required this.category, // Added category
    required this.experience, // Added experience
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String,
      photoUrl: map['photoUrl'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      phoneNumber: map['phoneNumber'] as String,
      role: map['role'] as String,
      dob: (map['dob'] as Timestamp).toDate(),
      category: map['category'] as String, // Parse category
      experience: map['experience'] as String, // Parse experience
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoUrl': photoUrl,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'dob': dob,
      'category': category, // Store category as-is
      'experience': experience, // Store experience as-is
    };
  }
}
