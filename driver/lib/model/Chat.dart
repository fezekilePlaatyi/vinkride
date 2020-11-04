import 'package:driver/utils/Utils.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class Chat {
  String id = Utils.AUTH_USER.uid;
  var now = new DateTime.now();

  sendMessage(String receiver, String content, String attachment,
      Map mapCoordinates) async {
    Map _message = {
      'sender': id,
      'receiver': receiver,
      'content': content,
      'is_read': false,
      'created_at': now
    };
    if (attachment != '') {
      _message['attachment'] = attachment;
    }

    if (mapCoordinates.isNotEmpty) {
      _message['mapCoordinates'] = mapCoordinates;
    }

    var messageArr = [_message];

    await Utils.DRIVER_COLLECTION
        .doc(this.id)
        .collection('chats')
        .doc(receiver)
        .update({
      'last_date': Utils.NOW,
      'text_messages': FieldValue.arrayUnion(messageArr)
    }).catchError((err) async {
      if (err.code == 'not-found') {
        await Utils.DRIVER_COLLECTION
            .doc(this.id)
            .collection('chats')
            .doc(receiver)
            .set({
          'last_date': Utils.NOW,
          'text_messages': FieldValue.arrayUnion(messageArr)
        });
      }
    });

    await Utils.PASSENGER_COLLECTION
        .doc(receiver)
        .collection('chats')
        .doc(this.id)
        .update({
      'last_date': Utils.NOW,
      'text_messages': FieldValue.arrayUnion(messageArr)
    }).catchError((err) async {
      if (err.code == 'not-found') {
        await Utils.PASSENGER_COLLECTION
            .doc(receiver)
            .collection('chats')
            .doc(this.id)
            .set({
          'last_date': Utils.NOW,
          'text_messages': FieldValue.arrayUnion(messageArr)
        });
      }
    });
  }

  loadMessages(String receiver) {
    return Utils.DRIVER_COLLECTION
        .doc(this.id)
        .collection('chats')
        .doc(receiver.trim())
        .snapshots();
  }

  loadChatHistoryList() {
    try {
      return Utils.DRIVER_COLLECTION
          .doc(this.id)
          .collection('chats')
          .orderBy('last_date', descending: true)
          .snapshots();
    } catch (e) {
      print(e);
    }
  }

  markAsRead(sender) async {
    try {
      await Utils.DRIVER_COLLECTION
          .doc(id)
          .collection('chats')
          .doc(sender)
          .get()
          .then((res) async {
        if (res.exists) {
          var doc = res.data();
          List text_messages = doc['text_messages'];
          text_messages.forEach((message) {
            if (message['receiver'] == id) {
              var index = text_messages.indexOf(message);
              text_messages[index]['is_read'] = true;
            }
          });

          await Utils.DRIVER_COLLECTION
              .doc(id)
              .collection('chats')
              .doc(sender)
              .update({'text_messages': text_messages});
        }
      });

      await Utils.PASSENGER_COLLECTION
          .doc(sender)
          .collection('chats')
          .doc(id)
          .get()
          .then((res) async {
        if (res.exists) {
          var doc = res.data();
          List text_messages = doc['text_messages'];
          text_messages.forEach((message) {
            if (message['receiver'] == id) {
              var index = text_messages.indexOf(message);
              text_messages[index]['is_read'] = true;
            }
          });

          await Utils.PASSENGER_COLLECTION
              .doc(sender)
              .collection('chats')
              .doc(sender)
              .update({'text_messages': text_messages});
        }
      });
    } catch (e) {}
  }
}
