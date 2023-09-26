import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_app/components/calendar.dart';
import 'package:intl/intl.dart';

import '../../app_colors.dart';
import '../../constant.dart';
import 'components/chat_card.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  DateTime currentDate = DateTime.now();

  bool openCalendar = false;

  late TextEditingController searchController;

  String _categorySelected = "Neurologist";

  @override
  void initState() {
    searchController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SizedBox(
            height: d.getPhoneScreenHeight(),
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: [
                SliverAppBar(
                  pinned: true,
                  leadingWidth: 0,
                  title: Text(
                    "Chats",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        height: d.pSH(1),
                        color: AppColors.blackColorOne,
                        fontSize: d.pSH(24)),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: d.pSH(10)),
                      child: InkWell(
                        onTap: () {},
                        child: Text(
                          "Edit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              height: d.pSH(1),
                              color: AppColors.redColor,
                              fontSize: d.pSH(13)),
                        ),
                      ),
                    ),
                  ],
                  expandedHeight: d.pSH(200),
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(d.pSH(165)),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
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
                                        prefixIcon: const Icon(Icons.search),
                                        hintText: "Search",
                                        suffixIcon: PopupMenuButton(
                                          surfaceTintColor:
                                              AppColors.whiteColorOne,
                                          icon: Icon(
                                            Icons.sort_rounded,
                                            color: AppColors.blackColorOne,
                                            size: d.pSH(24),
                                          ),
                                          // color: AppColors.whiteColorOne,
                                          onSelected: (value) {},
                                          color: AppColors.whiteColorOne,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      d.pSH(10))),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                                child: Container(
                                              margin: EdgeInsets.only(
                                                  bottom: d.pSH(10)),
                                              child: Card(
                                                margin: EdgeInsets.zero,
                                                elevation: 3,
                                                color: AppColors.whiteColorOne,
                                                child: ListTile(
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
                                                elevation: 0,
                                                color: AppColors.whiteColorOne,
                                                child: ListTile(
                                                  // tileColor: AppColors.whiteColorOne,
                                                  leading: const RotatedBox(
                                                      quarterTurns: 0,
                                                      child: Icon(
                                                          Icons.pause_circle)),
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
                                            PopupMenuItem(
                                                child: Container(
                                              margin: EdgeInsets.only(
                                                  bottom: d.pSH(10)),
                                              child: Card(
                                                margin: EdgeInsets.zero,
                                                elevation: 0,
                                                color: AppColors.whiteColorOne,
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
                                                elevation: 0,
                                                color: AppColors.whiteColorOne,
                                                child: ListTile(
                                                  // tileColor: AppColors.whiteColorOne,

                                                  leading: Icon(
                                                    Icons.cancel,
                                                    color: AppColors
                                                        .blackColorOne
                                                        .withOpacity(0.8),
                                                  ),
                                                  title: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      height: d.pSH(1),
                                                      color: AppColors
                                                          .blackColorOne
                                                          .withOpacity(0.9),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )),
                                          ],
                                        ),
                                        border: InputBorder.none),
                                  ),
                                )),
                            SizedBox(
                              height: d.pSH(20),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: d.pSH(10),
                                      width: d.pSH(10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(d.pSH(10)),
                                          color: AppColors.greenColorTwo),
                                    ),
                                    SizedBox(
                                      width: d.pSW(5),
                                    ),
                                    Text(
                                      "Active",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          height: d.pSH(1),
                                          color: AppColors.blackColorOne,
                                          fontSize: d.pSH(12)),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: d.pSH(10),
                                ),
                                SizedBox(
                                  height: d.pSH(80),
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          width: d.pSH(80),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: d.pSH(60),
                                                width: d.pSH(60),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          d.pSH(2)),
                                                ),
                                                child: Image.asset(
                                                  'assets/images/$profileImagePng',
                                                  width: d.pSW(24),
                                                  height: d.pSH(24),
                                                ),
                                              ),
                                              Text(
                                                "Dr. Kwasi Evans",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    height: d.pSH(1),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    color:
                                                        AppColors.blackColorOne,
                                                    fontSize: d.pSH(8)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          width: d.pSW(8),
                                        );
                                      },
                                      itemCount: 7),
                                )
                              ],
                            ),
                            Container(
                              height: d.pSH(1),
                              color: Colors.black,
                            )
                          ]),
                    ),
                  ),
                  // toolbarHeight: d.pSH(300),
                  leading: const SizedBox(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return const ChatCard();
                    },
                    childCount: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.greenColorTwo,
          shape: const CircleBorder(),
          heroTag: 'add-chat',
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return Container(
                    // height: d.getPhoneScreenHeight() * (4 / 5),
                    padding: EdgeInsets.symmetric(
                        horizontal: d.pSH(10), vertical: d.pSW(15)),
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: d.pSW(30),
                            height: d.pSH(2.5),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: AppColors.blackColorOne,
                                borderRadius: BorderRadius.circular(d.pSH(1))),
                            margin: EdgeInsets.only(right: d.pSW(0)),
                          ),
                        ),
                        Text(
                          "Category",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              height: d.pSH(1),
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.blackColorOne,
                              fontSize: d.pSH(25)),
                        ),
                        SizedBox(
                          height: d.pSH(10),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: d.pSH(95),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                buildCategoryCard(
                                  assetName: 'Neurologist',
                                  assetPath: neurologistSvg,
                                ),
                                SizedBox(
                                  width: d.pSW(10),
                                ),
                                buildCategoryCard(
                                  assetName: 'Urologist',
                                  assetPath: urologistSvg,
                                ),
                                SizedBox(
                                  width: d.pSW(10),
                                ),
                                buildCategoryCard(
                                  assetName: 'Radiologist',
                                  assetPath: radiologistSvg,
                                ),
                                SizedBox(
                                  width: d.pSW(10),
                                ),
                                buildCategoryCard(
                                  assetName: 'Medicine',
                                  assetPath: medicineSvg,
                                ),
                                SizedBox(
                                  width: d.pSW(10),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: d.pSH(10),
                        ),
                        Text(
                          "Experience",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              height: d.pSH(1),
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.blackColorOne,
                              fontSize: d.pSH(25)),
                        ),
                        SizedBox(
                          height: d.pSH(10),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: d.pSH(25),
                              width: d.pSW(90),
                              decoration: BoxDecoration(
                                  color: AppColors.greenColorTwo,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  )),
                              child: Center(
                                child: Text(
                                  "3 years",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      height: d.pSH(1),
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.whiteColorOne,
                                      fontSize: d.pSH(15)),
                                ),
                              ),
                            ),
                            Container(
                              height: d.pSH(25),
                              width: d.pSW(1),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColorOne,
                              ),
                            ),
                            Container(
                              height: d.pSH(25),
                              width: d.pSW(80),
                              decoration: BoxDecoration(
                                color: AppColors.blackColorTwo,
                              ),
                              child: Center(
                                child: Text(
                                  "5 years",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      height: d.pSH(1),
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.blackColorOne,
                                      fontSize: d.pSH(15)),
                                ),
                              ),
                            ),
                            Container(
                              height: d.pSH(25),
                              width: d.pSW(1),
                              decoration: BoxDecoration(
                                color: AppColors.whiteColorOne,
                              ),
                            ),
                            Container(
                              height: d.pSH(25),
                              width: d.pSW(80),
                              decoration: BoxDecoration(
                                  color: AppColors.blackColorTwo,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  )),
                              child: Center(
                                child: Text(
                                  "More",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      height: d.pSH(1),
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColors.blackColorOne,
                                      fontSize: d.pSH(15)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: d.pSH(10),
                        ),
                        Text(
                          "Doctors",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              height: d.pSH(1),
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.blackColorOne,
                              fontSize: d.pSH(25)),
                        ),
                        SizedBox(
                          height: d.pSH(10),
                        ),
                        Flexible(
                          child: SizedBox(
                            height: d.pSH(85),
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                separatorBuilder: (context, index) => SizedBox(
                                      width: d.pSW(10),
                                    ),
                                itemBuilder: (context, index) {
                                  return SizedBox(
                                    width: d.pSH(80),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: d.pSH(60),
                                          width: d.pSH(60),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(d.pSH(2)),
                                          ),
                                          child: Image.asset(
                                            'assets/images/$profileImagePng',
                                            width: d.pSW(24),
                                            height: d.pSH(24),
                                          ),
                                        ),
                                        Text(
                                          "Dr. Kwasi Evans",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              height: d.pSH(1),
                                              overflow: TextOverflow.ellipsis,
                                              color: AppColors.blackColorOne,
                                              fontSize: d.pSH(8)),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(
                          height: d.pSH(30),
                        ),
                        Center(
                          child: SizedBox(
                            width: (d.getPhoneScreenWidth()) * (3 / 4),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  elevation: d.pSH(2),
                                  backgroundColor: AppColors.blueColorOne,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(d.pSH(5))),
                                  padding: EdgeInsets.all(d.pSH(0.5))),
                              child: Text(
                                "Have a conversation",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: d.pSH(20),
                                    color: AppColors.whiteColorOne),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: (d.getPhoneScreenWidth()) * (3 / 4),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  elevation: d.pSH(2),
                                  backgroundColor: AppColors.greenColorOne,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(d.pSH(5))),
                                  padding: EdgeInsets.all(d.pSH(0.5))),
                              child: Text(
                                "Schedule an appointment",
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: d.pSH(20),
                                    color: AppColors.whiteColorOne),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                });
              },
            );
          },
          child: SvgPicture.asset(
            'assets/icons/$chatAddSvg',
            width: d.pSW(24),
            height: d.pSH(24),
          ),
        ));
  }

  Widget buildCategoryCard({
    required String assetPath,
    required String assetName,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _categorySelected = assetName;
        });
      },
      child: AnimatedContainer(
        height: d.pSH(90),
        width: d.pSH(60),
        duration: const Duration(microseconds: 500),
        padding: EdgeInsets.all(d.pSW(2)),
        decoration: BoxDecoration(
            color: AppColors.blackColorTwo,
            borderRadius: BorderRadius.circular(d.pSH(2))),
        child: Center(
          child: Column(
            children: [
              Container(
                // padding: EdgeInsets.all(d.pSW(5)),
                width: double.infinity,
                height: d.pSH(50),

                decoration: BoxDecoration(
                    color: _categorySelected.toLowerCase() ==
                            assetName.toLowerCase()
                        ? AppColors.greenColorOne
                        : AppColors.whiteColorOne,
                    borderRadius: BorderRadius.circular(d.pSH(2))),
                child: SvgPicture.asset(
                  'assets/icons/$assetPath',
                  width: d.pSW(30),
                  height: d.pSH(30),
                  color:
                      _categorySelected.toLowerCase() == assetName.toLowerCase()
                          ? AppColors.whiteColorOne
                          : AppColors.blackColorOne,
                ),
              ),
              SizedBox(
                height: d.pSH(3),
              ),
              Text(
                assetName,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    height: d.pSH(1),
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.blackColorOne,
                    fontSize: d.pSH(9)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
