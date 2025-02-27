import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: 1.4,
              tileMode: TileMode.clamp,
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 181, 238, 230)
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.black87,
                      ))
                ],
              ),
              const Spacer(),
              Image.asset(
                'assets/images/logo.png',
                alignment: Alignment.center,
                height: 200,
                width: 200,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Group 14",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "UI/UX designers",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    "Hanan Haseem",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  Text(
                    "simha shariff",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Backend developer",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    "Isuru Hettiarachchi",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Mobile App developer",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Text(
                    "Shashitha Ashan",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
