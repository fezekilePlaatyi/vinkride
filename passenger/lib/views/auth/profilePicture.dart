import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/models/User.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/utils/Utils.dart';

// Widget to capture and crop the image
class ProfilePicture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ProfilePicture> {
  File _imageFile;

  //Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
      maxWidth: 512,
      maxHeight: 512,
      aspectRatioPresets: [CropAspectRatioPreset.square],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop it',
          toolbarColor: Color(0xFFFCF9F9),
          toolbarWidgetColor: Color(0xFF1B1B1B),
          initAspectRatio: CropAspectRatioPreset.original,
          statusBarColor: Color(0xFF1B1B1B),
          backgroundColor: Colors.white,
          activeControlsWidgetColor: Color(0xFF1B1B1B),
          dimmedLayerColor: Color(0xFFFCF9F9),
          cropFrameColor: Colors.white,
          cropGridColor: Colors.white,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        title: 'Crop it',
      ),
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  //Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      _imageFile = selected;
      _cropImage();
    });
  }

  //Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    var title = 'Profile Picture';
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Color(0xFFFCF9F9),
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
            color: Color(0xFF1B1B1B),
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFFFCF9F9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.photo_camera,
                size: 30,
                color: Color(0xFFCC1718),
              ),
              onPressed: () => _pickImage(ImageSource.camera),
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(
                Icons.photo_library,
                size: 30,
                color: Color(0xFFCC1718),
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: ListView(
        children: <Widget>[
          if (_imageFile == null) ...[
            Container(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Image.network(
                      defaultPic,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Upload Profile Picture',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                )),
          ] else if (_imageFile != null) ...[
            Container(
              padding: EdgeInsets.all(32),
              child: Image.file(_imageFile),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  color: Color(0xFF1B1B1B),
                  child: Icon(
                    Icons.crop,
                    color: Colors.white,
                  ),
                  onPressed: _cropImage,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                FlatButton(
                  color: Color(0xFF1B1B1B),
                  child: Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                  onPressed: _clear,
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Uploader(
                file: _imageFile,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;

  Uploader({Key key, this.file}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  String filePath;
  UploadTask uploadTask;
  double uploadProgress = 0;
  User _user = new User();
  bool isLoading = false;

  _startUpload() async {
    uploadTask = Utils.PROFILE_PIC_STORAGE.putFile(widget.file);
    uploadTask.events.listen((event) {
      setState(() {
        uploadProgress = (100 *
            (event.snapshot.bytesTransferred / event.snapshot.totalByteCount));
      });
    });
    await uploadTask.whenComplete(() {
      Utils.PROFILE_PIC_STORAGE.getDownloadURL().then((value) {
        setState(() {
          isLoading = true;
        });
        _user.uploadProfilePic(value).then((value) async {
          setState(() {
            isLoading = false;
          });
          if (value) {
            successFloatingFlushbar(
                'Done!!, Now Check your emails to verify your email address');
            await Future.delayed(Duration(seconds: 3));
            Routes.navigator.popAndPushNamed(Routes.loginPage);
          }
        }).catchError((err) {
          setState(() {
            isLoading = false;
          });
          errorFloatingFlushbar(err);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (uploadTask != null) {
      return isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  LinearProgressIndicator(
                    value: uploadProgress,
                    backgroundColor: vinkLightGrey,
                    valueColor: new AlwaysStoppedAnimation<Color>(vinkRed),
                  ),
                ]);
    } else {
      return FlatButton(
        color: Color(0xFF1B1B1B),
        child: Text(
          'Upload',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: _startUpload,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      );
    }
  }
}
