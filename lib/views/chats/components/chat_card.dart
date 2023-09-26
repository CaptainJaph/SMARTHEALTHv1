import 'package:flutter/material.dart';
import 'package:health_app/views/chats/chatroom.dart';
import 'package:intl/intl.dart';

import '../../../app_colors.dart';
import '../../../constant.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChatRoomPage(),
            ));
      },
      child: Container(
        // height: d.pSH(100),
        padding: EdgeInsets.symmetric(
          vertical: d.pSH(10),
          horizontal: d.pSH(10),
        ),
        margin: EdgeInsets.only(
          top: d.pSH(5),
          // horizontal: d.pSH(10),
        ),
        decoration: BoxDecoration(
            color: AppColors.whiteColorOne,
            border: Border(
                bottom: BorderSide(
                    width: 0.35,
                    color: AppColors.blackColorOne.withOpacity(0.4)))),
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: d.pSH(20),
              backgroundImage: AssetImage(
                'assets/images/$profileImagePng',
              ),
            ),
            SizedBox(
              width: d.pSW(10),
            ),
            SizedBox(
              width: d.pSW(240),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. Kwasi Ansah Elizabeth",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        overflow: TextOverflow.ellipsis,
                        height: d.pSH(1),
                        color: AppColors.blackColorOne,
                        fontSize: d.pSH(18)),
                  ),
                  SizedBox(
                    height: d.pSH(5),
                  ),
                  Text(
                    "Last message here ",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        height: d.pSH(1),
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.blackColorOne,
                        fontSize: d.pSH(13)),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  DateFormat.jm().format(DateTime.now()),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      height: d.pSH(1),
                      color: AppColors.greenColorTwo,
                      fontSize: d.pSH(12)),
                ),
                SizedBox(
                  height: d.pSH(5),
                ),
                Container(
                  width: d.pSH(20),
                  height: d.pSH(20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColors.greenColorTwo,
                      borderRadius: BorderRadius.circular(d.pSH(20))),
                  child: Text(
                    "1",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        height: d.pSH(1),
                        color: AppColors.whiteColorOne,
                        fontSize: d.pSH(13)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
