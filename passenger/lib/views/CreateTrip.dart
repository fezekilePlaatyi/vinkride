import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/animations/fadeAnimation.dart';
import 'package:passenger/constants.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/models/Helper.dart';
import 'package:passenger/services/PlaceService.dart';
import 'package:passenger/widgets/AddressSearch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class CreateTrip extends StatefulWidget {
  @override
  _CreateTripPageState createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTrip> {
  @override
  Widget build(BuildContext context) {
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
            'Add Ride Request',
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          child: MyCustomForm(),
        ));
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State {
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  DateTime pickedDate;
  TimeOfDay time = TimeOfDay.now();
  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeAnimation(
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter departure point.';
                    }
                    return null;
                  },
                ),
              ),
              FadeAnimation(
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
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter destination point.';
                    }
                    return null;
                  },
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
                    decoration: formDecor('How much you will to pay'),
                    style: textStyle(16, vinkBlack),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter amount you willing to pay.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              FadeAnimation(
                1.8,
                ListTile(
                  title: Text(
                      "${pickedDate.day} - ${pickedDate.month} - ${pickedDate.year}"),
                  leading:
                      const Icon(Icons.date_range, color: Color(0xFFCC1718)),
                  trailing: Icon(Icons.keyboard_arrow_down),
                  onTap: _pickDate,
                ),
              ),
              FadeAnimation(
                  2,
                  Column(children: <Widget>[
                    ListTile(
                      title: Text("${time.hour}:${time.minute}"),
                      leading:
                          const Icon(Icons.timer, color: Color(0xFFCC1718)),
                      trailing: Icon(Icons.keyboard_arrow_down),
                      onTap: _pickTime,
                    ),
                    Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 10.0),
                        child: SizedBox(
                            width: 300, // specific value
                            child: RaisedButton(
                              color: Colors.black87,
                              child: GestureDetector(
                                child: Text(
                                  'Add',
                                  style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              textColor: Colors.white,
                              shape: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.all(15),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  _postTrip();
                                }
                              },
                            ))),
                  ]))
            ]));
  }

  _postTrip() {
    // No any error in validation
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUserId = auth.currentUser.uid;
    Feeds feed = new Feeds();

    isLoading = true;
    _loader();

    var departingDateTime = DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, time.hour, time.minute);

    Map<String, dynamic> newFeedData = {
      'date_created': FieldValue.serverTimestamp(),
      'date_updated': FieldValue.serverTimestamp(),
      'departure_datetime': departingDateTime,
      'departure_point': departureEditingController.text,
      'destination_point': destinationEditingController.text,
      'feed_status': 'open',
      'feed_type': TripConst.RIDE_REQUEST,
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
              : Text('Successfuly sent request, drivers should Poke you soon!'),
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

// class _CreateTripPageState extends State {
//   GlobalKey<FormState> _key = new GlobalKey();

//   DateTime pickedDate;
//   TimeOfDay time = TimeOfDay.now();
//   bool isLoading = false;

//   final departureEditingController = TextEditingController();
//   final destinationEditingController = TextEditingController();
//   final tripFareEditingController = TextEditingController();
//   final vehicleNumberOfSeatsEditingController = TextEditingController();
//   final vehicleDescriptionEditingController = TextEditingController();

//   @override
//   void dispose() {
//     departureEditingController.dispose();
//     destinationEditingController.dispose();
//     tripFareEditingController.dispose();
//     vehicleNumberOfSeatsEditingController.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     pickedDate = DateTime.now();
//     time = TimeOfDay.now();
//   }

//   bool validate = false;

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: new Scaffold(
//         appBar: AppBar(
//           backgroundColor: Color(0xFFFCF9F9),
//           elevation: 0,
//           leading: IconButton(
//             icon: Icon(
//               Icons.chevron_left,
//               color: Color(0xFFCC1718),
//               size: 30.0,
//             ),
//             onPressed: () => Navigator.of(context).pop(),
//           ),
//           centerTitle: true,
//           title: Text(
//             'Add Ride Request',
//             style: TextStyle(
//               color: Color(0xFF1B1B1B),
//               fontFamily: 'Roboto',
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         body: SingleChildScrollView(
//           child: new Container(
//             margin: new EdgeInsets.all(15.0),
//             child: new Form(
//               key: _key,
//               autovalidateMode: AutovalidateMode.always,
//               child: FormUI(),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget FormUI() {
//     return new Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: <Widget>[
//         FadeAnimation(
//           1,
//           TextFormField(
//             controller: departureEditingController,
//             readOnly: true,
//             onTap: () async {
//               // generate a new token here
//               final sessionToken = Uuid().v4();
//               final Suggestion result = await showSearch(
//                 context: context,
//                 delegate: AddressSearch(sessionToken),
//               );
//               // This will change the text displayed in the TextField
//               if (result != null) {
//                 final placeDetails = await PlaceApiProvider(sessionToken)
//                     .getPlaceDetailFromId(result.placeId);

//                 if (placeDetails.city != null) {
//                   setState(() {
//                     departureEditingController.text = placeDetails.city;
//                   });
//                 }
//               }
//             },
//             decoration: formDecor('Departure'),
//             style: textStyle(16, vinkBlack),
//             maxLength: 32,
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter departure point.';
//               }
//               return null;
//             },
//           ),
//         ),
//         FadeAnimation(
//           1.2,
//           TextFormField(
//             decoration: formDecor('Destination'),
//             style: textStyle(16, vinkBlack),
//             controller: destinationEditingController,
//             readOnly: true,
//             onTap: () async {
//               // generate a new token here
//               final sessionToken = Uuid().v4();
//               final Suggestion result = await showSearch(
//                 context: context,
//                 delegate: AddressSearch(sessionToken),
//               );
//               // This will change the text displayed in the TextField
//               if (result != null) {
//                 final placeDetails = await PlaceApiProvider(sessionToken)
//                     .getPlaceDetailFromId(result.placeId);

//                 if (placeDetails.city != null) {
//                   setState(() {
//                     destinationEditingController.text = placeDetails.city;
//                   });
//                 }
//               }
//             },
//             maxLength: 32,
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please enter destination point.';
//               }
//               return null;
//             },
//           ),
//         ),
//         FadeAnimation(
//           1.4,
//           ListTile(
//             leading: const Icon(
//               Icons.monetization_on,
//               color: Color(0xFFCC1718),
//               size: 25.0,
//             ),
//             title: new TextFormField(
//               controller: tripFareEditingController,
//               keyboardType: TextInputType.number,
//               inputFormatters: [
//                 LengthLimitingTextInputFormatter(5),
//                 FilteringTextInputFormatter.digitsOnly
//               ],
//               decoration: formDecor('How much you will to pay'),
//               style: textStyle(16, vinkBlack),
//               validator: (value) {
//                 if (value.isEmpty) {
//                   return 'Please enter amount you willing to pay.';
//                 }
//                 return null;
//               },
//             ),
//           ),
//         ),
//         FadeAnimation(
//           1.6,
//           ListTile(
//             contentPadding: const EdgeInsets.all(0),
//             title: Text(
//               "${pickedDate.day} - ${pickedDate.month} - ${pickedDate.year}",
//               style: textStyle(16, vinkBlack),
//             ),
//             leading: const Icon(
//               Icons.date_range,
//               color: Color(0xFFCC1718),
//               size: 25.0,
//             ),
//             trailing: Icon(Icons.keyboard_arrow_down),
//             onTap: _pickDate,
//           ),
//         ),
//         FadeAnimation(
//           1.8,
//           ListTile(
//             contentPadding: const EdgeInsets.all(0),
//             title: Text(
//               "${time.hour}:${time.minute}",
//               style: textStyle(16, vinkBlack),
//             ),
//             leading: const Icon(
//               Icons.timer,
//               color: Color(0xFFCC1718),
//               size: 25.0,
//             ),
//             trailing: Icon(Icons.keyboard_arrow_down),
//             onTap: _pickTime,
//           ),
//         ),
//         FadeAnimation(
//           2,
//           RaisedButton(
//             color: vinkBlack,
//             child: GestureDetector(
//               child: Text('Add', style: textStyle(16, Colors.white)),
//             ),
//             shape: darkButton(),
//             padding: const EdgeInsets.all(15),
//             onPressed: () {
//               // _postTrip();
//               if (_key.currentState.validate()) {
//                 // If the form is valid, display a snackbar. In the real world,
//                 // you'd often call a server or save the information in a database.

//                 Scaffold.of(context)
//                     .showSnackBar(SnackBar(content: Text('Processing Data')));
//               }
//             },
//           ),
//         ),
//       ],
//     );
//   }

//   String validateName(String value) {
//     String patttern = r'(^[a-zA-Z ]*$)';
//     RegExp regExp = new RegExp(patttern);
//     if (value.length == 0) {
//       return "Name is Required";
//     } else if (value.length > 32) {
//       return "Max length is 32 characters";
//     } else if (!regExp.hasMatch(value)) {
//       return "Name must be a-z and A-Z";
//     }
//     return null;
//   }

//   String validateAlphaNumeric(String value) {
//     if (value.length == 0) {
//       return "Value is Required";
//     } else if (value.length > 32) {
//       return "Max length is 32 characters";
//     }
//     return null;
//   }

//   String validateTripAmount(String value) {
//     String patttern = r'(^[0-9]*$)';
//     RegExp regExp = new RegExp(patttern);
//     if (value.length == 0) {
//       return "The trip fare is Required";
//     } else if (!regExp.hasMatch(value)) {
//       return "The trip fare must be digits";
//     }
//     return null;
//   }

//   String validateNumberOfSeats(String value) {
//     String patttern = r'(^[0-9]*$)';
//     RegExp regExp = new RegExp(patttern);
//     if (value.length == 0) {
//       return "Enter number of your cars seats is Required";
//     } else if (!regExp.hasMatch(value)) {
//       return "The number of seats must be digits";
//     }
//     return null;
//   }

//   _postTrip() {
//     if (_key.currentState.validate()) {
//       // No any error in validation
//       final FirebaseAuth auth = FirebaseAuth.instance;
//       final currentUserId = auth.currentUser.uid;
//       Feeds feed = new Feeds();

//       isLoading = true;
//       _loader();

//       var departingDateTime = DateTime(pickedDate.year, pickedDate.month,
//           pickedDate.day, time.hour, time.minute);

//       Map<String, dynamic> newFeedData = {
//         'date_created': FieldValue.serverTimestamp(),
//         'date_updated': FieldValue.serverTimestamp(),
//         'departure_datetime': departingDateTime,
//         'departure_point': departureEditingController.text,
//         'destination_point': destinationEditingController.text,
//         'feed_status': 'open',
//         'feed_type': TripConst.RIDE_OFFER,
//         'sender_uid': currentUserId,
//         'trip_fare': tripFareEditingController.text,
//       };

//       try {
//         feed.addFeed(newFeedData).then((results) {
//           print("Results - Document Id $results");
//           setState(() {
//             isLoading = false;
//             Navigator.of(context).pop();
//             _loader();
//           });
//         });
//       } catch (e) {
//         print("Error building and sending Trip Data $e");
//       }
//       _key.currentState.save();
//     } else {
//       // validation error
//       setState(() {
//         validate = true;
//       });
//     }
//   }

//   _loader() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         content: ListTile(
//           subtitle: isLoading
//               ? Container(
//                   height: 50.0,
//                   width: 50.0,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 )
//               : Text('Successfuly sent request, drivers should Poke you soon!'),
//         ),
//         actions: <Widget>[
//           isLoading
//               ? SizedBox.shrink()
//               : FlatButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     Navigator.pop(context);
//                   },
//                   child: Text("Ok"),
//                 )
//         ],
//       ),
//     );
//   }

//   void _pickDate() async {
//     DateTime date = await showDatePicker(
//         context: context,
//         initialDate: pickedDate,
//         firstDate: DateTime(DateTime.now().year - 5),
//         lastDate: DateTime(DateTime.now().year + 5));

//     setState(() {
//       if (date != null) {
//         pickedDate = date;
//       }
//     });
//   }

//   void _pickTime() async {
//     TimeOfDay theTime = await showTimePicker(
//       context: context,
//       initialTime: time,
//     );

//     setState(() {
//       if (theTime != null) {
//         time = theTime;
//       }
//     });
//   }
// }
