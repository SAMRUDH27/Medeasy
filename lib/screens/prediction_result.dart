import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';
import 'package:medeasy/screens/HomeScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class Prediction extends StatefulWidget {
  const Prediction({super.key});

  @override
  State<Prediction> createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  bool isFinished = false;
  String result = Get.arguments;

  final Uri _url = Uri.parse('https://www.apollo247.com/specialties/cardiology');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Primary color
        elevation: 20,
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Get.to(const HomeScreen());
            },
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.3),
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Your Heart Health Status",
          style: const TextStyle(
              color: Colors.white, // Text color for primary app bar
              fontSize: 18,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Colors.white, // Background color
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 360,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1), // Lighter shade of green
                  borderRadius: BorderRadius.circular(150),
                ),
                child: Lottie.asset("assets/Animationp.json"),
              ),
              const SizedBox(height: 30),
              result == '0' && result.isNotEmpty
                  ? Text(
                      "Your Heart Health is Good",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.green, fontSize: 24),
                    )
                  : result == '1' && result.isNotEmpty
                      ? Text(
                          "Your Heart Health is Not Good\nPlease Consult A Doctor",
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.redAccent, fontSize: 24),
                        )
                      : Container(),
              const SizedBox(height: 30),
              const Text(
                "Note:- This AI Model has 82% accuracy",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              SwipeableButtonView(
                buttonText: "SWIPE TO CONSULT",
                buttonWidget: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white, // White icon for the button
                ),
                activeColor: Colors.green.withOpacity(0.3), // Lighter shade of green
                isFinished: isFinished,
                onWaitingProcess: () {
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      isFinished = true;
                    });
                  });
                },
                onFinish: () async {
                  print(result);
                  setState(() {
                    _launchUrl();
                    isFinished = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }
}