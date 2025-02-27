import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardScreen3 extends StatelessWidget {
  const OnboardScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const Spacer(),
            SvgPicture.asset(
              "assets/svg/online.svg",
              height: MediaQuery.of(context).size.height * 0.30,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Access Your Reservations Anytime, Anywhere",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              textAlign: TextAlign.center,
              "Whether you're on campus, at home, or on the go, your lab and lecture hall reservations are always within reach.",
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
