import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Models/Appointment.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/Pages/ManagePatientAppointment.dart';
import 'package:health_app/app_colors.dart';
import 'package:health_app/constant.dart';
import 'package:health_app/views/DoctorCard.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

class PatientAppointmentPage extends StatefulWidget {
  const PatientAppointmentPage({super.key});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PatientAppointmentPageState();
  }
}

class PatientAppointmentPageState extends State<PatientAppointmentPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool past = false;
  bool Completed = false;
  bool upcoming = true;
  late Stream<QuerySnapshot<Map<String, dynamic>>> appointmentStream;
  List<Appointment> unfilteredAppointments = [];
  List<Appointment> get filteredAppointments {
    return filterSelectedDoctors(unfilteredAppointments);
  }

  List<Appointment> filterSelectedDoctors(List<Appointment> appointments) {
    if (upcoming == true) {
      return appointments
          .where((element) =>
              element.status == AppointmentStatus.Upcoming ||
              element.status == AppointmentStatus.Pending)
          .toList();
    } else if (Completed == true) {
      return appointments
          .where((element) => element.status == AppointmentStatus.Completed)
          .toList();
    } else if (past == true) {
      return appointments
          .where((element) => element.status == AppointmentStatus.Cancelled)
          .toList();
    } else {
      return [];
    }
  }

  int get todayAppointments {
    final now = DateTime.now();
    return unfilteredAppointments
        .where((appointment) {
          return appointment.startTime.year == now.year &&
              appointment.startTime.month == now.month &&
              appointment.startTime.day == now.day;
        })
        .toList()
        .length;
  }

  // Getter method for the total number of appointments from unfilteredAppointments
  int get totalAppointments {
    return unfilteredAppointments.length;
  }

  // Getter method for the number of canceled appointments from unfilteredAppointments
  int get canceledAppointments {
    return unfilteredAppointments
        .where(
            (appointment) => appointment.status == AppointmentStatus.Cancelled)
        .length;
  }

  Widget buildAppointmentList(BuildContext context) {
    return Column(
      children: [
        Padding(
            padding: EdgeInsets.all(20),
            child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors
                      .grey.shade200, // Set the container's background color
                  borderRadius:
                      BorderRadius.circular(20.0), // Set the border radius
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                        onTap: () {
                          if (upcoming != true) {
                            setState(() {
                              upcoming = true;
                              past = false;
                              Completed = false;
                            });
                          }
                        },
                        child: FilterButton(
                            label: 'Upcoming', selected: upcoming)),
                    GestureDetector(
                        onTap: () {
                          if (past != true) {
                            setState(() {
                              upcoming = false;
                              past = true;
                              Completed = false;
                            });
                          }
                        },
                        child: FilterButton(
                          label: 'Past',
                          selected: past,
                        )),
                    GestureDetector(
                        onTap: () {
                          if (Completed != true) {
                            setState(() {
                              upcoming = false;
                              past = false;
                              Completed = true;
                            });
                          }
                        },
                        child: FilterButton(
                            label: 'Completed', selected: Completed)),
                  ],
                ))),
        Container(
            padding: EdgeInsets.symmetric(horizontal: d.pSW(15)),
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('users')
                  .doc(ScopedModel.of<MyScopedModel>(context)
                      .authenticatdUser!
                      .id)
                  .collection('appointments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text("No appointments"));
                }
                final appointments = snapshot.data!.docs;

                unfilteredAppointments = appointments.map((doc) {
                  return Appointment.fromMap(
                      doc.data() as Map<String, dynamic>);
                }).toList();
                List<AppointmentItem> appointmentsItems = [];

                for (var app in filteredAppointments) {
                  appointmentsItems.add(AppointmentItem(appointment: app));
                }
                //allAppointments = myAppointments;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: appointmentsItems.length,
                  itemBuilder: (context, index) {
                    return appointmentsItems[index];
                  },
                );
              },
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => ManagePatientAppointment(
                          appointment: null,
                        ))));
          }),
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: SingleChildScrollView(
                  child: Column(
                    children: [buildAppointmentList(context)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterItem extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;

  FilterItem({required this.label, required this.count, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: selected ? Colors.blue : Colors.black,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          label,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.black,
          ),
        ),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;

  FilterButton({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Container(
        width: d.pSW(100),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.green : Colors.black,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ));
  }
}

class AppointmentItem extends StatelessWidget {
  final Appointment appointment;
  AppointmentItem({required this.appointment});

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Card(
        color: Colors.white,
        elevation: 2,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoctorCard(
                  photoUrl: appointment.doctor.photoUrl,
                  doctorFirstName: appointment.doctor.firstName,
                  doctorLastName: appointment.doctor.lastName,
                  specialization: appointment.doctor.category),
              SizedBox(height: 8.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: d.pSW(5)),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      vertical: d.pSH(7), horizontal: d.pSW(20)),
                  decoration: BoxDecoration(
                    color: Colors.green.shade200,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_filled,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: d.pSW(4),
                          ),
                          appointment.status.name == "Pending"
                              ? SizedBox()
                              : Text(
                                  DateFormat('EEEE, MMM d yyyy')
                                      .format(appointment.startTime),
                                  style: TextStyle(fontSize: 14.0),
                                ),
                        ],
                      ),
                      Text(
                        appointment.status.name != "Pending"
                            ? appointment.status.name != "Upcoming"
                                ? appointment.status.name
                                : DateFormat('hh:mm a')
                                    .format(appointment.startTime)
                            : "Awaiting Doctor Approval",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: appointment.status == AppointmentStatus.Pending
                              ? Colors.orange.shade900
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
