import 'package:Vinkdriver/routes/routes.gr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Vinkdriver/model/Chat.dart';
import 'package:Vinkdriver/model/Helper.dart';
import 'package:Vinkdriver/model/User.dart';

class ChatHistory extends StatefulWidget {
  @override
  _ChatHistoryState createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  Chat _chat = new Chat();
  User _user = new User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFCC1719),
        elevation: 0.0,
      ),
      body: StreamBuilder(
          stream: _chat.loadChatHistoryList(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xFFCC1719),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "C h a t s",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                            child: snapshot.data.docs.length > 0
                                ? ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (
                                      context,
                                      index,
                                    ) {
                                      var userId = snapshot.data.docs[index].id;
                                      return _chatSetup(userId);
                                    },
                                  )
                                : Container(
                                    alignment: Alignment(-0.9, -0.9),
                                    child: Text(
                                      "No active chats!",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700),
                                    ))),
                      ),
                    ],
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  _chatSetup(userId) {
    return StreamBuilder(
        stream: _user.getPassenger(userId),
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot> userSnapshot) {
          if (userSnapshot.hasData) {
            var user = userSnapshot.data.data();
            return StreamBuilder(
              stream: _chat.loadMessages(userId),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> messagesSnapshot) {
                if (messagesSnapshot.hasData) {
                  var messageDoc = messagesSnapshot.data.data();
                  List messages = messageDoc['text_messages'];
                  var lastMessage = messages[messages.length - 1];
                  return Container(
                    // margin: EdgeInsets.only(
                    //     top: 5.0, bottom: 5.0, right: 5.0, left: 5.0),
                    // padding: EdgeInsets.symmetric(
                    //   horizontal: 10.0,
                    //   vertical: 7.0,
                    // ),
                    child: GestureDetector(
                      onTap: () {
                        Routes.navigator.popAndPushNamed(Routes.chatMessage,
                            arguments: userId);
                      },
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 27.0,
                                    child: ClipOval(
                                      child: SizedBox(
                                        height: 80.0,
                                        width: 80.0,
                                        child: _profilePic(user),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user['name'].toString(),
                                        style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .45,
                                        child: Text(
                                          lastMessage['content']
                                                  .toString()
                                                  .isEmpty
                                              ? 'Shared a file...'
                                              : lastMessage['content']
                                                  .toString(),
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    hoursMinutesInText(
                                        lastMessage['created_at']),
                                    style: TextStyle(
                                      color: Colors.black38,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              },
            );
          }
          return Container();
        });
  }

  _profilePic(Map user) {
    return user.containsKey('profile_pic')
        ? Image.network(
            user['profile_pic'].toString(),
            fit: BoxFit.fill,
          )
        : Image.network(
            defaultPic,
            fit: BoxFit.fill,
          );
  }

  TextStyle _textStyle() {
    return TextStyle(fontSize: 20.0);
  }
}
