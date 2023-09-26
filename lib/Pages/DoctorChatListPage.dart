import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/Models/User.dart';
import 'package:health_app/Pages/ChatPage.dart';
import 'package:health_app/app_colors.dart';
import 'package:health_app/constant.dart';
import 'package:scoped_model/scoped_model.dart';

class DoctorChatListPage extends StatefulWidget {
  const DoctorChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<DoctorChatListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DateTime currentDate = DateTime.now();

  bool openCalendar = false;

  TextEditingController searchController = TextEditingController();

  String _categorySelected = "Neurologist";

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          height: d.getPhoneScreenHeight(),
          child: Column(
            //  shrinkWrap: true,
            children: [
              SizedBox(
                  height: d.pSH(50),
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
                    /*  actions: [
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
                      preferredSize: Size.fromHeight(d.pSH(105)),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: d.pSH(10)),
                        // height: d.pSH(70),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                  color:
                                                      AppColors.whiteColorOne,
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
                                                  color:
                                                      AppColors.whiteColorOne,
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
                                                  color:
                                                      AppColors.whiteColorOne,
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
                                                  color:
                                                      AppColors.whiteColorOne,
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
                              ),*/
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
                        final timestamp = message['timestamp'] as Timestamp;
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
                                      backgroundImage:
                                          NetworkImage(userProfile.photoUrl),
                                    ),
                              title: Text(
                                  '${userProfile.firstName} ${userProfile.lastName}'),
                              //   subtitle: Text(
                              //   'Unread messages: ${isRead ? 0 : 1}',
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
    );
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
