import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/Models/User.dart';
import 'package:health_app/Pages/ChatPage.dart';
import 'package:health_app/Pages/ManagePatientAppointment.dart';
import 'package:health_app/app_colors.dart';
import 'package:health_app/constant.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime currentDate = DateTime.now();

  bool openCalendar = false;

  TextEditingController searchController = TextEditingController();
  UserProfile? selectedDoctor;
  String? _experienceSelected;
  String _categorySelected = "Neurologist";
  List<UserProfile> get selectedDoctors {
    return filterSelectedDoctors(ScopedModel.of<MyScopedModel>(context).doctors,
        _categorySelected, _experienceSelected);
  }

  List<UserProfile> filterSelectedDoctors(List<UserProfile> doctors,
      String categorySelected, String? experienceSelected) {
    if (_experienceSelected == null) {
      return doctors
          .where((element) => element.category == _categorySelected)
          .toList();
    } else {
      return doctors
          .where((element) =>
              element.experience == _experienceSelected &&
              element.category == _categorySelected)
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Future<UserProfile?> getUserProfile(String id) async {
    final docRef = _firestore.collection('users').doc(id);
    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return UserProfile.fromMap(docSnapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);

    return ScopedModelDescendant<MyScopedModel>(
        builder: ((context, child, model) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: SizedBox(
              height: d.getPhoneScreenHeight(),
              child: Column(
                //  shrinkWrap: true,
                children: [
                  SizedBox(
                      height: d.pSH(160),
                      child: AppBar(
                        //pinned: true,
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
                        /* actions: [
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
                        ],*/

                        //expandedHeight: d.pSH(200),
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(d.pSH(50)),
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(horizontal: d.pSH(10)),
                            // height: d.pSH(70),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  /*   Card(
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
                                                      color: AppColors
                                                          .whiteColorOne,
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
                                                      color: AppColors
                                                          .whiteColorOne,
                                                      child: ListTile(
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
                                                  PopupMenuItem(
                                                      child: Container(
                                                    margin: EdgeInsets.only(
                                                        bottom: d.pSH(10)),
                                                    child: Card(
                                                      margin: EdgeInsets.zero,
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
                                                      color: AppColors
                                                          .whiteColorOne,
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
                                                                .withOpacity(
                                                                    0.9),
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
                                  ),*/
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
                                                    BorderRadius.circular(
                                                        d.pSH(10)),
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
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      ChatPage(
                                                                          receiverId:
                                                                              model.doctors[index])));
                                                        },
                                                        child: Container(
                                                            height: d.pSH(60),
                                                            width: d.pSH(60),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: AppColors
                                                                  .greenColorOne,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          40),
                                                            ),
                                                            child: model
                                                                        .doctors[
                                                                            index]
                                                                        .photoUrl ==
                                                                    ""
                                                                ? Center(
                                                                    child: Text(
                                                                      model
                                                                          .doctors[
                                                                              index]
                                                                          .firstName[0],
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    ),
                                                                  )
                                                                : Image(
                                                                    image: NetworkImage(model
                                                                        .doctors[
                                                                            index]
                                                                        .photoUrl)))),
                                                    SizedBox(height: 7),
                                                    Text(
                                                      "Dr. " +
                                                          model.doctors[index]
                                                              .firstName +
                                                          " " +
                                                          model.doctors[index]
                                                              .lastName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          height: d.pSH(1),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          color: AppColors
                                                              .blackColorOne,
                                                          fontSize: d.pSH(9)),
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
                                            itemCount: model.doctors.length),
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
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: Align(
                        child: Text(
                          "Recents",
                          style: TextStyle(fontSize: 18),
                        ),
                        alignment: Alignment.centerLeft),
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('users')
                          .doc(ScopedModel.of<MyScopedModel>(context)
                              .authenticatdUser!
                              .id)
                          .collection('messages')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: Text("No messages"));
                        }

                        final messages = snapshot.data!.docs;
                        // Create a set to store unique user IDs
                        Set<String> uniqueUserIds = Set<String>();

                        // Iterate through messages and add senderId and receiverId to the set
                        for (var message in messages) {
                          uniqueUserIds.add(message['senderId']);
                          uniqueUserIds.add(message['receiverId']);
                        }

                        // Convert the set to a list
                        List<String> uniqueUserIdsList = uniqueUserIds.toList();

                        // Remove the current user's ID from the list
                        uniqueUserIdsList.remove(
                            ScopedModel.of<MyScopedModel>(context)
                                .authenticatdUser!
                                .id);

                        // Now, uniqueUserIdsList contains unique user IDs the current user has chatted with
                        // You can use this list to display a list of users

                        // Example: Display the list of user IDs
                        return ListView.builder(
                          itemCount: uniqueUserIdsList.length,
                          itemBuilder: (context, index) {
                            final message =
                                messages[index].data() as Map<String, dynamic>;
                            final receiverId = message['receiverId'] as String;
                            final senderId = message['senderId'] as String;

                            //final timestamp = message['timestamp'] as Timestamp;
                            final isRead = message['status'] ==
                                'read'; // Adjust as per your status logic
                            String otherId = "";
                            if (senderId ==
                                ScopedModel.of<MyScopedModel>(context)
                                    .authenticatdUser!
                                    .id) {
                              otherId = receiverId;
                            } else {
                              otherId = senderId;
                            }
                            return FutureBuilder<UserProfile?>(
                              future: getUserProfile(otherId),
                              builder: (context, userProfileSnapshot) {
                                if (userProfileSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      // Display a placeholder with the first letter of the first name
                                      child: Text(''),
                                    ),
                                    title: Text('Loading...'),
                                  );
                                }

                                if (!userProfileSnapshot.hasData ||
                                    userProfileSnapshot.data == null) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      // Display a placeholder with the first letter of the first name
                                      child: Text(''),
                                    ),
                                    title: Text('Error loading profile'),
                                  );
                                }

                                final userProfile = userProfileSnapshot.data!;

                                return ListTile(
                                  leading: userProfile.photoUrl != null ||
                                          userProfile.photoUrl != ""
                                      ? CircleAvatar(
                                          // Display a placeholder with the first letter of the first name
                                          child: Text(userProfile.firstName
                                              .substring(0, 1)),
                                        )
                                      : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              userProfile.photoUrl),
                                        ),
                                  title: Text(
                                      '${userProfile.firstName} ${userProfile.lastName}'),
                                  //    subtitle: Text(
                                  //    'Unread messages: ${isRead ? 0 : 1}',
                                  //),
                                  onTap: () {
                                    // Navigate to the chat page with the selected receiver
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChatPage(receiverId: userProfile),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
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
                                  borderRadius:
                                      BorderRadius.circular(d.pSH(1))),
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
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _categorySelected = "Neurologist";
                                        });
                                      },
                                      child: buildCategoryCard(
                                        assetName: 'Neurologist',
                                        assetPath: neurologistSvg,
                                      )),
                                  SizedBox(
                                    width: d.pSW(10),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _categorySelected = "Urologist";
                                        });
                                      },
                                      child: buildCategoryCard(
                                        assetName: 'Urologist',
                                        assetPath: urologistSvg,
                                      )),
                                  SizedBox(
                                    width: d.pSW(10),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _categorySelected = "Radiologist";
                                        });
                                      },
                                      child: buildCategoryCard(
                                        assetName: 'Radiologist',
                                        assetPath: radiologistSvg,
                                      )),
                                  SizedBox(
                                    width: d.pSW(10),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _categorySelected = "Medicine";
                                        });
                                      },
                                      child: buildCategoryCard(
                                        assetName: 'Medicine',
                                        assetPath: medicineSvg,
                                      )),
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
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _experienceSelected = "3 years";
                                    });
                                  },
                                  child: Container(
                                    height: d.pSH(25),
                                    width: d.pSW(90),
                                    decoration: BoxDecoration(
                                        color: _experienceSelected == "3 years"
                                            ? AppColors.greenColorTwo
                                            : AppColors.blackColorTwo,
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
                                            //   color: AppColors.whiteColorOne,
                                            fontSize: d.pSH(15)),
                                      ),
                                    ),
                                  )),
                              Container(
                                height: d.pSH(25),
                                width: d.pSW(1),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColorOne,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _experienceSelected = "5 years";
                                    });
                                  },
                                  child: Container(
                                    height: d.pSH(25),
                                    width: d.pSW(80),
                                    decoration: BoxDecoration(
                                      color: _experienceSelected == "5 years"
                                          ? AppColors.greenColorTwo
                                          : AppColors.blackColorTwo,
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
                                  )),
                              Container(
                                height: d.pSH(25),
                                width: d.pSW(1),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteColorOne,
                                ),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _experienceSelected = "More";
                                    });
                                  },
                                  child: Container(
                                    height: d.pSH(25),
                                    width: d.pSW(80),
                                    decoration: BoxDecoration(
                                        color: _experienceSelected == "More"
                                            ? AppColors.greenColorTwo
                                            : AppColors.blackColorTwo,
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
                                  )),
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
                              height: d.pSH(95),
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: selectedDoctors.length,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                        width: d.pSW(10),
                                      ),
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedDoctor =
                                                selectedDoctors[index];
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // color: Colors
                                            //   .t, // Set the background color
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            border: selectedDoctor ==
                                                    selectedDoctors[index]
                                                ? Border.all(
                                                    color: Colors.blue,
                                                    width:
                                                        2.0) // Add a blue border if the condition is met
                                                : Border.all(
                                                    color: Colors.transparent,
                                                    width:
                                                        2.0), // No border if the condition is not met
                                          ),
                                          width: d.pSH(80),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                height: d.pSH(70),
                                                width: d.pSH(80),
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          d.pSH(2)),
                                                ),
                                                child: selectedDoctors[index]
                                                            .photoUrl ==
                                                        ""
                                                    ? Container(
                                                        color: AppColors
                                                            .greenColorOne,
                                                        child: Center(
                                                            child: Text(
                                                          selectedDoctors[index]
                                                              .firstName[0],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )))
                                                    : Image.asset(
                                                        'assets/images/$profileImagePng',
                                                        width: d.pSW(24),
                                                        height: d.pSH(24),
                                                      ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Dr. ${selectedDoctors[index].firstName} ${selectedDoctors[index].lastName}",
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
                                        ));
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
                                onPressed: () {
                                  if (selectedDoctor != null) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => ChatPage(
                                                receiverId: selectedDoctor!)));
                                  }
                                },
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
                                onPressed: () {
                                  if (selectedDoctor != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                ManagePatientAppointment(
                                                  appointment: null,
                                                  initialDoctor: selectedDoctor,
                                                ))));
                                  }
                                },
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
    }));
  }

  Widget buildCategoryCard({
    required String assetPath,
    required String assetName,
  }) {
    return AnimatedContainer(
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
                  color:
                      _categorySelected.toLowerCase() == assetName.toLowerCase()
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
    );
  }
}
