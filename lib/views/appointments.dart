import 'package:flutter/material.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';

class Appointments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AppointmentsState();
  }
}

class _AppointmentsState extends State<Appointments> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MyScopedModel>(
        builder: (context, child, model) {
      return (Scaffold(
        appBar: AppBar(title: Text("My Appointments")),
      ));
    });
  }
}
