import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardScreen1 extends StatelessWidget {
  const OnboardScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const Spacer(),
            SvgPicture.asset(
              "assets/svg/welcome.svg",
              height: MediaQuery.of(context).size.height * 0.30,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Welcome to Reserve!",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              textAlign: TextAlign.center,
              "Easily reserve labs and lecture halls, manage your bookings, and stay organized—all in one place.",
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 14),
            ),
            const Spacer(
              flex: 3,
            )
          ],
        ));
  }
}
