import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_app/Pages/ChatListPage.dart';
import 'package:health_app/Pages/PatientAppointmentPage.dart';
import 'package:health_app/views/schedule/schedule.dart';
import 'package:health_app/views/schedule/schedule.dart';
import '../app_colors.dart';
import '../constant.dart';
import 'chats/chats.dart';
import 'home/home.dart';
import 'libraray/library.dart';

class BottomNavigator extends StatefulWidget {
  const BottomNavigator({super.key});

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
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
      bottomNavigationBar: Card(
        elevation: 5,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: d.pSH(20)),
            height: d.pSH(70),
            decoration: BoxDecoration(
                color: AppColors.whiteColorOne,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            duration: const Duration(microseconds: 500),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildNavButton(iconPath: homeSvg, index: 0, name: "Home"),
                buildNavButton(
                    iconPath: scheduleSvg, index: 1, name: "Appointments"),
                buildNavButton(iconPath: chatSvg, index: 2, name: "Chats"),
                buildNavButton(iconPath: librarySvg, index: 3, name: "Library"),
              ],
            )),
      ),
      body: SafeArea(
        child: IndexedStack(
          index: _currentPage,
          children: const [
            Home(),
            PatientAppointmentPage(),
            ChatListPage(),
            Library(),
          ],
        ),
      ),
    );
  }

  Widget buildNavButton(
      {required String name, required int index, required String iconPath}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentPage = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/$iconPath',
            width: d.pSW(24),
            height: d.pSH(24),
            color: _currentPage == index
                ? AppColors.greenColorOne
                : AppColors.blackColorOne.withOpacity(0.5),
          ),
          SizedBox(
            height: d.pSH(4),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight:
                    _currentPage == index ? FontWeight.bold : FontWeight.normal,
                height: d.pSH(1),
                color: _currentPage == index
                    ? AppColors.greenColorOne
                    : AppColors.blackColorOne.withOpacity(0.5),
                fontSize: d.pSH(_currentPage == index ? 16 : 14)),
          ),
        ],
      ),
    );
  }
}
