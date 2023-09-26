import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import 'package:health_app/Models/Appointment.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/Models/User.dart';
import 'package:health_app/app_colors.dart';
import 'package:health_app/views/DoctorCard.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class ManagePatientAppointment extends StatefulWidget {
  final Appointment? appointment;
  final UserProfile? initialDoctor;

  ManagePatientAppointment({this.appointment, this.initialDoctor});

  @override
  _ManagePatientAppointmentState createState() =>
      _ManagePatientAppointmentState();
}

class _ManagePatientAppointmentState extends State<ManagePatientAppointment> {
  UserProfile? preferredDoctor;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late DateTime _updatedArrivalTime;
  late DateTime _updatedArrivalDate;
  TextEditingController _initialComplaintController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> appointmentType = ["In Person", "Online"];
  AppointmentType? appointment;
  String? meetingType;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    if (widget.appointment != null) {
      preferredDoctor = widget.appointment!.doctor;
      selectedDate = widget.appointment!.startTime;
      selectedTime = TimeOfDay(
        hour: widget.appointment!.startTime.hour,
        minute: widget.appointment!.startTime.minute,
      );
      _updatedArrivalDate = widget.appointment!.startTime;
      _updatedArrivalTime = widget.appointment!.startTime;
      _initialComplaintController.text = widget.appointment!.initialComplaint;
    } else {
      if (widget.initialDoctor != null) {
        preferredDoctor = widget.initialDoctor;
      }
      _updatedArrivalTime = DateTime.now();
      _updatedArrivalDate = DateTime.now();
      selectedDate = DateTime.now();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isCreatingAppointment = widget.appointment == null;

    return Scaffold(
        appBar: AppBar(
          title: Text(isCreatingAppointment
              ? 'Create New Appointment'
              : 'Appointment Details'),
        ),
        body: SingleChildScrollView(
            child: Container(
          //  height: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3.0,
                  child: ListTile(
                    onTap: () {
                      _showDoctorSelectionDialog();
                    },
                    title: Text('Preferred Doctor'),
                    subtitle: preferredDoctor != null
                        ? DoctorCard(
                            photoUrl: preferredDoctor!.photoUrl,
                            doctorFirstName: preferredDoctor!.firstName,
                            doctorLastName: preferredDoctor!.lastName,
                            specialization: preferredDoctor!.category)
                        : Text('Select Doctor'),
                    trailing: Icon(
                      Icons.arrow_forward_ios_outlined,
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                DropdownButtonFormField2<String>(
                  isExpanded: true,
                  decoration: InputDecoration(
                      // Add Horizontal padding using menuItemStyleData.padding so it matches
                      // the menu padding when button's width is not specified.
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: InputBorder.none
                      // Add more decoration..
                      ),
                  hint: const Text(
                    'Select Meeting Type',
                    style: TextStyle(fontSize: 14),
                  ),
                  items: appointmentType
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select type of meeting';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      meetingType = value;
                      if (meetingType == "In Person") {
                        appointment = AppointmentType.inPerson;
                      } else if (meetingType == "Online") {
                        appointment = AppointmentType.online;
                      }
                    });
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 50,
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: EdgeInsets.only(right: 8),
                  ),
                  iconStyleData: const IconStyleData(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black45,
                    ),
                    iconSize: 24,
                  ),
                  dropdownStyleData: DropdownStyleData(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                SizedBox(height: 16.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appointment Time',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        DateFormat('EEEE, MMM d yyyy - hh:mm a')
                            .format(selectedDate!),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                /*  ListTile(
                  tileColor: AppColors.greenColorTwo,
                  onTap: () async {
                    DateTime currentTime = _updatedArrivalDate;
                    DateTime now = DateTime.now();
                    DateTime threeMonthsFromNow = now.add(
                        Duration(days: 90)); // Adding 90 days for three months

                    DateTime? newDate = await showDatePicker(
                        context: context,
                        initialDate: currentTime,
                        firstDate: DateTime.now(),
                        lastDate: threeMonthsFromNow);

                    if (newDate != null) {
                      if (selectedTime == null) {
                        selectedTime = TimeOfDay.now();
                      }
                      setState(() {
                        _updatedArrivalTime = DateTime(
                          newDate.year,
                          newDate.month,
                          newDate.day,
                          selectedTime!.hour,
                          selectedTime!.minute,
                        );
                        selectedDate = _updatedArrivalTime;
                      });
                    }
                  },
                  title: Text('Choose appointment day'),
                  trailing: Icon(Icons.calendar_today),
                ),*/
                ListTile(
                  tileColor: Colors.lightBlue,
                  onTap: () async {
                    /*
                    TimeOfDay currentTime =
                        TimeOfDay.fromDateTime(_updatedArrivalTime);
                    TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: currentTime,
                    );

                    if (newTime != null) {
                      setState(() {
                        _updatedArrivalTime = DateTime(
                          _updatedArrivalDate.year,
                          _updatedArrivalDate.month,
                          _updatedArrivalDate.day,
                          newTime.hour,
                          newTime.minute,
                        );
                        selectedDate = _updatedArrivalTime;
                        selectedTime = newTime;
                      });
                    }*/
                    editAppointmentStartTime(context).then((value) {
                      if (value != null) {
                        setState(() {
                          selectedDate = value;
                        });
                      }
                    });
                  },
                  title: Text('Choose appointment time'),
                  trailing: Icon(Icons.access_time_filled_rounded),
                ),
                SizedBox(height: 16.0),
                SizedBox(
                  height: 6,
                ),
                TextFormField(
                  maxLines: 2,
                  controller: _initialComplaintController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.note_add),
                    labelText: 'Initial Complaint',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Initial Complaint';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                Container(
                  color: Colors.lightGreen[50],
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.green),
                      SizedBox(width: 8.0),
                      Text('All details must be filled.'),
                    ],
                  ),
                ),
                //Expanded(child: SizedBox()),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          String randomId = generateRandomString(10);
                          Appointment newAppointment = Appointment(
                              patient: ScopedModel.of<MyScopedModel>(context)
                                  .authenticatdUser!,
                              id: randomId,
                              doctor: preferredDoctor!,
                              startTime: selectedDate!,
                              endTime: selectedDate!.add(Duration(minutes: 15)),
                              status: AppointmentStatus.Pending,
                              initialComplaint:
                                  _initialComplaintController.text,
                              appointmentType: appointment!,
                              procedureName: "",
                              hospital: "");
                          final senderId =
                              ScopedModel.of<MyScopedModel>(context)
                                  .authenticatdUser!
                                  .id;
                          final receiverId = preferredDoctor!.id;
                          final appointmentId =
                              randomId; // Replace with your desired ID

// Reference the sender's message subcollection
                          CollectionReference senderAppointmentsCollection =
                              _firestore
                                  .collection('users')
                                  .doc(senderId)
                                  .collection('appointments');

// Reference the receiver's message subcollection
                          CollectionReference receiverAppointmentsCollection =
                              _firestore
                                  .collection('users')
                                  .doc(receiverId)
                                  .collection('appointments');

// Create or update the sender's document if it doesn't exist
                          await _firestore
                              .collection('users')
                              .doc(senderId)
                              .set(
                            {
                              // Add user data as needed
                            },
                            SetOptions(
                              merge: true,
                            ),
                          );

// Create or update the receiver's document if it doesn't exist
                          await _firestore
                              .collection('users')
                              .doc(receiverId)
                              .set(
                            {
                              // Add user data as needed
                            },
                            SetOptions(
                              merge: true,
                            ),
                          );

// Add the message to the sender's subcollection with the specified ID
                          await senderAppointmentsCollection
                              .doc(appointmentId)
                              .set(
                                newAppointment.toMap(),
                                SetOptions(
                                  merge: true,
                                ),
                              );

// Add the message to the receiver's subcollection with the same specified ID
                          await receiverAppointmentsCollection
                              .doc(appointmentId)
                              .set(
                                newAppointment.toMap(),
                                SetOptions(
                                  merge: true,
                                ),
                              );
                        },
                        child: Text("Book Appointment")))
              ],
            ),
          ),
        )));
  }

  void _showDoctorSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a Doctor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: ScopedModel.of<MyScopedModel>(context)
                  .doctors
                  .map(
                    (doctor) => InkWell(
                      onTap: () {
                        setState(() {
                          preferredDoctor = doctor;
                        });
                        Navigator.of(context).pop();
                      },
                      child: ListTile(
                        title: Text(
                            doctor.firstName + " " + doctor.lastName + ", MD"),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }

  Future<DateTime?> editAppointmentStartTime(BuildContext context) async {
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      initialDate: selectedDate == null ? DateTime.now() : selectedDate!,
      firstDate: selectedDate == null ? DateTime.now() : selectedDate!,
      //firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDateTime != null) {
      TimeOfDay? selectedTime = await showTimePicker(
          context: context,
          initialTime: selectedDate == null
              ? TimeOfDay.fromDateTime(DateTime.now())
              : TimeOfDay.fromDateTime(selectedDate!)
          // TimeOfDay.fromDateTime(DateTime.now()),
          );

      if (selectedTime != null) {
        // Update the appointment's start time with the selected date and time
        return DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Update the UI or save the changes to a database as needed
      }
    }
    return null;
  }
}

String generateRandomString(int length) {
  final Random _random = Random();
  const String _chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_random.nextInt(_chars.length))));
}
