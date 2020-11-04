import 'package:driver/widget/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:driver/router/router.gr.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Vinkride Driver',
              theme: ThemeData(
                primarySwatch: Colors.red[900],
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              initialRoute: Routes.loginPage,
              onGenerateRoute: Routes.onGenerateRoute,
              navigatorKey: Routes.navigatorKey,
            );
          }
          return Container();
        });
  }
}
