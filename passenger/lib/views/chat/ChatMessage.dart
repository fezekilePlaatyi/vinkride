import 'dart:io';

import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/utils/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/models/Chat.dart';
import 'package:passenger/models/DynamicLinks.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/User.dart';
import 'package:passenger/services/DeviceLocation.dart';

class ChatMessage extends StatefulWidget {
  final String userId;
  const ChatMessage({@required this.userId});
  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  Chat _chat = new Chat();
  User _user = new User();
  var userId = '';
  String currentUserId = Utils.AUTH_USER.uid;
  Radius _chatBubbleRadius = Radius.circular(15.0);
  TextEditingController _messageController = new TextEditingController();
  String attachment = '';
  Map mapCoordinates = {};
  FocusNode textFieldFocus = FocusNode();
  bool isWriting = false;
  bool showEmojiPicker = false;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    userId = widget.userId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _customAppBar(),
      body: StreamBuilder(
        stream: _chat.loadMessages(userId),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            bool docsExists = snapshot.data.exists;
            var chatDoc = snapshot.data.data();
            List messages = [];
            if (docsExists) {
              if (chatDoc.containsKey('text_messages')) {
                messages = chatDoc['text_messages'];
                messages.sort((a, b) {
                  var first = a['created_at'].toDate();
                  var second = b['created_at'].toDate();
                  return second.compareTo(first);
                });
                // setState(() {});
              }
            }

            return Column(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: docsExists
                        ? ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              Map message = messages[index];
                              Map messageToCompare = messages[index > 0
                                  ? (index < messages.length - 1
                                      ? index + 1
                                      : index)
                                  : 0];

                              return Column(
                                children: [
                                  messages.length > 1
                                      ? (index == messages.length - 1
                                          ? _timeViewStyle(
                                              message['created_at'])
                                          : _dateView(
                                              message, messageToCompare))
                                      : _timeViewStyle(message['created_at']),
                                  message['sender'] == currentUserId
                                      ? _chatBubbleRight(
                                          message, messageToCompare)
                                      : _chatBubbleLeft(
                                          message, messageToCompare)
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Container(
                              child: Text(
                                'Start a chat',
                                style: TextStyle(
                                    fontSize: 25.0,
                                    color: Colors.black26,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                  ),
                ),
                _messageSender(),
                showEmojiPicker
                    ? Container(
                        child: _emojiContainer(),
                      )
                    : Container()
              ],
            );
          }
          return Container();
        },
      ),
    );
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

  _customAppBar() {
    return PreferredSize(
      child: Container(
        width: MediaQuery.of(context).size.width * .75,
        color: vinkRed,
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StreamBuilder(
                stream: _user.getDriver(userId),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapShot) {
                  if (snapShot.hasData) {
                    var user = snapShot.data.data();
                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_outlined),
                            onPressed: () => Navigator.of(context).pop(),
                            color: Colors.white,
                          ),
                          SizedBox(width: 1.2),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 24.0,
                            child: ClipOval(
                              child: _profilePic(user),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            user['name'].toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(50.0),
    );
  }

  _dateView(message, messageToCompare) {
    if (dateTime(message['created_at']) !=
        dateTime(messageToCompare['created_at'])) {
      return _timeViewStyle(message['created_at']);
    }
    return SizedBox.shrink();
  }

  _timeViewStyle(Timestamp time) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dateInWords(time),
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _messageSender() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.attach_file_outlined,
              color: vinkRed,
            ),
            onPressed: () {
              _openImageModal();
            },
          ),
          IconButton(
            icon: Icon(
              showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
              color: vinkRed,
            ),
            onPressed: () {
              _toggleEmojiContainer();
              showEmojiPicker:
              _setWriting(false);
            },
          ),
          Expanded(
            child: TextField(
              focusNode: textFieldFocus,
              onTap: () => showEmojiPicker ? _toggleEmojiContainer() : null,
              onChanged: (value) {
                (value.length > 0 && value.trim() != null)
                    ? _setWriting(true)
                    : _setWriting(false);
              },
              textCapitalization: TextCapitalization.sentences,
              controller: _messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send_outlined,
              color: vinkRed,
            ),
            onPressed: () => {_sendMessage()},
          )
        ],
      ),
    );
  }

  _sendMessage() {
    String content = _messageController.text;
    if ((content != null && content != '') ||
        attachment != '' ||
        mapCoordinates.isNotEmpty) {
      _chat
          .sendMessage(userId, content, attachment, mapCoordinates)
          .then((value) {
        _messageController.text = '';
        attachment = '';
        mapCoordinates = {};
      });
    }
  }

  void _openImageModal() {
    const _iconSize = 35.00;
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 25.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  color: vinkRed,
                  iconSize: _iconSize,
                  icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                  onPressed: () => _getCurrentLocation(),
                ),
                IconButton(
                  color: vinkRed,
                  iconSize: _iconSize,
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => _selectImage('CAPTURE'),
                ),
                IconButton(
                  color: vinkRed,
                  iconSize: _iconSize,
                  icon: Icon(Icons.add_photo_alternate),
                  onPressed: () => _selectImage('GALLERY'),
                ),
              ],
            ),
          );
        });
  }

  _selectImage(String actionType) async {
    if (actionType == 'CAPTURE') {
      try {
        _image = await ImagePicker.pickImage(source: ImageSource.camera);
      } catch (e) {
        print(e);
      }
    } else {
      try {
        _image = await ImagePicker.pickImage(source: ImageSource.gallery);
      } catch (e) {
        print(e);
      }
    }

    if (_image != null) {
      Routes.navigator.pushNamed(Routes.previewAttachment,
          arguments: PreviewAttachmentArguments(
              userId: userId, image: _image, message: _messageController.text));
    }
  }

  Widget _chatBubbleRight(message, messageToCompare) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .75,
          ),
          margin: EdgeInsets.only(
            top: 2.0,
            bottom: 2.0,
            left: 80.0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            color: vinkRed,
            borderRadius: BorderRadius.only(
                // topRight: messageToCompare['receiver'] != message['receiver']
                //     ? Radius.circular(0)
                //     : _chatBubbleRadius,
                topLeft: _chatBubbleRadius,
                bottomLeft: _chatBubbleRadius,
                bottomRight: _chatBubbleRadius),
          ),
          child: _message(message),
        ),
      ],
    );
  }

  Widget _chatBubbleLeft(message, messageToCompare) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .75,
          ),
          margin: EdgeInsets.only(
            top: 2.0,
            bottom: 2.0,
            right: 80.0,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.only(
              // topLeft: messageToCompare['receiver'] != message['receiver']
              //     ? Radius.circular(0)
              //     : _chatBubbleRadius,
              topRight: _chatBubbleRadius,
              bottomLeft: _chatBubbleRadius,
              bottomRight: _chatBubbleRadius,
            ),
          ),
          child: _message(message),
        ),
      ],
    );
  }

  Widget _message(Map message) {
    bool hasAttachment = message.containsKey('attachment');
    bool hasMapCoordinates = message.containsKey('mapCoordinates');
    return Wrap(
      direction: Axis.horizontal,
      children: <Widget>[
        hasAttachment
            ? _chatAttachment(message['attachment'])
            : SizedBox.shrink(),
        hasMapCoordinates
            ? _mapView(message['mapCoordinates'])
            : SizedBox.shrink(),
        hasAttachment || hasMapCoordinates
            ? SizedBox(height: 5.0)
            : SizedBox.shrink(),
        Text(
          message['content'].toString(),
          style: _convoStyle(),
        ),
        SizedBox(width: 5.0),
        Text(
          hoursMinutes(message['created_at']),
          style: _timeStyle(),
        ),
      ],
    );
  }

  Widget _chatAttachment(attachment) {
    return Container(
      height: 250.0,
      width: 250.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: GestureDetector(
          onTap: () {
            print(attachment);
          },
          child: Image.network(
            attachment,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _mapView(coordinates) {
    return Container(
      height: 250.0,
      width: 250.0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: GoogleMap(
          onTap: (initialCameraPosition) {
            DynamicLinks links = new DynamicLinks();
            var latitude = initialCameraPosition.latitude;
            var longitude = initialCameraPosition.longitude;
            var url = Constants.GOOGLE_MAPS_URL + "${latitude}, ${longitude}";
            links.createDynamicLink(url).then((response) {
              var url = response['shortLink'];
              Utils.launchURL(url);
            });
          },
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          zoomGesturesEnabled: false,
          compassEnabled: false,
          scrollGesturesEnabled: false,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            target: LatLng(coordinates['latitude'], coordinates['longitude']),
            zoom: 15.0,
          ),
        ),
      ),
    );
  }

  TextStyle _timeStyle() {
    return TextStyle(
      color: Colors.white38,
      fontSize: 12.0,
    );
  }

  TextStyle _convoStyle() {
    return TextStyle(
      color: Colors.white,
      fontSize: 16.0,
    );
  }

  _toggleEmojiContainer() {
    setState(() {
      showEmojiPicker = !showEmojiPicker;
    });
    showEmojiPicker ? textFieldFocus.unfocus() : textFieldFocus.requestFocus();
  }

  _setWriting(bool val) {
    setState(() {
      isWriting = true;
    });
  }

  Widget _emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: vinkRed,
      selectedCategory: Category.SMILEYS,
      rows: 4,
      columns: 8,
      onEmojiSelected: (emoji, category) {
        _setWriting(true);
        _messageController.text += emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

  _getCurrentLocation() {
    DeviceLocation deviceLocation = new DeviceLocation();
    var position = deviceLocation.getCurrentPosition();
    position.then((latLong) {
      mapCoordinates = {
        'latitude': latLong.latitude,
        'longitude': latLong.longitude
      };
      _messageController.text = '';
      _image = null;
      _sendMessage();
    });
  }

  Future _map(coordinates) {
    DynamicLinks links = new DynamicLinks();
    var url = Constants.GOOGLE_MAPS_URL +
        "${coordinates['latitude']}, ${coordinates['longitude']}";
    return links.createDynamicLink(url);
  }
}
