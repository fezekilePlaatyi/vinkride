import 'package:Vinkdriver/helper/Helper.dart';
import 'package:Vinkdriver/model/Helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Vinkdriver/model/Vink.dart';

class VinkDetails extends StatefulWidget {
  @override
  _VinkDetailsState createState() => _VinkDetailsState();
}

class _VinkDetailsState extends State<VinkDetails> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var title = 'Contact Vink';
  Vink vink = new Vink();
  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: vink.getCompanyDetails(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Container(
                width: 0,
                height: 0,
              );
            } else {
              var companyInfo = snapshot.data.docs.first.data();
              if (companyInfo != null) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "${companyInfo['company_name']}",
                        style: TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "${companyInfo['address']['street_1']}, ${companyInfo['address']['building']}, ${companyInfo['address']['city']}, ${companyInfo['address']['country']}, ${companyInfo['address']['zip_code']}",
                        style: TextStyle(
                          color: Color(0xFF1B1B1B),
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ButtonTheme(
                            minWidth: 50.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: vinkRed,
                              onPressed: () => {},
                              child: Icon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.white,
                                size: 20,
                              ),
                              shape: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          ButtonTheme(
                            minWidth: 50.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: vinkRed,
                              onPressed: () => {},
                              child: Icon(
                                FontAwesomeIcons.twitter,
                                color: Colors.white,
                                size: 20,
                              ),
                              shape: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          ButtonTheme(
                            minWidth: 50.0,
                            height: 50.0,
                            child: RaisedButton(
                              color: vinkRed,
                              onPressed: () => {},
                              child: Icon(
                                FontAwesomeIcons.instagram,
                                color: Colors.white,
                                size: 20,
                              ),
                              shape: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment(2, -0.9),
                  child: Text(
                    "Error occured, Please try again later",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
