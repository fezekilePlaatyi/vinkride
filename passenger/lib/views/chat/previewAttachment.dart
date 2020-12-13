import 'dart:io';

import 'package:passenger/utils/Utils.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:passenger/models/Chat.dart';
import 'package:passenger/models/Helper.dart';

class PreviewAttachment extends StatefulWidget {
  final File image;
  final String message;
  final String userId;
  const PreviewAttachment(
      {@required this.userId, @required this.image, @required this.message});
  @override
  _PreviewAttachmentState createState() => _PreviewAttachmentState();
}

class _PreviewAttachmentState extends State<PreviewAttachment> {
  File _image;
  TextEditingController _messageController = new TextEditingController();
  Chat _chat = new Chat();
  FocusNode textFieldFocus = FocusNode();
  bool isWriting = false;
  bool showEmojiPicker = false;
  bool _isUploading = true;
  String userId, message, attachment;
  Map mapCoordinates = {};
  var uploadProgress = 0.00;

  @override
  void initState() {
    _image = widget.image;
    _messageController.text = widget.message;
    userId = widget.userId;
    _sendImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF9F9),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Color(0xFFCC1718),
            size: 30.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '',
        ),
        actions: [
          IconButton(
            onPressed: () => {},
            icon: Icon(
              Icons.refresh,
              size: 30,
              color: Color(0xFFCC1718),
            ),
          ),
        ],
      ),
      body: _scaffoldBody(),
    );
  }

  Widget _scaffoldBody() {
    return Column(
      children: [
        Expanded(
          child: Container(
            child: Center(
              child: Image.file(_image),
            ),
          ),
        ),
        Container(
          child: LinearProgressIndicator(
            backgroundColor: Colors.white,
            valueColor: new AlwaysStoppedAnimation<Color>(vinkRed),
            value: uploadProgress,
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

  Widget _messageSender() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
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
              color: _isUploading ? Colors.black45 : vinkRed,
            ),
            onPressed: () => {_isUploading ? null : _sendMessage()},
          )
        ],
      ),
    );
  }

  _sendMessage() {
    String content = _messageController.text;
    if (content != null && content != '') {
      _chat
          .sendMessage(userId, content, attachment, mapCoordinates)
          .then((value) {
        _messageController.text = '';
        Navigator.of(context).pop();
      });
    }
  }

  _sendImage() async {
    Reference storage = Utils.CHAT_FILES_STORAGE;
    UploadTask uploadTask = storage.putFile(_image);
    uploadTask.events.listen((event) {
      setState(() {
        uploadProgress =
            ((event.snapshot.bytesTransferred / event.snapshot.totalByteCount) *
                100);
        print(uploadProgress);
      });
    });
    await uploadTask.whenComplete(() {
      print('uploadCompleted');
      storage.getDownloadURL().then((value) {
        print(value);
        setState(() {
          attachment = value.toString();
          _isUploading = false;
        });
      });
    });
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
}
