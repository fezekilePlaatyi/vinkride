import 'package:passenger/widgets/singleNotification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passenger/models/Notifications.dart' as Notifier;

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Notifier.Notifications notification = new Notifier.Notifications();
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    String currentUserId = auth.currentUser.uid;
    return Scaffold(
        backgroundColor: Color(0xFFFCF9F9),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCF9F9),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Color(0xFFCC1718),
              size: 30.0,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            "Notfications",
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: notification.getNotificationsByUserId(currentUserId),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.data.docs.length > 0) {
                  return Container(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView.builder(
                      itemCount: snapshot.data.size,
                      itemBuilder: (
                        context,
                        index,
                      ) {
                        var notificationData = snapshot.data.docs[index].data();
                        var notificationId = snapshot.data.docs[index].id;

                        return SingleNotification(
                            notificationData: notificationData,
                            notificationId: notificationId);
                      },
                    ),
                  );
                } else {
                  return Container(
                      alignment: Alignment(-0.9, -0.9),
                      child: Text(
                        "No notifications :)",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      ));
                }
              }
            }));
  }
}
