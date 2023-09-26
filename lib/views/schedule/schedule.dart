import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_app/Models/Appointment.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/Pages/PatientAppointmentPage.dart';
import 'package:health_app/components/calendar.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../app_colors.dart';
import '../../constant.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime currentDate = DateTime.now();

  bool openCalendar = false;
  String? selectedCategory;
  late TextEditingController searchController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _categorySelected = "Neurologist";
  List<String> appointmentsId = [];
  List<Appointment> unfilteredAppointments = [];
  List<Appointment> get filteredAppointments {
    return filterSelectedDoctors(unfilteredAppointments);
  }

  List<Appointment> filterSelectedDoctors(List<Appointment> appointments) {
    if (selectedCategory == "Upcoming") {
      return appointments
          .where((element) => element.status == AppointmentStatus.Upcoming)
          .toList();
    } else if (selectedCategory == "Pending") {
      return appointments
          .where((element) => element.status == AppointmentStatus.Pending)
          .toList();
    } else {
      return [];
    }
  }

  @override
  void initState() {
    _categorySelected = "Upcoming";
    selectedCategory = "Upcoming";
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Schedule",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                height: d.pSH(1),
                color: AppColors.blackColorOne,
                fontSize: d.pSH(24)),
          ),
        ),
        body: SafeArea(
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: d.pSH(10)),
                            // height: d.pSH(70),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Card(
                                      color: AppColors.whiteColorOne,
                                      margin: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(d.pSH(5))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: d.pSH(10),
                                            vertical: d.pSH(3)),
                                        child: TextFormField(
                                          controller: searchController,
                                          decoration: InputDecoration(
                                              prefixIcon:
                                                  const Icon(Icons.search),
                                              hintText: "Search",
                                              suffixIcon: PopupMenuButton(
                                                surfaceTintColor:
                                                    AppColors.whiteColorOne,
                                                icon: Icon(
                                                  Icons.sort_rounded,
                                                  color:
                                                      AppColors.blackColorOne,
                                                  size: d.pSH(24),
                                                ),
                                                // color: AppColors.whiteColorOne,
                                                onSelected: (value) {
                                                  Navigator.of(context).pop();
                                                },
                                                color: AppColors.whiteColorOne,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            d.pSH(10))),
                                                itemBuilder: (context1) => [
                                                  PopupMenuItem(
                                                      child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: d.pSH(10)),
                                                    child: Card(
                                                      margin: EdgeInsets.zero,
                                                      elevation:
                                                          selectedCategory ==
                                                                  "Upcoming"
                                                              ? 3
                                                              : 0,
                                                      color: AppColors
                                                          .whiteColorOne,
                                                      child: ListTile(
                                                        onTap: () {
                                                          if (selectedCategory !=
                                                              "Upcoming")
                                                            setState(() {
                                                              selectedCategory =
                                                                  "Upcoming";
                                                            });
                                                          Navigator.pop(
                                                              context1);
                                                        },
                                                        // tileColor: AppColors.whiteColorOne,
                                                        leading: const RotatedBox(
                                                            quarterTurns: 1,
                                                            child: Icon(Icons
                                                                .arrow_circle_left_rounded)),
                                                        title: Text(
                                                          "Upcoming",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            height: d.pSH(1),
                                                            color: AppColors
                                                                .blackColorOne,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                                  PopupMenuItem(
                                                      child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: d.pSH(10)),
                                                    child: Card(
                                                      margin: EdgeInsets.zero,
                                                      elevation:
                                                          selectedCategory ==
                                                                  "Pending"
                                                              ? 3
                                                              : 0,
                                                      color: AppColors
                                                          .whiteColorOne,
                                                      child: ListTile(
                                                        onTap: () {
                                                          if (selectedCategory !=
                                                              "Pending")
                                                            setState(() {
                                                              selectedCategory =
                                                                  "Pending";
                                                            });

                                                          Navigator.pop(
                                                              context1);
                                                        },
                                                        // tileColor: AppColors.whiteColorOne,
                                                        leading: const RotatedBox(
                                                            quarterTurns: 0,
                                                            child: Icon(Icons
                                                                .pause_circle)),
                                                        title: Text(
                                                          "Pending",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            height: d.pSH(1),
                                                            color: AppColors
                                                                .blackColorOne,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )),
                                                  /*     PopupMenuItem(
                                                          child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: d.pSH(10)),
                                                        child: Card(
                                                          margin:
                                                              EdgeInsets.zero,
                                                          elevation: 0,
                                                          color: AppColors
                                                              .whiteColorOne,
                                                          child: ListTile(
                                                            // tileColor: AppColors.whiteColorOne,
                                                            leading: const RotatedBox(
                                                                quarterTurns: 0,
                                                                child: Icon(Icons
                                                                    .arrow_circle_left_rounded)),
                                                            title: Text(
                                                              "Previous",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height:
                                                                    d.pSH(1),
                                                                color: AppColors
                                                                    .blackColorOne,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                      PopupMenuItem(
                                                          child: Container(
                                                        margin: EdgeInsets.only(
                                                            bottom: d.pSH(10)),
                                                        child: Card(
                                                          margin:
                                                              EdgeInsets.zero,
                                                          elevation: 0,
                                                          color: AppColors
                                                              .whiteColorOne,
                                                          child: ListTile(
                                                            // tileColor: AppColors.whiteColorOne,

                                                            leading: Icon(
                                                              Icons.cancel,
                                                              color: AppColors
                                                                  .blackColorOne
                                                                  .withOpacity(
                                                                      0.8),
                                                            ),
                                                            title: Text(
                                                              "Cancel",
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                height:
                                                                    d.pSH(1),
                                                                color: AppColors
                                                                    .blackColorOne
                                                                    .withOpacity(
                                                                        0.9),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),*/
                                                ],
                                              ),
                                              border: InputBorder.none),
                                        ),
                                      )),
                                  SizedBox(
                                    height: d.pSH(15),
                                  ),
                                  Card(
                                    margin: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(d.pSH(5))),
                                    child: Container(
                                      padding: EdgeInsets.all(d.pSH(5)),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(d.pSH(5)),
                                          color: AppColors.blackColorTwo),
                                      child: Text(
                                        selectedCategory!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            height: d.pSH(1),
                                            color: AppColors.blackColorOne,
                                            fontSize: d.pSH(14)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: d.pSH(10),
                                  ),
                                  if (openCalendar)
                                    Container(
                                      height: d.pSH(1),
                                      color: Colors.black,
                                    )
                                ]),
                          ),
                          buildAppointmentList(context)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildAppointmentList(BuildContext context) {
    return Column(
      children: [
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
                List<DoctorAppointmentItem> appointmentsItems = [];

                for (var app in filteredAppointments) {
                  appointmentsItems
                      .add(DoctorAppointmentItem(appointment: app));
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

  Widget buildScheduledAppointmentCard({required DateTime appointmentDate}) {
    return Card(
      elevation: 2.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(d.pSH(10))),
      margin: EdgeInsets.symmetric(horizontal: d.pSH(10), vertical: d.pSH(2)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: d.pSH(15)),
        height: d.pSH(100),
        decoration: BoxDecoration(
            color: AppColors.whiteColorTwo,
            borderRadius: BorderRadius.circular(d.pSH(10))),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('E').format(appointmentDate).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      height: d.pSH(1),
                      color: AppColors.redColor,
                      fontSize: d.pSH(13)),
                ),
                Text(
                  DateFormat('dd').format(appointmentDate).toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      height: d.pSH(1),
                      color: AppColors.redColor,
                      fontSize: d.pSH(25)),
                ),
              ],
            ),
            Container(
              height: double.infinity,
              width: d.pSH(2.5),
              decoration: BoxDecoration(
                  color: AppColors.blackColorOne,
                  borderRadius: BorderRadius.circular(d.pSH(1))),
            ),
            SizedBox(
              // width: d.pSW(200),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: d.pSH(10),
                            color: AppColors.blackColorOne,
                          ),
                          SizedBox(
                            width: d.pSW(1),
                          ),
                          Container(
                            padding: EdgeInsets.all(d.pSH(3)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(d.pSH(2)),
                                color: AppColors.blackColorTwo),
                            child: Text(
                              "Online Zoom",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: d.pSH(1),
                                  color: AppColors.blackColorOne,
                                  fontSize: d.pSH(8)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: d.pSH(15),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timelapse_sharp,
                            size: d.pSH(10),
                            color: AppColors.blackColorOne,
                          ),
                          SizedBox(
                            width: d.pSW(1),
                          ),
                          Container(
                            padding: EdgeInsets.all(d.pSH(3)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(d.pSH(2)),
                                color: AppColors.blackColorTwo),
                            child: Text(
                              "${DateFormat.jm().format(appointmentDate)} - ${DateFormat.jm().format(appointmentDate)}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: d.pSH(1),
                                  color: AppColors.blackColorOne,
                                  fontSize: d.pSH(8)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: d.pSH(12),
                    backgroundImage: AssetImage(
                      'assets/images/$profileImagePng',
                    ),
                  ),
                  SizedBox(
                    width: d.pSW(5),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dr. Grace Lamptey ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: d.pSH(1),
                            color: AppColors.blackColorOne,
                            fontSize: d.pSH(12)),
                      ),
                      Container(
                        padding: EdgeInsets.all(d.pSH(3)),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(d.pSH(3)),
                            color: AppColors.greenColorOne),
                        child: Text(
                          "Neurologist",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: d.pSH(1),
                              color: AppColors.whiteColorOne,
                              fontSize: d.pSH(8)),
                        ),
                      ),
                      Text(
                        "30min zoom meeting...",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: d.pSH(1),
                            color: AppColors.blackColorOne.withOpacity(0.8),
                            fontSize: d.pSH(8)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            PopupMenuButton(
              surfaceTintColor: AppColors.whiteColorOne,
              icon: Icon(
                Icons.more_vert,
                color: AppColors.blackColorOne,
                size: d.pSH(24),
              ),
              // color: AppColors.whiteColorOne,
              onSelected: (value) {},
              color: AppColors.whiteColorOne,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(d.pSH(10))),
              itemBuilder: (context) => [
                PopupMenuItem(
                    child: Container(
                  margin: EdgeInsets.only(bottom: d.pSH(10)),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 3,
                    color: AppColors.whiteColorOne,
                    child: ListTile(
                      // tileColor: AppColors.whiteColorOne,
                      leading: const RotatedBox(
                          quarterTurns: 1,
                          child: Icon(Icons.arrow_circle_left_rounded)),
                      title: Text(
                        "Reschedule",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: d.pSH(1),
                          color: AppColors.blackColorOne,
                        ),
                      ),
                    ),
                  ),
                )),
                PopupMenuItem(
                    child: Container(
                  margin: EdgeInsets.only(bottom: d.pSH(10)),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    color: AppColors.whiteColorOne,
                    child: ListTile(
                      // tileColor: AppColors.whiteColorOne,

                      leading: Icon(
                        Icons.location_on,
                        color: AppColors.blackColorOne.withOpacity(0.8),
                      ),
                      title: Text(
                        "Edit Location",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: d.pSH(1),
                            color: AppColors.blackColorOne.withOpacity(0.9)),
                      ),
                    ),
                  ),
                )),
                PopupMenuItem(
                    child: Container(
                  margin: EdgeInsets.only(bottom: d.pSH(10)),
                  child: Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    color: AppColors.whiteColorOne,
                    child: ListTile(
                      // tileColor: AppColors.whiteColorOne,

                      leading: Icon(
                        Icons.cancel,
                        color: AppColors.blackColorOne.withOpacity(0.8),
                      ),
                      title: Text(
                        "Cancel",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          height: d.pSH(1),
                          color: AppColors.blackColorOne.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class DoctorAppointmentItem extends StatefulWidget {
  final Appointment appointment;
  DoctorAppointmentItem({required this.appointment});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DoctorAppointmentItemState();
  }
}

class DoctorAppointmentItemState extends State<DoctorAppointmentItem> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late CollectionReference senderAppointmentsCollection;

// Reference the receiver's message subcollection
  late CollectionReference receiverAppointmentsCollection;

  @override
  void initState() {
    // TODO: implement initState
    senderAppointmentsCollection = _firestore
        .collection('users')
        .doc(widget.appointment.patient.id)
        .collection('appointments');
    receiverAppointmentsCollection = _firestore
        .collection('users')
        .doc(widget.appointment.doctor.id)
        .collection('appointments');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        elevation: 2.5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(d.pSH(10))),
        margin: EdgeInsets.symmetric(horizontal: d.pSH(10), vertical: d.pSH(2)),
        child: Container(
            padding: EdgeInsets.symmetric(vertical: d.pSH(15)),
            height: d.pSH(100),
            decoration: BoxDecoration(
                color: AppColors.whiteColorTwo,
                borderRadius: BorderRadius.circular(d.pSH(10))),
            width: double.infinity,
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: d.pSW(20)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        DateFormat('E')
                            .format(widget.appointment.startTime)
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            //     height: d.pSH(1),
                            color: AppColors.redColor,
                            fontSize: d.pSH(13)),
                      ),
                      Text(
                        DateFormat('dd')
                            .format(widget.appointment.startTime)
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            //  height: d.pSH(0.8),
                            color: AppColors.redColor,
                            fontSize: d.pSH(25)),
                      ),
                    ],
                  )),
              Container(
                height: double.infinity,
                width: d.pSH(2.5),
                decoration: BoxDecoration(
                    color: AppColors.blackColorOne,
                    borderRadius: BorderRadius.circular(d.pSH(1))),
              ),
              Container(
                  width: d.pSW(250),
                  padding: EdgeInsets.symmetric(horizontal: d.pSW(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${widget.appointment.patient.firstName} ${widget.appointment.patient.lastName}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${widget.appointment.initialComplaint}",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.black,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(d.pSH(3)),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(d.pSH(3)),
                                color: AppColors.greenColorOne),
                            child: Text(
                              widget.appointment.appointmentType !=
                                      AppointmentType.online
                                  ? widget.appointment.appointmentType !=
                                          AppointmentType.inPerson
                                      ? "Lab Test"
                                      : "In Person"
                                  : "Online",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: d.pSH(1),
                                  color: AppColors.whiteColorOne,
                                  fontSize: d.pSH(10)),
                            ),
                          ),
                        ],
                      ),
                      PopupMenuButton(
                        surfaceTintColor: AppColors.whiteColorOne,
                        icon: Icon(
                          Icons.more_vert,
                          color: AppColors.blackColorOne,
                          size: d.pSH(24),
                        ),
                        // color: AppColors.whiteColorOne,
                        onSelected: (value) {
                          // Navigator.pop(context);
                        },
                        color: AppColors.whiteColorOne,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(d.pSH(10))),
                        itemBuilder: (context1) => [
                          if (widget.appointment.status ==
                              AppointmentStatus.Pending)
                            PopupMenuItem(
                                child: Container(
                              margin: EdgeInsets.only(bottom: d.pSH(10)),
                              child: Card(
                                margin: EdgeInsets.zero,
                                elevation: 0,
                                color: AppColors.whiteColorOne,
                                child: ListTile(
                                  // tileColor: AppColors.whiteColorOne,
                                  onTap: () async {
                                    Navigator.pop(context1);

// Update the appointment in the sender's subcollection
                                    await senderAppointmentsCollection
                                        .doc(widget.appointment.id)
                                        .update({
                                      'status': "Upcoming",
                                    });

// Update the appointment in the receiver's subcollection
                                    await receiverAppointmentsCollection
                                        .doc(widget.appointment.id)
                                        .update({
                                      'status': "Upcoming",
                                    }).then((value) {});
                                  },
                                  leading: Icon(
                                    Icons.approval_outlined,
                                    color: AppColors.blackColorOne
                                        .withOpacity(0.8),
                                  ),
                                  title: Text(
                                    "Approve",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        height: d.pSH(1),
                                        color: AppColors.blackColorOne
                                            .withOpacity(0.9)),
                                  ),
                                ),
                              ),
                            )),
                          if (widget.appointment.status ==
                              AppointmentStatus.Upcoming)
                            PopupMenuItem(
                                child: Container(
                              margin: EdgeInsets.only(bottom: d.pSH(10)),
                              child: Card(
                                margin: EdgeInsets.zero,
                                elevation: 0,
                                color: AppColors.whiteColorOne,
                                child: ListTile(
                                  // tileColor: AppColors.whiteColorOne,
                                  onTap: () async {
                                    Navigator.pop(context1);

// Update the appointment in the sender's subcollection
                                    await senderAppointmentsCollection
                                        .doc(widget.appointment.id)
                                        .update({
                                      'status': "Completed",
                                    });

// Update the appointment in the receiver's subcollection
                                    await receiverAppointmentsCollection
                                        .doc(widget.appointment.id)
                                        .update({
                                      'status': "Completed",
                                    }).then((value) {});
                                  },
                                  leading: Icon(
                                    Icons.check,
                                    color: AppColors.blackColorOne
                                        .withOpacity(0.8),
                                  ),
                                  title: Text(
                                    "Completed",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        height: d.pSH(1),
                                        color: AppColors.blackColorOne
                                            .withOpacity(0.9)),
                                  ),
                                ),
                              ),
                            )),
                          PopupMenuItem(
                              child: Container(
                            margin: EdgeInsets.only(bottom: d.pSH(10)),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: AppColors.whiteColorOne,
                              child: ListTile(
                                // tileColor: AppColors.whiteColorOne,
                                onTap: () {
                                  Navigator.pop(context1);
                                  editAppointmentStartTime(
                                          context, widget.appointment)
                                      .then((value) async {
                                    if (value != widget.appointment.startTime) {
// Update the appointment in the sender's subcollection
                                      await senderAppointmentsCollection
                                          .doc(widget.appointment.id)
                                          .update({
                                        'startTime': value,
                                      });

// Update the appointment in the receiver's subcollection
                                      await receiverAppointmentsCollection
                                          .doc(widget.appointment.id)
                                          .update({
                                        'startTime': value,
                                      }).then((value) {});
                                    }
                                  });
                                },
                                leading: const RotatedBox(
                                    quarterTurns: 1,
                                    child: Icon(Icons.timer_sharp)),
                                title: Text(
                                  "Reschedule",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: d.pSH(1),
                                    color: AppColors.blackColorOne,
                                  ),
                                ),
                              ),
                            ),
                          )),
                          PopupMenuItem(
                              child: Container(
                            margin: EdgeInsets.only(bottom: d.pSH(10)),
                            child: Card(
                              margin: EdgeInsets.zero,
                              elevation: 0,
                              color: AppColors.whiteColorOne,
                              child: ListTile(
                                onTap: () async {
                                  Navigator.pop(context1);

// Update the appointment in the sender's subcollection
                                  await senderAppointmentsCollection
                                      .doc(widget.appointment.id)
                                      .update({
                                    'status': "Cancelled",
                                  });

// Update the appointment in the receiver's subcollection
                                  await receiverAppointmentsCollection
                                      .doc(widget.appointment.id)
                                      .update({
                                    'status': "Cancelled",
                                  }).then((value) {});
                                },
                                // tileColor: AppColors.whiteColorOne,

                                leading: Icon(
                                  Icons.cancel,
                                  color:
                                      AppColors.blackColorOne.withOpacity(0.8),
                                ),
                                title: Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: d.pSH(1),
                                    color: AppColors.blackColorOne
                                        .withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ],
                      )
                    ],
                  )),
            ])));
  }

  Future<DateTime> editAppointmentStartTime(
      BuildContext context, Appointment appointment) async {
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      initialDate: appointment.startTime,
      firstDate: DateTime.now(),
      //firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (selectedDateTime != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(appointment.startTime),
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
    return widget.appointment.startTime;
  }
}
