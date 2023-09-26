import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String photoUrl;
  final String doctorFirstName;
  final String doctorLastName;
  final String specialization;

  DoctorCard({
    required this.photoUrl,
    required this.doctorFirstName,
    required this.doctorLastName,
    required this.specialization,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        //padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          children: [
            // Display the photoUrl in a circle or first letter of first name
            _buildDoctorPhoto(),
            SizedBox(width: 12.0),
            // Display doctor name and specialization
            _buildDoctorInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorPhoto() {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey, // Default background color if no photoUrl
        image: photoUrl.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(photoUrl),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Center(
        child: photoUrl.isNotEmpty
            ? null
            : Text(
                doctorFirstName.isNotEmpty
                    ? doctorFirstName[0].toUpperCase()
                    : '?',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$doctorFirstName $doctorLastName, MD',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          specialization,
          style: TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
