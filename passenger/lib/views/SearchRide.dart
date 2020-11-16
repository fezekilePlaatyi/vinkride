import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:passenger/widgets/DriverFeed.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:passenger/models/Feeds.dart';
import 'package:passenger/services/PlaceService.dart';
import 'package:passenger/widgets/AddressSearch.dart';
import 'package:passenger/widgets/RideRequest.dart';

class SearchRide extends StatefulWidget {
  var typeOfRide;
  SearchRide({this.typeOfRide});
  @override
  State<StatefulWidget> createState() => _SearchRideState();
}

class _SearchRideState extends State<SearchRide> {
  Feeds feeds = new Feeds();
  final departureEditingController = TextEditingController();
  bool departureIsDefined = false;

  final destinationEditingController = TextEditingController();
  bool destinationIsDefined = false;

  @override
  void dispose() {
    departureEditingController.dispose();
    destinationEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctxt) {
    var typeOfRide = widget.typeOfRide;

    return Scaffold(
        backgroundColor: Color(0xFFFCF9F9),
        appBar: AppBar(
          backgroundColor: Color(0xFFFCF9F9),
          elevation: 0,
          title: Text(
            'Search Trips',
            style: TextStyle(
              color: Color(0xFF1B1B1B),
              fontFamily: 'Roboto',
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            ListTile(
              title: new TextField(
                controller: departureEditingController,
                readOnly: true,
                onTap: () async {
                  // generate a new token here
                  final sessionToken = Uuid().v4();
                  setState(() {
                    departureIsDefined = false;
                  });

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
                        departureIsDefined = true;
                      });
                    }
                  }
                },
                decoration:
                    new InputDecoration(hintText: 'Enter departure city...'),
              ),
            ),
            ListTile(
              title: new TextField(
                controller: destinationEditingController,
                readOnly: true,
                onTap: () async {
                  // generate a new token here
                  final sessionToken = Uuid().v4();
                  setState(() {
                    destinationIsDefined = false;
                  });

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
                        destinationIsDefined = true;
                      });
                    }
                  }
                },
                decoration:
                    new InputDecoration(hintText: 'Enter destination city...'),
              ),
            ),
            departureIsDefined == true && destinationIsDefined == true
                ? Expanded(
                    child: StreamBuilder(
                        stream: feeds.searchRideByDepartureAndDestination(
                            departureEditingController.text.trim(),
                            destinationEditingController.text.trim(),
                            typeOfRide),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            if (snapshot.data.docs.length > 0) {
                              return Expanded(
                                child: Container(
                                  child: ListView.builder(
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (
                                      context,
                                      index,
                                    ) {
                                      var feedData =
                                          snapshot.data.docs[index].data();
                                      var feedId = snapshot.data.docs[index].id;

                                      return RideRequest(
                                          feedData: feedData, feedId: feedId);
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                  alignment: Alignment(2, -0.9),
                                  child: Text(
                                    "No trips found in this place. Check again later :)",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ));
                            }
                          }
                        }))
                : Container(
                    width: 0,
                    height: 0,
                  )
          ])
        ]));
  }
}
