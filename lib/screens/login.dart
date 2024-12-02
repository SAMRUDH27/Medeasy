
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'HomeScreen.dart';
import 'signin.dart';


class LoginIn extends StatelessWidget {
  const LoginIn({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GlobalKey<FormState> LognInKey = GlobalKey<FormState>();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final RegExp EmailValid = RegExp(
        r"^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$");
    void signIn() {
      if (LognInKey.currentState!.validate()) {
        auth
            .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
            .whenComplete(
              () => ScaffoldMessenger.of(context)
              .showSnackBar(
            const SnackBar(
              content: Text("Logged In Successfully"),
            ),
          )
              .closed
              .whenComplete(
                () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            ),
          ),
        );
      }
    }
    return Scaffold(
      backgroundColor: const Color.fromRGBO(32, 51, 84, 1),
      body: SingleChildScrollView(
        child: Form(
          key: LognInKey,
          child: Column(
            verticalDirection: VerticalDirection.down,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
                child: Container(
                  height: 600,
                  width: 392.8,
                  decoration: BoxDecoration(
                      border: Border.all(color: const Color.fromRGBO(21, 34, 56, 1)),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            blurStyle: BlurStyle.outer)
                      ],
                      color: const Color.fromRGBO(28, 46, 74, 0.75),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 75),
                        child: Text(
                          "Log in to MedSync",
                          style: GoogleFonts.ubuntu(
                              textStyle: const TextStyle(
                                  fontSize: 35, fontWeight: FontWeight.w500),
                              color: Colors.white70),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 50, 238, 10),
                        child: Text("EMAIL",
                            style: GoogleFonts.ubuntu(
                                color: Colors.white24,
                                fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 2, 30, 20),
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a valid email";
                            } else if (!EmailValid.hasMatch(value)) {
                              return "Please enter a valid email";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: const Color.fromRGBO(32, 51, 84, 1),
                              filled: true,
                              labelText: "Email",
                              hoverColor: Colors.white70,
                              enabled: true,
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 10, 210, 10),
                        child: Text("PASSWORD",
                            style: GoogleFonts.ubuntu(
                                color: Colors.white24,
                                fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 2, 30, 20),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter a valid password";
                            } else if (value.length < 9) {
                              return "Password must be at least 9 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: const Color.fromRGBO(32, 51, 84, 1),
                              filled: true,
                              labelText: "Password",
                              hoverColor: Colors.white70,
                              enabled: true,
                              prefixIcon: const Icon(Icons.password),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(38.0),
                                    )),
                                elevation: const WidgetStatePropertyAll<double>(10),
                                backgroundColor:
                                const WidgetStatePropertyAll<Color>(
                                    Colors.indigo),
                                visualDensity: const VisualDensity(
                                    horizontal: 4, vertical: 2.5)),
                            onPressed: ()  {
                                    signIn();
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(fontSize: 18,color: Colors.black),
                            )),
                      ),
                      Row(
                        children: [
                          const Padding(
                              padding: EdgeInsets.fromLTRB(38, 35, 0, 0),
                              child: Text(
                                "Don't have an account ?",
                                style: TextStyle(fontSize: 18),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 33),
                            child: TextButton(
                                onPressed: () {
                                       Get.to(const SignUp());
                                },
                                child: const Text("Sign in")),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
