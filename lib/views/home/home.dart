import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:health_app/Models/Appointment.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/Pages/PatientAppointmentPage.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../app_colors.dart';
import '../../constant.dart';
import '../bottom_navigator.dart';

class Home extends StatelessWidget {
  const Home({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: d.getPhoneScreenHeight(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            // color: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
            height: d.pSH(60),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                /*      CircleAvatar(
                  radius: d.pSH(25),
                  backgroundImage: AssetImage(
                    'assets/images/$profileImagePng',
                  ),
                ),
                SizedBox(
                  width: d.pSW(10),
                ),*/
                Text(
                  "Hello ${ScopedModel.of<MyScopedModel>(context).authenticatdUser!.firstName}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      height: d.pSH(1),
                      color: AppColors.blackColorOne,
                      fontSize: d.pSH(20)),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.menu))
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: d.getPhoneScreenHeight() - d.pSH(60),
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(d.pSH(10))),
                      child: Container(
                        padding: EdgeInsets.all(d.pSH(15)),
                        // height: d.pSH(d.pSH(300)),
                        width: d.getPhoneScreenWidth() - 100,
                        // constraints: BoxConstraints(
                        //   maxHeight: d.pSH(300)
                        // ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(d.pSH(10)),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFF00DE72),
                                  AppColors.whiteColorOne
                                ])),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text.rich(TextSpan(
                                text: homeInfo,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: d.pSH(24)))),
                            SizedBox(
                              width: d.pSW(100),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    elevation: d.pSH(2),
                                    backgroundColor: AppColors.redColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(d.pSH(5))),
                                    padding: EdgeInsets.all(d.pSH(3))),
                                child: Text(
                                  "Read More",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: d.pSH(16),
                                      color: AppColors.whiteColorOne),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: d.pSH(20),
                  ),
                  buildMyAppointments(context),
                  SizedBox(
                    height: d.pSH(20),
                  ),
                  /*  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Recent Activity",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: d.pSH(1),
                              color: AppColors.blackColorOne,
                              fontSize: d.pSH(24)),
                        ),
                        SizedBox(
                          height: d.pSH(10),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                              children: List.generate(
                            5,
                            (index) => buildRecentActivityCard(),
                          ).toList()),
                        )
                      ],
                    ),
                  )*/
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Card buildRecentActivityCard() {
    return Card(
      margin: EdgeInsets.only(bottom: d.pSH(10)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(d.pSH(10))),
      child: Container(
        decoration: BoxDecoration(
            color: AppColors.blackColorTwo,
            borderRadius: BorderRadius.circular(d.pSH(10))),
        height: d.pSH(130),
      ),
    );
  }

  Container buildMyAppointments(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "My Appointments",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: d.pSH(1),
                    color: AppColors.blackColorOne,
                    fontSize: d.pSH(24)),
              ),
            ],
          ),
          Container(
              height: 180,
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

                  List<Appointment> myAppointments = appointments.map((doc) {
                    return Appointment.fromMap(
                        doc.data() as Map<String, dynamic>);
                  }).toList();
                  List<AppointmentItem> appointmentsItems = [];

                  for (var app in myAppointments) {
                    appointmentsItems.add(AppointmentItem(appointment: app));
                  }
                  //allAppointments = myAppointments;
                  return Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: appointmentsItems.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              appointmentsItems[index],
                              SizedBox(
                                width: 10,
                              )
                            ],
                          );
                        },
                      ));
                },
              ))
        ],
      ),
    );
  }

  Card buildMyAppointmentCard({
    required DateTime appointmentDateTme,
  }) {
    return Card(
      margin: EdgeInsets.only(right: d.pSH(10)),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(d.pSH(10))),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.blackColorTwo,
            borderRadius: BorderRadius.circular(d.pSH(10))),
        padding:
            EdgeInsets.symmetric(horizontal: d.pSH(5), vertical: d.pSH(10)),
        width: d.pSW(250),
        height: d.pSH(100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: double.infinity,
              width: d.pSH(2.5),
              decoration: BoxDecoration(
                  color: AppColors.greenColorTwo,
                  borderRadius: BorderRadius.circular(d.pSH(1))),
              margin: EdgeInsets.only(right: d.pSW(0)),
            ),
            SizedBox(
              width: d.pSW(200),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('d, MMMM, y')
                            .format(appointmentDateTme)
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: d.pSH(1),
                            color: AppColors.redColor,
                            fontSize: d.pSH(15)),
                      ),
                      Text(
                        DateFormat.jm()
                            .format(appointmentDateTme)
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: d.pSH(1),
                            color: AppColors.redColor,
                            fontSize: d.pSH(15)),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Diagnostic Results",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w400,
                            height: d.pSH(1),
                            color: AppColors.blackColorOne,
                            fontSize: d.pSH(15)),
                      ),
                      Text(
                        "Doctor Frank Jacobs",
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.bold,
                            height: d.pSH(1),
                            color: AppColors.blackColorOne,
                            fontSize: d.pSH(15)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
