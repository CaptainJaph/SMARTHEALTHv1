


import 'package:flutter/material.dart';

import '../../../app_colors.dart';
import '../../../constant.dart';

class ChatRoomAppBar extends StatelessWidget {
  const ChatRoomAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: d.pSH(3)),

      color: AppColors.blackColorTwo,
      width: double.infinity,
      height: d.pSH(80),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context ).pop();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.greenColorOne,
              )),
          SizedBox(width: d.pSW(1),),
          CircleAvatar(
            radius: d.pSH(25),
            backgroundImage: AssetImage(
              'assets/images/$profileImagePng',
            ),
          ),
          SizedBox(width: d.pSW(2),),

          Expanded(
            flex: 3,
            child: SizedBox(
              width: d.pSW(300),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. Queen Elizabeth Atobam Nimo Kawku",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        height: d.pSH(1),
                        color: AppColors.blackColorOne,
                        fontSize: d.pSH(18)),
                  ),
                  Text(
                    "Neurologist",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        height: d.pSH(1),
                        overflow: TextOverflow.ellipsis,
                        color: AppColors.blackColorOne,
                        fontSize: d.pSH(13)),
                  ),
                ],
              ),
            ),
          ),
          const  Spacer(),
          Text(
            "Online",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                height: d.pSH(1),
                color: AppColors.greenColorOne,
                fontSize: d.pSH(12)),
          ),
        ],
      ),
    );
  }
}
