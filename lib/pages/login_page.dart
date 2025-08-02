import 'package:chat_app/Components/my_button.dart';
import 'package:chat_app/Components/my_textfield.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signIn(BuildContext context) async {
    //instance
    final authServices = AuthServices();

    //try login
    try {
      await authServices.signWithEmailPassword(
        emailController.text,
        passwordController.text,
      );

      // ignore: use_build_context_synchronously
    } catch (e) {
      // ignore: use_build_context_synchronously

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              title: Text(e.toString(), style: TextStyle(fontSize: 14)),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                //logo
                Image.asset("lib/images/birds.png", height: 300),

                SizedBox(height: 20),

                //welcome text
                Text(
                  "Welcome back, You've been missed",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20),

                //email and password text field
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                SizedBox(height: 15),
                MyTextfield(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true,
                ),

                SizedBox(height: 10),
                //forget password
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                //sign in button
                MyButton(text: "Sign In", onTap: () => signIn(context)),

                SizedBox(height: 20),

                //register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an Account?",
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),

                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: onTap,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
