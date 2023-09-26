import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../app_colors.dart';
import '../../../constant.dart';

class ChatroomBottomSheet extends StatelessWidget {
  const ChatroomBottomSheet({
    super.key,
    required this.messageController,
  });

  final TextEditingController messageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: d.pSH(10), vertical: d.pSH(3)),
      color: AppColors.whiteColorTwo,
      width: double.infinity,
      height: d.pSH(80),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: d.pSH(3)),
            child: SvgPicture.asset(
              'assets/icons/attach_file.svg',
              width: d.pSW(24),
              height: d.pSH(24),
            ),
          ),
          Expanded(
            child: Card(
                color: AppColors.whiteColorOne,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(d.pSH(5))),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: d.pSH(10), vertical: d.pSH(3)),
                  child: TextFormField(
                    controller: messageController,
                    decoration: const InputDecoration(
                        hintText: "Type message here",
                        border: InputBorder.none),
                  ),
                )),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: d.pSH(3)),
            child: SvgPicture.asset(
              'assets/icons/camera.svg',
              width: d.pSW(24),
              height: d.pSH(24),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: d.pSH(3)),
            child: SvgPicture.asset(
              'assets/icons/microphone.svg',
              width: d.pSW(24),
              height: d.pSH(24),
            ),
          ),
        ],
      ),
    );
  }
}
