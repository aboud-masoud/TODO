import 'package:flutter/material.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/utils/firebase_auth.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rigster"),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              controller: emailController, //TODO: HW: Decorate Field
              decoration: const InputDecoration(hintText: "Enter Email"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              controller: passwordController, //TODO: HW: Decorate Field
              decoration: const InputDecoration(hintText: "Enter Password"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: TextField(
              controller: confirmPasswordController, //TODO: HW: Decorate Field
              decoration:
                  const InputDecoration(hintText: "Enter Confirm Password"),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty) {
                  print(
                      "email field is empty"); //TODO: HW: show it in toast message
                } else if (passwordController.text.isEmpty) {
                  print(
                      "password field is empty"); //TODO: HW: show it in toast message
                } else if (confirmPasswordController.text.isEmpty) {
                  print(
                      "confirm password field is empty"); //TODO: HW: show it in toast message
                } else if (passwordController.text !=
                    confirmPasswordController.text) {
                  print(
                      "password not equal confirm password"); //TODO: HW: show it in toast message
                } else {
                  FirebaseAuthService()
                      .registration(
                          email: emailController.text,
                          password: passwordController.text)
                      .then((value) {
                    print(value);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (ctx) {
                      return const HomeScereen();
                    }), (route) => false);
                  });
                }
              },
              child: const Text("Register")),
        ],
      )),
    );
  }
}
