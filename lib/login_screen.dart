import 'package:flutter/material.dart';
import 'package:todo_app/home_screen.dart';
import 'package:todo_app/register_screen.dart';
import 'package:todo_app/utils/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    emailController.text = "xxx@mail.com";
    passwordController.text = "123456";

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.network(
                  "https://edita.com.eg/wp-content/uploads/2023/06/todo-new-group-1.png",
                  height: 250,
                ),
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
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("email field is empty"),
                        ));
                      } else if (passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("password field is empty"),
                        ));
                      } else {
                        FirebaseAuthService()
                            .login(email: emailController.text, password: passwordController.text)
                            .then((value) {
                          if (value == "correct") {
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) {
                              return HomeScereen(emailAddress: emailController.text);
                            }), (route) => false);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(value),
                            ));
                          }
                        });
                      }
                    },
                    child: const Text("Login")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                        return const RegisterScreen();
                      }));
                    },
                    child: const Text("Register Now"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
