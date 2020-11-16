import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/animations/fadeAnimation.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/services/PlaceService.dart';
import 'package:passenger/widgets/AddressSearch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class CreateTrip extends StatefulWidget {
  final String feedType;
  const CreateTrip({this.feedType});
  @override
  _CreateTripPageState createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTrip> {
  GlobalKey<FormState> _key = new GlobalKey();

  DateTime pickedDate;
  TimeOfDay time = TimeOfDay.now();
  bool isLoading = false;
  String theFeedType;

  final departureEditingController = TextEditingController();
  final destinationEditingController = TextEditingController();
  final tripFareEditingController = TextEditingController();
  final vehicleNumberOfSeatsEditingController = TextEditingController();
  final vehicleDescriptionEditingController = TextEditingController();

  @override
  void dispose() {
    departureEditingController.dispose();
    destinationEditingController.dispose();
    tripFareEditingController.dispose();
    vehicleNumberOfSeatsEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  bool validate = false;

  @override
  Widget build(BuildContext context) {
    theFeedType = widget.feedType;

    return Scaffold(
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
        centerTitle: true,
        title: Text(
          'Add ${theFeedType == 'rideOffer' ? 'Ride Offer' : 'Inter-Interest'} ',
          style: TextStyle(
            color: Color(0xFF1B1B1B),
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(15.0),
          child: new Form(
            key: _key,
            autovalidateMode: AutovalidateMode.always,
            child: FormUI(theFeedType),
          ),
        ),
      ),
    );
  }

  Widget FormUI(String theFeedType) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new FadeAnimation(
          1,
          TextFormField(
            controller: departureEditingController,
            readOnly: true,
            onTap: () async {
              // generate a new token here
              final sessionToken = Uuid().v4();
              final Suggestion result = await showSearch(
                context: context,
                delegate: AddressSearch(sessionToken),
              );
              // This will change the text displayed in the TextField
              if (result != null) {
                final placeDetails = await PlaceApiProvider(sessionToken)
                    .getPlaceDetailFromId(result.placeId);

                if (placeDetails.city != null) {
                  setState(() {
                    departureEditingController.text = placeDetails.city;
                  });
                }
              }
            },
            decoration: formDecor('Departure'),
            style: textStyle(16, vinkBlack),
            maxLength: 32,
            validator: validateName,
          ),
        ),
        new FadeAnimation(
          1.2,
          TextFormField(
            decoration: formDecor('Destination'),
            style: textStyle(16, vinkBlack),
            controller: destinationEditingController,
            readOnly: true,
            onTap: () async {
              // generate a new token here
              final sessionToken = Uuid().v4();
              final Suggestion result = await showSearch(
                context: context,
                delegate: AddressSearch(sessionToken),
              );
              // This will change the text displayed in the TextField
              if (result != null) {
                final placeDetails = await PlaceApiProvider(sessionToken)
                    .getPlaceDetailFromId(result.placeId);

                if (placeDetails.city != null) {
                  setState(() {
                    destinationEditingController.text = placeDetails.city;
                  });
                }
              }
            },
            maxLength: 32,
            validator: validateName,
          ),
        ),
        FadeAnimation(
          1.4,
          ListTile(
            leading: const Icon(
              Icons.monetization_on,
              color: Color(0xFFCC1718),
              size: 25.0,
            ),
            title: new TextFormField(
              controller: tripFareEditingController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: formDecor(
                  '${theFeedType == 'rideOffer' ? 'Trip fare' : 'How much you will to pay'}'),
              style: textStyle(16, vinkBlack),
              validator: validateTripAmount,
            ),
          ),
        ),
        theFeedType != 'riderOffer'
            ? FadeAnimation(
                1.4,
                ListTile(
                  leading: const Icon(
                    Icons.format_list_numbered_rtl,
                    color: Color(0xFFCC1718),
                    size: 25.0,
                  ),
                  title: new TextFormField(
                    controller: vehicleNumberOfSeatsEditingController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(2),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: formDecor('Number Of Seats'),
                    style: textStyle(16, vinkBlack),
                    validator: validateNumberOfSeats,
                  ),
                ),
              )
            : '',
        FadeAnimation(
          1.6,
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              "${pickedDate.day} - ${pickedDate.month} - ${pickedDate.year}",
              style: textStyle(16, vinkBlack),
            ),
            leading: const Icon(
              Icons.date_range,
              color: Color(0xFFCC1718),
              size: 25.0,
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: _pickDate,
          ),
        ),
        FadeAnimation(
          1.8,
          ListTile(
            contentPadding: const EdgeInsets.all(0),
            title: Text(
              "${time.hour}:${time.minute}",
              style: textStyle(16, vinkBlack),
            ),
            leading: const Icon(
              Icons.timer,
              color: Color(0xFFCC1718),
              size: 25.0,
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
            onTap: _pickTime,
          ),
        ),
        theFeedType != 'riderOffer'
            ? FadeAnimation(
                1.8,
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: const Icon(
                    Icons.directions_car,
                    color: Color(0xFFCC1718),
                    size: 25.0,
                  ),
                  title: new TextFormField(
                    controller: vehicleDescriptionEditingController,
                    autocorrect: true,
                    decoration: formDecor('Describe your vehicle'),
                    style: textStyle(16, vinkBlack),
                    validator: validateAlphaNumeric,
                  ),
                ),
              )
            : '',
        new SizedBox(height: 15.0),
        FadeAnimation(
          2,
          RaisedButton(
            color: vinkBlack,
            child: GestureDetector(
              child: Text('Add', style: textStyle(16, Colors.white)),
            ),
            shape: darkButton(),
            padding: const EdgeInsets.all(15),
            onPressed: () {
              _postTrip();
            },
          ),
        ),
      ],
    );
  }

  String validateName(String value) {
    String patttern = r'(^[a-zA-Z ]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Name is Required";
    } else if (value.length > 32) {
      return "Max length is 32 characters";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String validateAlphaNumeric(String value) {
    if (value.length == 0) {
      return "Value is Required";
    } else if (value.length > 32) {
      return "Max length is 32 characters";
    }
    return null;
  }

  String validateTripAmount(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "The trip fare is Required";
    } else if (!regExp.hasMatch(value)) {
      return "The trip fare must be digits";
    }
    return null;
  }

  String validateNumberOfSeats(String value) {
    String patttern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return "Enter number of your cars seats is Required";
    } else if (!regExp.hasMatch(value)) {
      return "The number of seats must be digits";
    }
    return null;
  }

  _postTrip() {
    if (_key.currentState.validate()) {
      // No any error in validation
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUserId = auth.currentUser.uid;
      var feedType = "rideOffer";
      theFeedType = feedType;

      Feeds feed = new Feeds();

      isLoading = true;
      _loader();

      var departingDateTime = DateTime(pickedDate.year, pickedDate.month,
          pickedDate.day, time.hour, time.minute);

      Map<String, dynamic> newFeedData = feedType == 'rideOffer'
          ? {
              'date_created': FieldValue.serverTimestamp(),
              'date_updated': FieldValue.serverTimestamp(),
              'departure_datetime': departingDateTime,
              'departure_point': departureEditingController.text,
              'destination_point': destinationEditingController.text,
              'feed_status': 'open',
              'feed_type': feedType,
              'vehicle_seats_number':
                  vehicleNumberOfSeatsEditingController.text,
              'vehicle_description': vehicleDescriptionEditingController.text,
              'sender_uid': currentUserId,
              'is_alarm_sent': 'false',
              'trip_fare': tripFareEditingController.text,
            }
          : {
              'date_created': FieldValue.serverTimestamp(),
              'date_updated': FieldValue.serverTimestamp(),
              'departure_datetime': departingDateTime,
              'departure_point': departureEditingController.text,
              'destination_point': destinationEditingController.text,
              'feed_status': 'open',
              'feed_type': feedType,
              'sender_uid': currentUserId,
              'trip_fare': tripFareEditingController.text,
            };

      try {
        feed.addFeed(newFeedData).then((results) {
          print("Results - Document Id $results");
          setState(() {
            isLoading = false;
            Navigator.of(context).pop();
            _loader();
          });
        });
      } catch (e) {
        print("Error building and sending Trip Data $e");
      }
      _key.currentState.save();
    } else {
      // validation error
      setState(() {
        validate = true;
      });
    }
  }

  _loader() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          subtitle: isLoading
              ? Container(
                  height: 50.0,
                  width: 50.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Text(
                  'Successfuly added ${theFeedType == 'a offer' ? 'Trip' : 'an Inter-Interest'}'),
        ),
        actions: <Widget>[
          isLoading
              ? SizedBox.shrink()
              : FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("Ok"),
                )
        ],
      ),
    );
  }

  void _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    setState(() {
      if (date != null) {
        pickedDate = date;
      }
    });
  }

  void _pickTime() async {
    TimeOfDay theTime = await showTimePicker(
      context: context,
      initialTime: time,
    );

    setState(() {
      if (theTime != null) {
        time = theTime;
      }
    });
  }
}
