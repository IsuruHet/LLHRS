import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reserv/blocs/register/register_bloc.dart';
import 'package:reserv/views/sign_in/sign_in_page.dart';

final formkey = GlobalKey<FormState>();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String role = "Student";
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    firstName.dispose();
    lastName.dispose();
    super.dispose();
  }

  void register() {
    if (formkey.currentState?.validate() ?? false) {
      final userEmail = email.text.replaceAll(" ", '');
      context.read<RegisterBloc>().add(RegisterSubmitted(
            userEmail: userEmail,
            password: password.text,
            firstName: firstName.text,
            lastName: lastName.text,
            role: role,
          ));
      clearBoxes();
    }
  }

  void clearBoxes() {
    email.clear();
    password.clear();
    confirmPassword.clear();
    firstName.clear();
    lastName.clear();
  }

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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Register",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 28),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                    DropdownButtonFormField(
                      items: ["Student", "Lecturer", "Demostrator"]
                          .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              )))
                          .toList(),
                      hint: const Text("Select Role"),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            role = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: firstName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'First name cannot be empty';
                        } else if (value.length < 3) {
                          return 'First name contain at least 3 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "First name",
                        labelText: "First name",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: lastName,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Last name cannot be empty';
                        } else if (value.length < 3) {
                          return 'Last name contain at least 3 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Last name",
                        labelText: "Last name",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a email';
                        }
                        if (value.contains('@')) {
                          return 'Please enter only the part before the @ sign';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Email",
                        labelText: "Email",
                        suffix: role == "Student"
                            ? const Text("@fot.sjp.ac.lk")
                            : const Text("@sjp.ac.lk"),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: password,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value.length < 3) {
                          return 'Password at least 8 characters';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Password",
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: confirmPassword,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        } else if (value != password.text) {
                          return 'This should match with the Password';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Confirm password",
                        labelText: "Confirm password",
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Builder(builder: (context) {
                      final state = context.watch<RegisterBloc>().state;
                      return SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: OutlinedButton(
                          onPressed: () {
                            register();
                          },
                          child: state.status == Status.inProgress
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ))
                              : const Text("Register"),
                        ),
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Builder(
                      builder: (context) {
                        final state = context.watch<RegisterBloc>().state;
                        if (state.status == Status.failure) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          );
                        }
                        if (state.status == Status.success) {
                          return Text(
                            state.message,
                            style: const TextStyle(color: Colors.green),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                    // TextButton(
                    //     onPressed: () {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const SignInPage(),
                    //           ));
                    //     },
                    //     child: const Text("Already have an account"))
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
