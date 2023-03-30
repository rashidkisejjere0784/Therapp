import 'package:flutter/material.dart';
import 'package:therapp/Pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:therapp/Homepage.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String err = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //create the purple background
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 500,
              decoration: const BoxDecoration(
                color: Pallete.light_purple,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  RichText(
                    text: TextSpan(
                      text: "Ther.app",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 200,
            child: Container(
              height: 350,
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 30,
              margin: const EdgeInsets.fromLTRB(15, 0, 0, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      "Sign Into Therapp",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Pallete.dark_purple,
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            BuildTextField(Icons.email_outlined,
                                "Enter your Email", false, true),
                            BuildTextField(Icons.password_outlined,
                                "Enter a secure password", true, false),
                            BuildTextField(Icons.password,
                                "Confirm your Password", true, false),
                            Text(
                              err,
                              style: const TextStyle(color: Colors.red),
                            )
                          ],
                        )),
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: ElevatedButton(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  "Create Account",
                                  style: GoogleFonts.montserrat(),
                                ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.dark_purple,
                            textStyle: const TextStyle(
                                color: Pallete.dark_purple,
                                fontSize: 15,
                                fontStyle: FontStyle.normal),
                          ),
                          onPressed: () {
                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim())
                                .then((value) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()),
                              );
                            }).onError((error, stackTrace) {
                              setState(() {
                                err = error.toString();
                                int index = err.indexOf("]");
                                err = err.substring(index + 1);
                                isLoading = false;
                              });
                            });
                            setState(() {
                              isLoading = true;
                            });
                          },
                        )),
                    const SizedBox(height: 10),
                    RichText(
                      text: TextSpan(
                        text: "Already have an account?  ",
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          color: Pallete.light_purple,
                        ),
                        children: [
                          TextSpan(
                            text: "SignIn",
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Pallete.dark_purple,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BuildTextField(
      IconData icon, String hintText, bool isPassword, bool isEmail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
      child: TextField(
          obscureText: isPassword,
          keyboardType:
              isEmail ? TextInputType.emailAddress : TextInputType.text,
          controller: isEmail
              ? emailController
              : isPassword
                  ? passwordController
                  : null,
          decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Pallete.light_purple),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Pallete.text_color1),
                  borderRadius: BorderRadius.all(Radius.circular(35.0))),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Pallete.text_color1),
                  borderRadius: BorderRadius.all(Radius.circular(35.0))),
              contentPadding: const EdgeInsets.all(10),
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Pallete.text_color2))),
    );
  }
}
