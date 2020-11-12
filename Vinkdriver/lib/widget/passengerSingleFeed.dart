import 'package:flutter/material.dart';
import 'package:Vinkdriver/model/Helper.dart';

class PassengerSingleFeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          border: Border.all(color: Color(0xF5F5F5)),
        ),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 25.0,
                child: ClipOval(
                  child: SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Image.asset(
                      'assets/images/img-1.jpg',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jane Doe',
                    style: TextStyle(
                      color: vinkBlack,
                      fontFamily: 'Roboto',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Range Rover: Discovery',
                    style: TextStyle(
                      color: vinkDarkGrey,
                      fontFamily: 'Roboto',
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Material(
                    color: Color(0xFFFFFFFF),
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        size: 30,
                        color: vinkRed,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'From',
                            style: TextStyle(
                              color: vinkDarkGrey,
                              fontFamily: 'Roboto',
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            'Mthatha Central, SA',
                            style: TextStyle(
                              color: vinkBlack,
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    color: Color(0xFFFFFFFF),
                    elevation: 1,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    child: ListTile(
                      leading: Icon(
                        Icons.location_on,
                        size: 30,
                        color: vinkRed,
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Destination',
                            style: TextStyle(
                              color: vinkDarkGrey,
                              fontFamily: 'Roboto',
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            'Mthatha Central, SA',
                            style: TextStyle(
                              color: vinkBlack,
                              fontFamily: 'Roboto',
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                              color: vinkDarkGrey,
                              fontFamily: 'Roboto',
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '15 Jun 2020',
                            style: TextStyle(
                              color: vinkBlack,
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Time',
                            style: TextStyle(
                              color: vinkDarkGrey,
                              fontFamily: 'Roboto',
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '03:02 AM',
                            style: TextStyle(
                              color: vinkBlack,
                              fontFamily: 'Roboto',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            const Divider(
              color: Color(0xFFF5F5F5),
              height: 0,
              thickness: 2,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => {},
                    child: Row(
                      children: [
                        userRidingWith(userImage: 'assets/images/img-2.jpg'),
                        Transform.translate(
                          offset: Offset(-20.0, 0),
                          child: userRidingWith(
                              userImage: 'assets/images/img-4.jpg'),
                        ),
                        Transform.translate(
                            offset: Offset(-40, 0),
                            child: remainingSeats(numberOfSeats: "3")),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () => {},
                    color: Color(0xFF1B1B1B),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child:
                        Text("Join Trip", style: textStyle(16, Colors.white)),
                    shape: darkButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget userRidingWith({userImage}) {
    return Container(
      margin: const EdgeInsets.only(left: 0),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: CircleAvatar(
        child: ClipOval(
          child: SizedBox(
            height: 50.0,
            width: 50.0,
            child: Image.asset(
              userImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget remainingSeats({numberOfSeats}) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.red[200],
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            numberOfSeats + ' empty',
            style: TextStyle(
                color: Colors.white,
                fontSize: 13.0,
                fontFamily: 'roboto',
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
