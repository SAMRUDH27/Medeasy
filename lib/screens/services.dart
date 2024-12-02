
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medeasy/data/vaccine.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  // ... [Keep the existing notification-related functions]


  Future<void> initializeNotifications() async {
    // const AndroidInitializationSettings initializationSettingsAndroid =
    // AndroidInitializationSettings('app_icon');

    // const InitializationSettings initializationSettings =
    // InitializationSettings(android: initializationSettingsAndroid);

    // await flutterLocalNotificationsPlugin.initialize(
    //   initializationSettings,
    // );
  }

  Future<void> scheduleNotification(DateTime selectedDate, TimeOfDay selectedTime) async {
    tz.initializeTimeZones();
    String currentTimeZone = 'Asia/Kolkata'; // Update this with the appropriate timezone
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    final DateTime combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      final now = DateTime.now();
      final scheduledTime = tz.TZDateTime.from(combinedDateTime, tz.local);
      final difference = scheduledTime.difference(now).inSeconds;
      if (difference > 0) {
        // If the scheduled time is in the future, schedule the notification
        await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'Notification Title',
          'Notification Body',
          scheduledTime,
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        );
      } else {
        // If the scheduled time is in the past, don't schedule the notification
        print('Scheduled time is in the past.');
      }
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }



  Future<void> _selectDateAndTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      print('SelectedDate:- $pickedDate');
      print('Selecttime:- $pickedTime');
      scheduleNotification(pickedDate!, pickedTime);
    }
    }


  @override
  Widget build(BuildContext context) {
    var vaccines = Vaccines();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.green[600],
        elevation: 0,
        title: Text(
          'Medication Reminders',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => _selectDateAndTime(context),
              icon: Icon(Icons.add_alarm, color: Colors.green[600]),
              label: Text(
                'Set Reminder',
                style: GoogleFonts.poppins(
                  color: Colors.green[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.green[50],
            child: Text(
              "Suggested Vaccines",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green[800],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: vaccines.vaccinationSchedule.length,
              itemBuilder: (BuildContext context, int index) {
                final vaccine = vaccines.vaccinationSchedule[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    onTap: () {
                      Get.snackbar(
                        "Set Reminder",
                        "Add Vaccine Reminder",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.indigo[900],
                        colorText: Colors.white,
                        borderRadius: 10,
                        margin: EdgeInsets.all(16),
                      );
                    },
                    title: Text(
                      vaccine['vaccine'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[800],
                      ),
                    ),
                    subtitle: Text(
                      'Age: ${vaccine['age']}',
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Doses: ${vaccine['doses']}',
                        style: GoogleFonts.poppins(
                          color: Colors.green[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





