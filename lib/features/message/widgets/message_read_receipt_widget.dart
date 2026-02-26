import 'package:flutter/material.dart';

class MessageReadReceiptWidget extends StatelessWidget {
  final bool isRead;
  final bool isSent;

  const MessageReadReceiptWidget({
    super.key,
    required this.isRead,
    required this.isSent,
  });

  @override
  Widget build(BuildContext context) {
    if (!isSent) {
      return const SizedBox.shrink();
    }

    if (isRead) {
      return Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Icon(
          Icons.done_all,
          size: 14,
          color: Theme.of(context).primaryColor,
        ),
      );
    } else {
      return const Padding(
        padding: EdgeInsets.only(left: 4.0),
        child: Icon(
          Icons.done,
          size: 14,
          color: Colors.grey,
        ),
      );
    }
  }
}
