import 'dart:io';

import 'package:Vinkdriver/views/animations/fadeAnimation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Vinkdriver/model/Helper.dart';
import 'package:Vinkdriver/model/User.dart';
import 'package:Vinkdriver/routes/routes.gr.dart';
import 'package:Vinkdriver/utils/Utils.dart';

class DriverForm extends StatefulWidget {
  @override
  _DriverFormState createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  String _address, _licency_copy, _phone_number;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File _image;
  var uploadProgress = 0.00;
  bool isUploading = false;
  Image _imageWidget = new Image.network(defaultPic);
  User _user = new User();

  Future<dynamic> selectImage() async {
    var selectedImage =
        await ImagePicker.pickImage(source: ImageSource.gallery);
    _image = File(selectedImage.path);
    _imageWidget = Image.memory(_image.readAsBytesSync());
    if (_image != null) {
      _uploadImage();
    }
  }

  _uploadImage() async {
    StorageUploadTask storageUploadTask = Utils.LICENCE_STORAGE.putFile(_image);

    setState(() => isUploading = true);
    storageUploadTask.events.listen((event) {
      setState(() => uploadProgress =
          (event.snapshot.bytesTransferred / event.snapshot.totalByteCount) *
              100);
    });

    await storageUploadTask.onComplete;
    Utils.LICENCE_STORAGE.getDownloadURL().then((value) {
      setState(() {
        isUploading = false;
        _licency_copy = value;
      });

      print('$isUploading  Check  $_licency_copy');
    }).catchError((err) => print(err));
  }

  Future<void> uploadUserData() async {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      if (_image != null) {
        _user.setAbout(_phone_number, _address, _licency_copy).then((value) {
          print(value);
          if (value as bool) {
            Routes.navigator.popAndPushNamed(Routes.profilePicture);
          }
        }).catchError((err) {
          errorFloatingFlushbar(err);
        });
      } else {
        errorFloatingFlushbar('Upload your Licence Copy');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets devicePadding = MediaQuery.of(context).viewPadding;
    return Padding(
      padding: devicePadding,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Image.asset(
                      'assets/images/logo.png',
                      height: 90,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        FadeAnimation(
                          1.2,
                          TextFormField(
                            style: textStyle(16, vinkBlack),
                            autocorrect: true,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: formDecor('Contact Number'),
                            onSaved: (input) => _phone_number = input,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'You will be called at some point';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                          1.4,
                          TextFormField(
                            style: textStyle(16, vinkBlack),
                            decoration: formDecor("Address"),
                            onSaved: (input) => _address = input,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Your address is important to us';
                              } else if (!isValidAddress(input)) {
                                return 'Invalid address';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 0.0,
                          child: Container(
                            height: 80,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                FadeAnimation(
                                  1.6,
                                  Row(
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            _image == null
                                                ? 'Upload your Licence copy.'
                                                : (isUploading
                                                    ? 'Upload in progress...'
                                                    : 'Done Uploading'),
                                            style: textStyle(15.0, vinkBlack),
                                          ),
                                          SizedBox(height: 10),
                                          isUploading
                                              ? Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .45,
                                                  child:
                                                      LinearProgressIndicator(
                                                    backgroundColor:
                                                        Color(0xFFB3B3B3),
                                                    value: uploadProgress,
                                                    valueColor:
                                                        new AlwaysStoppedAnimation<
                                                            Color>(vinkBlack),
                                                  ),
                                                )
                                              : SizedBox.shrink()
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                FadeAnimation(
                                  1.8,
                                  RaisedButton(
                                    color: Color(0xFF1B1B1B),
                                    child: Text(
                                      'Upload ID',
                                      style: textStyle(16, Colors.white),
                                    ),
                                    shape: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () => selectImage(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  FadeAnimation(
                    2,
                    RaisedButton(
                      color: vinkBlack,
                      child: GestureDetector(
                        child: Text(
                          'Save and continue',
                          style: textStyle(16, Colors.white),
                        ),
                      ),
                      textColor: Colors.white,
                      shape: darkButton(),
                      padding: const EdgeInsets.all(15),
                      onPressed: () => {
                        !isUploading && _image != null ? uploadUserData() : null
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
