import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_app/views/scrum_page.dart';

import '../app_colors.dart';
import '../constant.dart';

class CoverPage extends StatefulWidget {
  const CoverPage({super.key});

  @override
  State<CoverPage> createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  startTimer() async {
    Timer(const Duration(milliseconds: 2500), (() => navigatorPage(context)));
  }

  Future<void> navigatorPage(context) async {
    try {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ScrumPage()));
    } catch (e) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ScrumPage()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);
    return Scaffold(
      body: Container(
        width: d.getPhoneScreenWidth(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image:
                    AssetImage("assets/images/african-american-doctor.png"))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/$knustLogoPng',
              width: d.pSW(190),
              height: d.pSH(190),
            ),
            SizedBox(
              height: d.pSH(40),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScrumPage(),
                    ));
              },
              child: Text(
                "Smart\nHealth",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    height: d.pSH(1),
                    color: AppColors.whiteColorOne,
                    fontSize: d.pSH(50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
