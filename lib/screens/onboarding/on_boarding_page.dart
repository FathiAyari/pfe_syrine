import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pfe_syrine/screens/login/login.dart';
import 'package:pfe_syrine/theme/colors.dart';

import '../../constants.dart';
import 'on_boarding_content.dart';
import 'on_boarding_controller.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

PageController _controller = PageController();
int currentPage = 0;
List<Content> contentList = [
  Content(
    img: 'assets/bg1.jpg',
    description: 'Your hygiene and beauty is our priority \nwith us you are in good hands.',
    title: 'Welcome to Cura shape.',
  ),
  Content(
    img: 'assets/bg3.jpg',
    description: "Be ready to reach the pinnacle of your beauty satisfaction.",
    title: 'Keep your smile shining.',
  ),
  Content(
    img: 'assets/bg2.jpg',
    description: 'We are not the only ones but we are the best.',
    title: "Enjoy our products.",
  )
];
OnBoardingController onBoardingController = OnBoardingController();

class _OnBoardingPageState extends State<OnBoardingPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemCount: contentList.length,
                scrollDirection: Axis.horizontal, // the axis
                controller: _controller,
                itemBuilder: (context, int index) {
                  return contentList[index];
                }),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(contentList.length, (int index) {
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        height: size.height * 0.01,
                        width: (index == currentPage) ? 30 : 15, // condition au lieu de if else
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: Constants.screenHeight * 0.01),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: (index == currentPage) ? LightColors.kBlue : Colors.white),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      height: Constants.screenHeight * 0.07,
                      child: ElevatedButton(
                          onPressed: (currentPage == contentList.length - 1)
                              ? () {
                                  onBoardingController.check();
                                  Get.to(LoginScreen());
                                }
                              : () {
                                  onBoardingController.check();
                                  _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuint);
                                },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            backgroundColor: LightColors.kBlue,
                          ),
                          child: (currentPage == contentList.length - 1)
                              ? Text(
                                  "Commencer",
                                  style: TextStyle(fontFamily: "NunitoBold"),
                                )
                              : Text(
                                  "Suivant",
                                  style: TextStyle(fontFamily: "NunitoBold"),
                                )),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
