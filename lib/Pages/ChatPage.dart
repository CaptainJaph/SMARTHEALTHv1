import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_app/Models/ScopedModel.dart';
import 'package:health_app/Models/User.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatPage extends StatefulWidget {
  final UserProfile receiverId;

  ChatPage({required this.receiverId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ScrollController _scrollController = ScrollController();
  //DateTime? lastTimestamp;
  @override
  Widget build(BuildContext context) {
    debugPrint(ScopedModel.of<MyScopedModel>(context).authenticatdUser!.id +
        " okay" +
        widget.receiverId.id);
    return Scaffold(
        appBar: AppBar(
          title: widget.receiverId.role == "doctor"
              ? Row(
                  children: [
                    widget.receiverId.photoUrl != null ||
                            widget.receiverId.photoUrl != ""
                        ? CircleAvatar(
                            // Display a placeholder with the first letter of the first name
                            child: Text(
                                widget.receiverId.firstName.substring(0, 1)),
                          )
                        : CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.receiverId.photoUrl),
                          ),
                    SizedBox(
                      width: 8,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. " +
                                widget.receiverId.firstName +
                                " " +
                                widget.receiverId.lastName,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(widget.receiverId.category,
                              style: TextStyle(fontSize: 16))
                        ])
                  ],
                )
              : Text(widget.receiverId.firstName +
                  " " +
                  widget.receiverId.lastName),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/images/wallpaper.jpg'), // Replace with your image path
              fit: BoxFit
                  .cover, // Adjust the fit as needed (cover, contain, etc.)
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('users')
                      .doc(ScopedModel.of<MyScopedModel>(context)
                          .authenticatdUser!
                          .id)
                      .collection('messages')
                      .orderBy('timestamp')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text("No messages yet"));
                    }
                    final messages = snapshot.data!.docs;
                    List<Widget> messageWidgets = [];

                    /* if (messages.isNotEmpty) {
                  lastTimestamp = messages.last['timestamp']
                      .toDate(); // Update lastTimestamp
                }*/

                    for (var message in messages) {
                      if (message['senderId'] == widget.receiverId.id ||
                          message['receiverId'] == widget.receiverId.id) {
                        final messageText = message['text'];
                        final senderId = message['senderId'];
                        final timestamp = message['timestamp'];
                        // Add logic to determine if the message is read
                        final isRead = message['status'] == 'read';

                        final messageWidget = MessageWidget(
                          text: messageText,
                          isSender: senderId ==
                              ScopedModel.of<MyScopedModel>(context)
                                  .authenticatdUser!
                                  .id,
                          // isRead: isRead,
                        );
                        messageWidgets.add(messageWidget);
                      }
                    }

                    // Scroll to the end of the list
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });

                    return ListView(
                      controller: _scrollController,
                      children: messageWidgets,
                    );
                  },
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () async {
                            String msg = _messageController.text;
                            _messageController.clear();

                            final senderId =
                                ScopedModel.of<MyScopedModel>(context)
                                    .authenticatdUser!
                                    .id;
                            final receiverId = widget.receiverId
                                .id; // Assuming widget.userProfile.id is the receiver's ID

// Reference the sender's message subcollection
                            CollectionReference senderMessagesCollection =
                                _firestore
                                    .collection('users')
                                    .doc(senderId)
                                    .collection('messages');

// Reference the receiver's message subcollection
                            CollectionReference receiverMessagesCollection =
                                _firestore
                                    .collection('users')
                                    .doc(receiverId)
                                    .collection('messages');

// Create or update the sender's document if it doesn't exist
                            await _firestore.collection('users').doc(senderId).set(
                                {
                                  // Add user data as needed
                                },
                                SetOptions(
                                    merge:
                                        true)); // Use SetOptions to merge data if the document exists

// Create or update the receiver's document if it doesn't exist
                            await _firestore
                                .collection('users')
                                .doc(receiverId)
                                .set(
                                    {
                                  // Add user data as needed
                                },
                                    SetOptions(
                                        merge:
                                            true)); // Use SetOptions to merge data if the document exists

// Add the message to the sender's subcollection
                            await senderMessagesCollection.add({
                              'text': msg,
                              'senderId': senderId,
                              'receiverId': receiverId,
                              'timestamp': FieldValue.serverTimestamp(),
                              'status': 'sent',
                            });

// Add the message to the receiver's subcollection
                            await receiverMessagesCollection.add({
                              'text': msg,
                              'senderId': senderId,
                              'receiverId': receiverId,
                              'timestamp': FieldValue.serverTimestamp(),
                              'status': 'sent',
                            });
                          },
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}

class MessageWidget extends StatelessWidget {
  final String text;
  final bool isSender; // Indicates whether the message is sent by the sender

  MessageWidget({
    required this.text,
    this.isSender = true, // Default to sender for simplicity
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSender ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
            bottomLeft: isSender ? Radius.circular(16.0) : Radius.zero,
            bottomRight: isSender ? Radius.zero : Radius.circular(16.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            text,
            style: TextStyle(
              color: isSender ? Colors.white : Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
