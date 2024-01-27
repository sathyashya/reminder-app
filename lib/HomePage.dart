import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'UpgradeEvent.dart';
import 'main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> events = [];

  //current date & time------
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  //textfield controller----
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  //date picker---
  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    return pickedDate;
  }

  //time picker---

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    return pickedTime;
  }

//format time
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    // Custom time format (h:mm a for 12-hour format with AM/PM)
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text('Set a reminder',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                isScrollControlled: false,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                context: context,
                isDismissible: false,
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(Icons.drive_file_rename_outline),
                        title: TextField(
                          maxLength: 15,
                          controller: nameController,
                          decoration: InputDecoration(
                              hintText: 'Give a title..',
                              hintStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.drive_file_rename_outline),
                        title: TextField(
                          controller: descriptionController,
                          decoration: InputDecoration(
                              hintText: 'Description..',
                              hintStyle: TextStyle(color: Colors.black)),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.calendar_month),
                        title: GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await _selectDate(context);
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                                dateController.text =
                                    '${selectedDate.day} /${selectedDate.month} /${selectedDate.year}';
                              });
                            }
                          },
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: dateController,
                            decoration: InputDecoration(
                                hintText: "Activity Date",
                                hintStyle: TextStyle(color: Colors.black)),
                            enabled: false,
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.access_time_filled_rounded),
                        // tileColor: Colors.black,
                        title: GestureDetector(
                          onTap: () async {
                            TimeOfDay? pickedTime = await _selectTime(context);
                            if (pickedTime != null) {
                              setState(() {
                                selectedTime = pickedTime;
                                timeController.text = _formatTime(selectedTime);
                              });
                            }
                          },
                          child: TextField(
                            style: TextStyle(color: Colors.black),
                            controller: timeController,
                            decoration: InputDecoration(
                                hintText: "Activity Time",
                                hintStyle: TextStyle(color: Colors.black)),
                            enabled: false,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (timeController.text.isNotEmpty &&
                                  dateController.text.isNotEmpty) {
                                createEvent();
                                Navigator.pop(context);
                              } else {
                                Navigator.pop(context);
                                print("Please select both date and time.");
                              }
                            },
                            child: Text(
                              'On Create',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(
              Icons.alarm,
              size: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
      bottomSheet: EventList(
        events: events,
      ),
    );
  }

  void createEvent() {
    Event newEvent = Event(
      name: '${nameController.text}',
      description: '${descriptionController.text}',
      time: '${_formatTime(selectedTime)}',
      date: '${selectedDate.day} /${selectedDate.month} /${selectedDate.year}',
    );

    DateTime eventDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() {
      events.add(newEvent);
    });
    // Check if the event's date and time are equal to the current date and time
    // Clear the text fields after creating the event
    nameController.text = '';
    descriptionController.text = '';
    dateController.text = '';
    timeController.text = '';
//current time date run
    Timer.periodic(Duration(seconds: 1), (timer) {
      DateTime currentDateTime = DateTime.now();
      if (eventDateTime.hour == currentDateTime.hour &&
          eventDateTime.minute == currentDateTime.minute &&
          eventDateTime.day == currentDateTime.day &&
          eventDateTime.month == currentDateTime.month &&
          eventDateTime.year == currentDateTime.year) {
        print('Match');
        showNotification(newEvent);
        timer.cancel(); // Stop the periodic timer once a match is found
      } else {
        print('Not Match');
      }
    });
  }
}

//this part not work
Future<void> onSelectNotification(
    String? payload, Event event, BuildContext context) async {
  // Handle the notification click event here
  print("Notification clicked with payload: $payload");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Your Activity',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(
              height: 10,
            ),
            Text(
              " ${event.name}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 17, color: Colors.red),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              " ${event.description}",
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 17, color: Colors.green),
            ),
          ]));
    },
  );
}

// Function to show notification
Future<void> showNotification(Event event) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your_channel_id', // Change this to a unique channel ID
    'your_channel_name', // Change this to a unique channel name
    playSound: true,
    importance: Importance.max,
    priority: Priority.high,
  );

  // var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    // iOS: iOSPlatformChannelSpecifics,
  );
  // Customized notification body using rich text

  String eventName = event.name;
  String eventDescription = event.description;

  String notificationBody = '''
    Title: 🔴 $eventName
    📌 $eventDescription
  ''';

  await flutterLocalNotificationsPlugin.show(
    0, // Notification ID
    'Event Alert', // Notification title
    notificationBody, // Notification body
    platformChannelSpecifics,
    payload: 'item x', // Optional payload
  );
}
