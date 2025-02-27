import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reserv/blocs/login/login_bloc.dart';

final formkey = GlobalKey<FormState>();

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  void _forgotPassword() {
    if (formkey.currentState?.validate() ?? false) {
      final email = _email.text.replaceAll(" ", '');
      context.read<LoginBloc>().add(ForgotPasswordEvent(uniEmail: email));
    }
  }

  final TextEditingController _email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (context) {
          final state = context.watch<LoginBloc>().state;
          if (state.status == Status.success) {
            _email.text = "";
          }
          return Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Forgotten password",
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontSize: 28),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Provide your email and we will send you a link to reset your password",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 14),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: _email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",
                      labelText: "Email",
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: OutlinedButton(
                      onPressed: () {
                        _forgotPassword();
                      },
                      child: state.status == Status.inProgress
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                              ))
                          : const Text("Reset password"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: TextButton(
                      onPressed: () {
                        context.pop();
                      },
                      child: const Text("Go back"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  state.status == Status.success
                      ? const Text(
                          "Email has been sent please check you email",
                          style: TextStyle(color: Colors.green),
                        )
                      : const SizedBox.shrink(),
                  state.status == Status.failure
                      ? Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        )
                      : const SizedBox.shrink(),
                  const Spacer()
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
