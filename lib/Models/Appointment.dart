import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Models/User.dart';

enum AppointmentStatus {
  Completed,
  Upcoming,
  Cancelled,
  Pending,
}

enum AppointmentType {
  inPerson,
  online,
  labTest,
}

class Appointment {
  static const String firestoreCompleted = 'Completed';
  static const String firestoreUpcoming = 'Upcoming';
  static const String firestoreCancelled = 'Cancelled';
  static const String firestorePending = 'Pending';
  static const String firestoreInPerson = 'In Person';
  static const String firestoreOnline = 'Online';
  static const String firestoreLabTest = 'Lab Test';

  final String id;
  final UserProfile doctor; // Use UserProfile for doctor information
  final UserProfile patient; // Added patient property
  final DateTime startTime;
  final DateTime endTime;
  final AppointmentStatus status;
  final String initialComplaint;
  final AppointmentType appointmentType;
  final String procedureName; // Added
  final String hospital; // Added

  Appointment({
    required this.id,
    required this.doctor, // Use UserProfile for doctor
    required this.patient, // Added patient property
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.initialComplaint,
    required this.appointmentType,
    required this.procedureName, // Added
    required this.hospital, // Added
  });

  Duration get duration => endTime.difference(startTime);

  bool overlapsWith(Appointment other) {
    return startTime.isBefore(other.endTime) &&
        endTime.isAfter(other.startTime);
  }

  bool get isCompleted => status == AppointmentStatus.Completed;
  bool get isUpcoming => status == AppointmentStatus.Upcoming;
  bool get isCancelled => status == AppointmentStatus.Cancelled;
  bool get isPending => status == AppointmentStatus.Pending;
  bool get isOnline => appointmentType == AppointmentType.online;
  bool get isInPerson => appointmentType == AppointmentType.inPerson;
  bool get isLabTest => appointmentType == AppointmentType.labTest;

  static String mapStatusToFirestore(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.Completed:
        return firestoreCompleted;
      case AppointmentStatus.Upcoming:
        return firestoreUpcoming;
      case AppointmentStatus.Cancelled:
        return firestoreCancelled;
      case AppointmentStatus.Pending:
        return firestorePending;
    }
  }

  static String mapAppointmentToFirestore(AppointmentType status) {
    switch (status) {
      case AppointmentType.inPerson:
        return firestoreInPerson;
      case AppointmentType.online:
        return firestoreOnline;
      case AppointmentType.labTest:
        return firestoreLabTest;
    }
  }

  static AppointmentStatus mapFirestoreToStatus(String firestoreValue) {
    switch (firestoreValue) {
      case firestoreCompleted:
        return AppointmentStatus.Completed;
      case firestoreUpcoming:
        return AppointmentStatus.Upcoming;
      case firestoreCancelled:
        return AppointmentStatus.Cancelled;
      case firestorePending:
        return AppointmentStatus.Pending;
      default:
        throw Exception('Unsupported Firestore status: $firestoreValue');
    }
  }

  static AppointmentType mapFirestoreToAppointment(String firestoreValue) {
    switch (firestoreValue) {
      case firestoreOnline:
        return AppointmentType.online;
      case firestoreLabTest:
        return AppointmentType.labTest;
      case firestoreInPerson:
        return AppointmentType.inPerson;

      default:
        throw Exception('Unsupported Firestore status: $firestoreValue');
    }
  }

  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'] as String,
      doctor: UserProfile.fromMap(map['doctor'] as Map<String, dynamic>),
      patient:
          UserProfile.fromMap(map['patient'] as Map<String, dynamic>), // Added
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      status: mapFirestoreToStatus(map['status'] as String), // Correct mapping
      initialComplaint: map['initialComplaint'] as String,
      appointmentType:
          mapFirestoreToAppointment(map['appointmentType']) as AppointmentType,
      procedureName: map['procedureName'] as String,
      hospital: map['hospital'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctor': doctor.toMap(), // Convert UserProfile to map
      'patient': patient.toMap(), // Convert UserProfile to map
      'startTime': startTime,
      'endTime': endTime,
      'status': mapStatusToFirestore(status),
      'initialComplaint': initialComplaint,
      'appointmentType': mapAppointmentToFirestore(appointmentType),
      'procedureName': procedureName,
      'hospital': hospital,
    };
  }
}
