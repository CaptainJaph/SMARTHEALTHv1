import 'package:flutter/material.dart';
import '../../../app_colors.dart';
import '../../../constant.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    Key? key,
    required this.text,
    required this.fromMe,
  }) : super(key: key);

  final bool fromMe;
  final String text;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    d.init(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.only(top: d.pSH(3)),
          key: UniqueKey(),
          margin: const EdgeInsets.symmetric(vertical: 5),
          alignment:
              widget.fromMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: widget.fromMe
                ? const EdgeInsets.only(right: 5)
                : const EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: widget.fromMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: widget.fromMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    !widget.fromMe
                        ? const SizedBox()
                        : const Flexible(child: SizedBox()),

                    /////Message Card //////
                    Flexible(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(9),
                                topRight: const Radius.circular(9),
                                bottomLeft:
                                    Radius.circular(widget.fromMe ? 9 : 0),
                                bottomRight:
                                    Radius.circular(widget.fromMe ? 0 : 9)),
                            color: widget.fromMe
                                ? AppColors.blackColorThree
                                : AppColors.greenColorTwo),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ////////////////////////////////////////////////////////////////////////////////
                            ////////////////////////////////// Text Message /////////////////////////////////
                            Text(
                              widget.text,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: d.pSH(16),
                                  color: !widget.fromMe
                                      ? AppColors.whiteColorOne
                                      : AppColors.blackColorOne),
                            ),
                          ],
                        ),
                      ),
                    ),
                    widget.fromMe
                        ? const SizedBox()
                        : const Flexible(child: SizedBox())
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
