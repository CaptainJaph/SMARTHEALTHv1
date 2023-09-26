import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../app_colors.dart';
import '../constant.dart';
import 'login.dart';

class ScrumPage extends StatefulWidget {
  const ScrumPage({super.key});

  @override
  State<ScrumPage> createState() => _ScrumPageState();
}

class _ScrumPageState extends State<ScrumPage> {
  int _currentPage = 0;
  late PageController pageController;
  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);

    return Scaffold(
        body: SafeArea(
          child: SizedBox(
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
                      Image.asset(
                        'assets/images/$knustLogoPng',
                        width: d.pSW(30),
                        height: d.pSH(30),
                      ),
                      SizedBox(
                        width: d.pSW(10),
                      ),
                      Text(
                        "SMART HEALTH",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            height: d.pSH(1),
                            color: AppColors.blackColorOne,
                            fontSize: d.pSH(16)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: d.getPhoneScreenHeight() - d.pSH(60),
                    child: Stack(
                      children: [
                        PageView(
                          controller: pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            buildIndicatorPage(
                                assetsPath: scrumSvg,
                                message:
                                    "Communicate with Health Professionals"),
                            buildIndicatorPage(
                                assetsPath: scrumSvg,
                                message:
                                    "Communicate with Health Professionals"),
                            buildIndicatorPage(
                                assetsPath: scrumSvg,
                                message:
                                    "Communicate with Health Professionals"),
                            buildIndicatorPage(
                                assetsPath: scrumSvg,
                                message:
                                    "Communicate with Health Professionals"),
                          ],
                        ),
                        buildIndicators()
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ));
          },
          style: ElevatedButton.styleFrom(
              elevation: d.pSH(2),
              backgroundColor: AppColors.whiteColorOne,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(d.pSH(5))),
              padding: EdgeInsets.all(d.pSH(0.5))),
          child: Text(
            "Skip",
            style: TextStyle(color: AppColors.blackColorOne),
          ),
        ));
  }

  Container buildIndicatorPage(
      {required String assetsPath, required String message}) {
    return Container(
      alignment: Alignment.center,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Image.asset(
              'assets/images/$assetsPath',
              width: d.pSW(300),
              height: d.pSH(300),
            ),
            const Spacer(),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: d.pSH(1),
                  color: AppColors.greenColorOne,
                  fontSize: d.pSH(33)),
            ),
            const Spacer(
              flex: 5,
            ),
          ]),
    );
  }

  Align buildIndicators() {
    return Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: d.pSH(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSingleIndicator(0),
              buildSingleIndicator(1),
              buildSingleIndicator(2),
              buildSingleIndicator(3),
            ],
          ),
        ));
  }

  Widget buildSingleIndicator(int currentIndicator) {
    return GestureDetector(
      onTap: () {
        pageController.animateToPage(currentIndicator,
            duration: const Duration(milliseconds: 200), curve: Curves.linear);
        setState(() {
          _currentPage = currentIndicator;
        });
      },
      child: AnimatedContainer(
          margin: EdgeInsets.all(d.pSH(2)),
          height: d.pSH(10),
          width: d.pSH(10),
          decoration: BoxDecoration(
              color: _currentPage == currentIndicator
                  ? AppColors.blackColorOne
                  : null,
              border:
                  Border.all(width: d.pSH(0.9), color: AppColors.blackColorOne),
              borderRadius: BorderRadius.circular(d.pSH(10))),
          duration: const Duration(milliseconds: 200)),
    );
  }
}
