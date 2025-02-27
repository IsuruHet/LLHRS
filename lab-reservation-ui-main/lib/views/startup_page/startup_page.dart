import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome back to Reserve",
              style:
                  Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 28),
            ),
            const SizedBox(
              height: 28,
            ),
            SpinKitThreeBounce(
              color: Theme.of(context).progressIndicatorTheme.color,
              size: 40.0,
            ),
          ],
        ),
      ),
    );
  }
}
