import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv/blocs/login/login_bloc.dart';
import 'package:reserv/views/forgot_password/forgot_password_page.dart';

final formkey = GlobalKey<FormState>();

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  void _logIn(BuildContext context) {
    if (formkey.currentState?.validate() ?? false) {
      final email = _email.text.replaceAll(" ", '');
      context
          .read<LoginBloc>()
          .add(LoginSubmitted(userEmail: email, password: _password.text));
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  final TextEditingController _email = TextEditingController();

  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Log in",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 28),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a user id';
                        }
                        return null;
                      },
                      onTap: () {},
                      decoration: const InputDecoration(
                        hintText: "User ID",
                        labelText: "User ID",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordPage(),
                                ));
                          },
                          child: const Text("Forgotten Password?"),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Builder(builder: (context) {
                      final state = context.watch<LoginBloc>().state;

                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          onPressed: () {
                            _logIn(context);
                          },
                          child: state.status == Status.inProgress
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ))
                              : const Text("Log in"),
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Builder(
                      builder: (context) {
                        final state = context.watch<LoginBloc>().state;
                        if (state.status == Status.failure) {
                          return Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) => const RegisterPage(),
                    //         ));
                    //   },
                    //   child: const Text("Create an account"),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
