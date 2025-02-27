import 'package:flutter/material.dart';

void showConfirmDialogBox(BuildContext context,
    {required String title,
    required IconData icon,
    required String moduleName}) {
  TextStyle? titleStyle = Theme.of(context)
      .textTheme
      .titleLarge!
      .copyWith(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.teal);
  TextStyle? moduleStyle = Theme.of(context).textTheme.labelSmall!.copyWith(
        fontSize: 18,
      );
  TextStyle? btnStyle = Theme.of(context).textTheme.labelSmall;
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.width * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Icon(
                    icon,
                    size: 35,
                    color: Colors.teal,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: titleStyle,
                      ),
                      Text(
                        moduleName,
                        style: moduleStyle,
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 45,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Type 'confirm' here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    style: ButtonStyle(
                      side: const WidgetStatePropertyAll(
                          BorderSide(color: Colors.teal)),
                      shape: WidgetStatePropertyAll(
                        ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      "No, confirm",
                      style:
                          btnStyle!.copyWith(color: Colors.teal, fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    color: Colors.teal,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {},
                    child: Text(
                      "Yes, confirm",
                      style:
                          btnStyle.copyWith(color: Colors.white, fontSize: 14),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
