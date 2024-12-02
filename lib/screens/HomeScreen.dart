import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medeasy/screens/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medeasy/screens/chat_bot.dart';
import 'package:medeasy/screens/community.dart';
import 'package:medeasy/screens/health_prediction.dart';
import 'package:medeasy/screens/location.dart';
import 'package:medeasy/screens/meals.dart';
import 'package:medeasy/screens/medicine_generic.dart';
import 'package:medeasy/screens/services.dart';
import 'package:medeasy/screens/shopkeeper_dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final primaryColor = const Color(0xFF4CAF50); // Green
  final backgroundColor = Colors.white;
  final secondaryColor = const Color(0xFF1A237E); // Dark Blue

  String _userName = '';
  String _userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
     _loadUserData();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App resumed'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case AppLifecycleState.inactive:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App inactive'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case AppLifecycleState.paused:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App paused'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case AppLifecycleState.detached:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('App detached'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
    }
  }


  
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? '';
      _userEmail = prefs.getString('userEmail') ?? '';
    });
  }
   Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      await Get.offAll(const SignUp());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       drawer: Drawer(
  child: ListView(
    padding: EdgeInsets.zero,
    children: [
      DrawerHeader(
        decoration: BoxDecoration(
          color: primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: primaryColor,
                size: 36,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _userName,
              style: GoogleFonts.ubuntu(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _userEmail,
              style: GoogleFonts.ubuntu(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      ListTile(
        leading: const Icon(Icons.home),
        title: Text('Home', style: GoogleFonts.ubuntu()),
        onTap: () {
          Get.to(const HomeScreen());
        },
      ),
      ListTile(
        leading: const Icon(Icons.people),
        title: Text('Community', style: GoogleFonts.ubuntu()),
        onTap: () {
          Get.to(CommunityPage());
        },
      ),
      ListTile(
        leading: const Icon(Icons.map),
        title: Text('Find', style: GoogleFonts.ubuntu()),
        onTap: () {
          Get.to(PharmacyFinder());
        },
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.call),
        title: Text('Emergency', style: GoogleFonts.ubuntu()),
        onTap: () {
          // Launch the phone dialer to call 108
          launchUrl(Uri.parse('tel:108'));
        },
      ),
      const Divider(),
      ListTile(
        leading: const Icon(Icons.logout),
        title: Text('Logout', style: GoogleFonts.ubuntu()),
        onTap: _logout,
      ),
    ],
  ),
),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'MedEasy',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Get.to(const ShopkeeperDashboard());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                "Seller Login",
                style: GoogleFonts.ubuntu(color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGenericMedicineCard(),
              const SizedBox(height: 20),
              _buildServiceCards(),
              const SizedBox(height: 20),
              _buildFitnessTrackerCard(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildGenericMedicineCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 200,
              width: double.infinity,
              child: Lottie.asset("assets/genericmedicine.json"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find and Buy Generic Medicines',
                  style: GoogleFonts.ubuntu(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Get Up to 50%-90% off',
                  style: GoogleFonts.ubuntu(
                    fontSize: 14,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.to(MedicineAlternativesScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Buy Generic Medicine',
                    style: GoogleFonts.ubuntu(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Services',
          style: GoogleFonts.ubuntu(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: secondaryColor,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildServiceCard(
                'Medicine Reminder',
                'assets/yaad.json',
                () => Get.to(const NotificationScreen()),
              ),
              _buildServiceCard(
                'Chat Bot',
                'assets/ask.json',
                () => Get.to(const MedicalChatBot()),
              ),
              _buildServiceCard(
                'CardioCare AI',
                'assets/heartattack.json',
                () => Get.to(const HeartDiseasePrediction()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceCard(String title, String assetPath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: SizedBox(
          width: 160,
          height: 160,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Lottie.asset(assetPath),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.ubuntu(
                  fontWeight: FontWeight.bold,
                  color: secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFitnessTrackerCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fitness Tracker',
              style: GoogleFonts.ubuntu(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: secondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add Daily Meals and Track Your Calories',
              style: GoogleFonts.ubuntu(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Get.to(Meals());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Add Meals',
                style: GoogleFonts.ubuntu(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey[600],
      backgroundColor: Colors.white,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Find'),
      ],
      onTap: (index) {
        if (index == 0) {
          Get.toNamed('/home');
        } else if (index == 1) {
          Get.to(CommunityPage());
        } else if (index == 2) {
          Get.to(PharmacyFinder());
        }
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Your SMS sending logic here
      },
      backgroundColor: primaryColor,
      child: const FaIcon(FontAwesomeIcons.commentSms, size: 24),
    );
  }
}