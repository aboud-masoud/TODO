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
              decoration: const InputDecoration(hintText: "Enter Confirm Password"),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("email field is empty"),
                  ));
                } else if (passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("password field is empty"),
                  ));
                } else if (confirmPasswordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("confirm password field is empty"),
                  ));
                } else if (passwordController.text != confirmPasswordController.text) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("password not equal confirm password"),
                  ));
                } else {
                  FirebaseAuthService()
                      .registration(email: emailController.text, password: passwordController.text)
                      .then((value) {
                    if (value == "Restration Compleated") {
                      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) {
                        return const HomeScereen();
                      }), (route) => false);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(value),
                      ));
                    }
                  });
                }
              },
              child: const Text("Register")),
        ],
      )),
    );
  }
}
