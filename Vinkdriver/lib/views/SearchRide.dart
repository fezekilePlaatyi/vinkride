import 'package:Vinkdriver/model/Helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Vinkdriver/views/DriverFeed.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:Vinkdriver/model/Feeds.dart';
import 'package:Vinkdriver/services/PlaceService.dart';
import 'package:Vinkdriver/widget/AddressSearch.dart';
import 'package:Vinkdriver/widget/RideRequest.dart';

class SearchRide extends StatefulWidget {
  final String typeOfRide;
  const SearchRide({this.typeOfRide});
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
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: Color(0xFFCC1718),
            size: 30.0,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Search Trip',
          style: TextStyle(
            color: vinkBlack,
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30.0),
            Text(
              'Find a ride \ngoing in your direction.',
              style: TextStyle(
                color: vinkDarkGrey,
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 50.0),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[350],
                    blurRadius: 10.0,
                    offset: Offset(0, 5.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: new TextField(
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
                    inAppFormsDecor("Enter place of departure", Icons.search),
                style: textStyle(16, vinkDarkGrey),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[350],
                    blurRadius: 10.0,
                    offset: Offset(0, 5.0),
                  ),
                ],
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: new TextField(
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
                decoration: inAppFormsDecor("Enter destination", Icons.search),
                style: textStyle(16, vinkDarkGrey),
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
                  ),
          ],
        ),
      ),
    );
  }
}
