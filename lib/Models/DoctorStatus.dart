class DoctorStatus {
  final Map<String, Map<String, String>>
      availability; // Map of day to start and end times
  final bool tempInactive;

  DoctorStatus({
    required this.availability,
    required this.tempInactive,
  });

  // Factory constructor to convert from a Map to a DoctorStatus object
  factory DoctorStatus.fromMap(Map<String, dynamic> map) {
    Map<String, Map<String, String>> availabilityMap = {};
    if (map['availability'] != null) {
      final availabilityData = map['availability'];
      availabilityData.forEach((day, times) {
        availabilityMap[day] = {
          'startTime': times['startTime'] as String,
          'endTime': times['endTime'] as String,
        };
      });
    }

    return DoctorStatus(
      availability: availabilityMap,
      tempInactive: map['tempInactive'] as bool,
    );
  }

  // Method to convert the DoctorStatus object to a Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> availabilityData = {};
    availability.forEach((day, times) {
      availabilityData[day] = {
        'startTime': times['startTime'],
        'endTime': times['endTime'],
      };
    });

    return {
      'availability': availabilityData,
      'tempInactive': tempInactive,
    };
  }
}
