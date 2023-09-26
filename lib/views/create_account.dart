import 'package:flutter/material.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/Models/User.dart';
import 'package:health_app/app_colors.dart';
import 'package:health_app/components/ErrorDialog.dart';
import 'package:health_app/components/InformationDialog.dart';
import 'package:health_app/constant.dart';
import 'package:health_app/views/add_doctor.dart';
import 'package:health_app/views/bottom_navigator.dart';
import 'package:health_app/views/login.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  DateTime? selectedDate;
  bool isBusy = false;
  bool activatedOnce = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dobController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  var maskFormatter = new MaskTextInputFormatter(
      mask: '(###) #### ###',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: SafeArea(
                child: SizedBox(
                    height: d.getPhoneScreenHeight(),
                    child: Stack(children: [
                      Container(
                          alignment: Alignment.center,
                          child: Container(
                              child: Padding(
                            padding: EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Form(
                                key: _formKey,
                                autovalidateMode: activatedOnce == false
                                    ? AutovalidateMode.disabled
                                    : AutovalidateMode.onUserInteraction,
                                child: Column(
                                  children: [
                                    TextButton(
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
                                                color: AppColors.blackColorOne,
                                                fontSize: d.pSW(16)),
                                            text: "Here as a doctor? ",
                                            children: [
                                              TextSpan(
                                                text: "Set Up",
                                                style: TextStyle(
                                                    color:
                                                        AppColors.blueColorOne),
                                              )
                                            ]))),
                                    Container(
                                      padding: EdgeInsets.only(top: d.pSW(20)),
                                      alignment: Alignment.center,
                                      child: Image.asset(
                                        'assets/images/$createAccountPng',
                                        width: d.pSW(220),
                                        height: d.pSH(220),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Create An Account',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: _firstNameController,
                                      decoration: InputDecoration(
                                        labelText: 'First Name(s)',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your first name';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: _lastNameController,
                                      decoration: InputDecoration(
                                        labelText: 'Last Name',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your last name';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: _dobController,
                                      decoration: InputDecoration(
                                        labelText: 'Date of Birth',
                                        border: OutlineInputBorder(),
                                        prefixIcon: IconButton(
                                          icon: Icon(Icons.calendar_today),
                                          onPressed: () {
                                            _selectDate(context);
                                          },
                                        ),
                                      ),
                                      readOnly: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your date of birth';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      inputFormatters: [maskFormatter],
                                      controller: _phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.phone),
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a phone number';
                                        }
                                        // Remove non-digit characters before validation
                                        final digits =
                                            value.replaceAll(RegExp(r'\D'), '');
                                        if (digits.length != 10) {
                                          return 'Phone number must have 10 digits';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: _emailController,
                                      decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.mail_outline_outlined),
                                        labelText: 'Email',
                                        border: OutlineInputBorder(),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        } else if (!value.contains('@')) {
                                          return 'Please enter a valid email';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock_outline),
                                        labelText: 'Password',
                                        border: OutlineInputBorder(),
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a password';
                                        } else if (value.length < 6) {
                                          return 'Password must be at least 6 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock_outline),
                                        labelText: 'Confirm Password',
                                        border: OutlineInputBorder(),
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please confirm your password';
                                        } else if (value !=
                                            _passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          activatedOnce = true;
                                        });
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            isBusy = true;
                                          });

                                          await ScopedModel.of<MyScopedModel>(
                                                  context)
                                              .signUp(_emailController.text,
                                                  _passwordController.text)
                                              .then((value1) async {
                                            if (value1 != null) {
                                              UserProfile userProfile =
                                                  UserProfile(
                                                      id: value1.user!.uid,
                                                      category: "",
                                                      experience: "",
                                                      photoUrl: "",
                                                      firstName:
                                                          _firstNameController
                                                              .text,
                                                      lastName:
                                                          _lastNameController
                                                              .text,
                                                      dob: DateTime.parse(
                                                          _dobController.text),
                                                      email:
                                                          _emailController.text,
                                                      phoneNumber:
                                                          _phoneNumberController
                                                              .text,
                                                      role: "user");
                                              await ScopedModel.of<
                                                      MyScopedModel>(context)
                                                  .addUserProfile(userProfile)
                                                  .then((value) {
                                                setState(() {
                                                  isBusy = false;
                                                });
                                                if (value != "Success") {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        ErrorDialog(
                                                      message:
                                                          'Couldn\'t not create account please try again ',
                                                    ),
                                                  );
                                                } else {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        InformationDialog(
                                                      message:
                                                          'Account Created Successfully',
                                                    ),
                                                  ).then((value) => {
                                                        Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const BottomNavigator()))
                                                      });
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                isBusy = false;
                                              });
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        ErrorDialog(
                                                  message:
                                                      'Couldn\'t not create account please try again ',
                                                ),
                                              );
                                            }
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            AppColors.greenColorTwo,
                                        // Add other styling properties here
                                      ),
                                      child: Container(
                                        width: double
                                            .infinity, // Button reaches the end of the screen
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15), // Increased padding
                                        child: Center(
                                            child: isBusy == false
                                                ? Container(
                                                    height: 30,
                                                    padding: EdgeInsets.all(3),
                                                    child: Text(
                                                      'Create Account',
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ))
                                                : SizedBox(
                                                    height: 30,
                                                    width: 30,
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )),
                                                  )),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Already have an account? ",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        Login())));
                                          },
                                          child: Text(
                                            "Login",
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ))),
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
                    ])))));
  }
}
