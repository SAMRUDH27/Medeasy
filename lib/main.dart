import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medeasy/screens/signin.dart';
import 'screens/HomeScreen.dart';
import 'firebase_options.dart';
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
 
  Gemini.init(apiKey: 'AIzaSyDK1T78CQHGEGratM_s-TmnQwgo5wT1oVU',enableDebugging: true);


  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);
  


  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false
      ,
      theme:  ThemeData(
        useMaterial3: true,
      ),
      home: const SignUp(),
    );
  }
}
