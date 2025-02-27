import 'package:flutter/material.dart';
import 'package:reserv/views/onboarding/onboard_1.dart';
import 'package:reserv/views/onboarding/onboard_2.dart';
import 'package:reserv/views/onboarding/onboard_3.dart';
import 'package:reserv/views/register_page/register_page.dart';
import 'package:reserv/views/sign_in/sign_in_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardTour extends StatefulWidget {
  const OnboardTour({super.key});

  @override
  State<OnboardTour> createState() => _OnboardTourState();
}

class _OnboardTourState extends State<OnboardTour> {
  final PageController _controller = PageController();
  bool onLast = false;
  bool backButton = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: const [
              OnboardScreen1(),
              OnboardScreen3(),
              OnboardScreen2(),
            ],
          ),
          Container(
              alignment: const Alignment(0, 0.60),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const WormEffect(
                        dotHeight: 11,
                        dotWidth: 11,
                        spacing: 12,
                        dotColor: Colors.grey,
                        activeDotColor: Color(0xFF009688)),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInPage(),
                                  ));
                            },
                            child: const Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 22),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RegisterPage(),
                                  ));
                            },
                            child: const Text(
                              "Create an account",
                              style:
                                  TextStyle(color: Colors.teal, fontSize: 22),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
