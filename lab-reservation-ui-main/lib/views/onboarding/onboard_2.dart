import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardScreen2 extends StatelessWidget {
  const OnboardScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const Spacer(),
          SvgPicture.asset(
            "assets/svg/calendar.svg",
            height: MediaQuery.of(context).size.height * 0.30,
          ),
          const SizedBox(
            height: 50,
          ),
          Text(
            "Stay Organized with the Calendar View",
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
            "The calendar view gives you a comprehensive overview of your upcoming reservations, helping you plan your schedule efficiently.",
            style:
                Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 14),
          ),
          const Spacer(
            flex: 3,
          )
        ],
      ),
    );
  }
}
