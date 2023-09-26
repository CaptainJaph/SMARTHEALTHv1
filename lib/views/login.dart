import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/components/ErrorDialog.dart';
import 'package:health_app/views/add_doctor.dart';
import 'package:health_app/views/create_account.dart';
import 'package:health_app/views/bottom_navigator.dart';
import 'package:health_app/views/doctor_bottom_navigator.dart';
import 'package:health_app/views/home/adminhome.dart';
import 'package:scoped_model/scoped_model.dart';

import '../app_colors.dart';
import '../constant.dart';

// Andrews Obeng

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isBusy = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);

    return ScopedModelDescendant<MyScopedModel>(
        builder: ((context, child, model) {
      return Scaffold(
        body: SafeArea(
            child: SizedBox(
          height: d.getPhoneScreenHeight(),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: d.pSW(20)),
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/$loginPng',
                            width: d.pSW(220),
                            height: d.pSH(220),
                          ),
                        ),
                        SizedBox(
                          height: d.pSH(15),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: d.pSW(20)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: d.pSH(1),
                                    color: AppColors.greenColorOne,
                                    fontSize: d.pSH(25)),
                              ),
                              SizedBox(
                                height: d.pSH(25),
                              ),
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FormCardTextFeild(
                                          hintText: "Email",
                                          emailController: emailController),
                                      SizedBox(
                                        height: d.pSH(15),
                                      ),
                                      FormCardTextFeild(
                                          hintText: "Password",
                                          emailController: passwordController),
                                      /* TextButton(
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/$googleSvg',
                                                width: d.pSW(24),
                                                height: d.pSH(24),
                                              ),
                                               SizedBox(
                                                width: d.pSH(5),
                                              ),
                                              Text(
                                                "Login with Google",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    height: d.pSH(1),
                                                    color:
                                                        AppColors.blackColorOne,
                                                    fontSize: d.pSH(16)),
                                              ),
                                            ],
                                          )),*/
                                      SizedBox(
                                        height: d.pSH(15),
                                      ),
                                      SizedBox(
                                        width:
                                            (d.getPhoneScreenWidth()) * (3 / 7),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              isBusy = true;
                                            });
                                            if (emailController.text ==
                                                "appadmin@gmail.com") {
                                              await model
                                                  .adminSignIn(
                                                      emailController.text,
                                                      passwordController.text)
                                                  .then((value) {
                                                if (value == true) {
                                                  setState(() {
                                                    isBusy = false;
                                                  });

                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            AdminPage(),
                                                      ));
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        ErrorDialog(
                                                      message:
                                                          'Incorrect Password!',
                                                    ),
                                                  ).then((value) {
                                                    setState(() {
                                                      isBusy = false;
                                                    });
                                                  });
                                                }
                                              });
                                            } else {
                                              await model
                                                  .signIn(emailController.text,
                                                      passwordController.text)
                                                  .then((value) async {
                                                if (value != null) {
                                                  if (value.role == "user") {
                                                    await model
                                                        .getDoctorProfiles()
                                                        .then((value) {
                                                      setState(() {
                                                        isBusy = false;
                                                      });

                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const BottomNavigator(),
                                                          ));
                                                    });
                                                  } else {
                                                    setState(() {
                                                      isBusy = false;
                                                    });
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const DoctorBottomNavigator()));
                                                  }
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        ErrorDialog(
                                                      message:
                                                          'Invalid Username or Password!',
                                                    ),
                                                  ).then((value) {
                                                    setState(() {
                                                      isBusy = false;
                                                    });
                                                  });
                                                }
                                              });
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                              elevation: d.pSH(2),
                                              backgroundColor:
                                                  AppColors.greenColorTwo,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          d.pSH(5))),
                                              padding:
                                                  EdgeInsets.all(d.pSH(0.5))),
                                          child: isBusy == true
                                              ? Container(
                                                  height: d.pSH(18),
                                                  width: d.pSH(18),
                                                  child: Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                                  ))
                                              : Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: d.pSH(18),
                                                      color: AppColors
                                                          .whiteColorOne),
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: d.pSH(35),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      CreateAccountPage(),
                                                ));
                                          },
                                          child: Text.rich(TextSpan(
                                              style: TextStyle(
                                                  color:
                                                      AppColors.blackColorOne),
                                              text: "Don't have an account? ",
                                              children: [
                                                TextSpan(
                                                  text: "Sign Up",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .blueColorOne),
                                                )
                                              ]))),
                                      /*   TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddDoctorPage(),
                                                ));
                                          },
                                          child: Text.rich(TextSpan(
                                              style: TextStyle(
                                                  color:
                                                      AppColors.blackColorOne),
                                              text: "Create doctor account? ",
                                              children: [
                                                TextSpan(
                                                  text: "Sign Up",
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .blueColorOne),
                                                )
                                              ]))),*/
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              Positioned(
                top: d.pSH(10),
                left: d.pSH(10),
                child: SizedBox(
                  height: d.pSH(60),
                  child: Image.asset(
                    'assets/images/$knustLogoPng',
                    width: d.pSW(30),
                    height: d.pSH(30),
                  ),
                ),
              ),
            ],
          ),
        )),
      );
    }));
  }
}

class FormCardTextFeild extends StatelessWidget {
  const FormCardTextFeild({
    super.key,
    required this.hintText,
    required this.emailController,
  });

  final TextEditingController emailController;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: AppColors.whiteColorOne,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(d.pSH(5))),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: d.pSH(10), vertical: d.pSH(3)),
          child: TextFormField(
            controller: emailController,
            decoration:
                InputDecoration(hintText: hintText, border: InputBorder.none),
          ),
        ));
  }
}
