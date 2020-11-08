import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:passenger/helper/onboardingModel.dart';
import 'package:passenger/model/Helper.dart';
import 'package:passenger/routes/routes.gr.dart';
import 'package:passenger/views/login.dart';
import 'package:passenger/widget/sliderTile.dart';

class Onboariding extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vink App',
      home: OnboardingSlider(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class OnboardingSlider extends StatefulWidget {
  @override
  _OnboardingSliderState createState() => _OnboardingSliderState();
}

class _OnboardingSliderState extends State<OnboardingSlider> {
  List<OnboardingModel> slides = new List<OnboardingModel>();
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    slides = getSlides();
  }

  Widget pageIndicator(bool isCurrentPage) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 8.0 : 7.0,
      width: isCurrentPage ? 25.0 : 7.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? vinkBlack : Color(0xFFeE6E6E6),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: pageController,
        itemCount: slides.length,
        onPageChanged: (val) {
          setState(() {
            currentIndex = val;
          });
        },
        itemBuilder: (context, index) {
          return SliderTile(
            imageAssetsPath: slides[index].getImageAssetsPath(),
            title: slides[index].getTitle(),
            description: slides[index].getDescription(),
          );
        },
      ),
      bottomSheet: currentIndex != slides.length - 1
          ? Container(
              color: Colors.white,
              height: Platform.isIOS ? 70.0 : 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: () {
                      pageController.animateToPage(
                        slides.length - 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                    },
                    child: Text('SKIP'),
                  ),
                  Row(
                    children: [
                      for (int i = 0; i < slides.length; i++)
                        currentIndex == i
                            ? pageIndicator(true)
                            : pageIndicator(false)
                    ],
                  ),
                  FlatButton(
                    onPressed: () {
                      pageController.animateToPage(
                        currentIndex + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.linear,
                      );
                    },
                    child: Text('NEXT'),
                  ),
                ],
              ),
            )
          : Container(
              height: Platform.isIOS ? 70.0 : 60.0,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              color: vinkBlack,
              child: FlatButton(
                onPressed: () {
                  Routes.navigator.pushNamed(Routes.loginPage);
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'roboto',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
            ),
    );
  }
}
