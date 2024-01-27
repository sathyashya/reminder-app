import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Event {
  String name;
  String description;
  String date;
  String time;

  Event({
    required this.name,
    required this.description,
    required this.date,
    required this.time,
  });
}

class EventList extends StatefulWidget {
  final List<Event> events;

  EventList({required this.events});

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  // Initialize controllers update
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with empty values
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  List<bool> isExpanded = List.generate(100, (index) => false);
  // DateTime selectedDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.events.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          tileColor: Color.fromRGBO(64, 75, 96, 0.9),
          onTap: () {
            setState(() {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Your Activity',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            " ${widget.events[index].name}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 17, color: Colors.green),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            " ${widget.events[index].description}",
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${widget.events[index].date}",
                            style: TextStyle(fontSize: 17),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "${widget.events[index].time}",
                            style: TextStyle(fontSize: 17, color: Colors.red),
                          )
                        ]),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'OK',
                            style: TextStyle(
                                color: Color.fromRGBO(58, 66, 86, 1.0),
                                fontWeight: FontWeight.bold),
                          ))
                    ],
                  );
                },
              );
            });
          },
          leading: const Icon(Icons.task_alt, color: Colors.white),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(" ${widget.events[index].name}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 10,
                      ),
                      Text('${widget.events[index].date}',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Text("${widget.events[index].time}",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            barrierColor: Color.fromRGBO(58, 66, 86, 1.0),
                            elevation: 10,
                            isDismissible: false,
                            // isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                            context: context,
                            builder: (BuildContext context) {
                              // Use the controllers that were initialized in initState
                              _nameController.text = widget.events[index].name;
                              _descriptionController.text =
                                  widget.events[index].description;

                              return Column(
                                children: [
                                  ListTile(
                                    leading:
                                        Icon(Icons.drive_file_rename_outline),
                                    title: TextField(
                                      maxLength: 15,
                                      controller: _nameController,
                                      onChanged: (value) {
                                        setState(() {
                                          // Update the corresponding event data
                                          widget.events[index].name = value;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Give a title..',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    leading:
                                        Icon(Icons.drive_file_rename_outline),
                                    title: TextField(
                                      controller: _descriptionController,
                                      onChanged: (value) {
                                        setState(() {
                                          widget.events[index].description =
                                              value;
                                          print(value);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Description..',
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            // Create a copy of the existing event
                                            Event updatedEvent = Event(
                                              name: widget.events[index].name,
                                              description: widget
                                                  .events[index].description,
                                              date: widget.events[index].date,
                                              time: widget.events[index].time,
                                            );

                                            // Update only the non-empty and changed values
                                            if (_nameController
                                                    .text.isNotEmpty &&
                                                _nameController.text !=
                                                    widget.events[index].name) {
                                              updatedEvent.name =
                                                  _nameController.text;
                                            }

                                            if (_descriptionController
                                                    .text.isNotEmpty &&
                                                _descriptionController.text !=
                                                    widget.events[index]
                                                        .description) {
                                              updatedEvent.description =
                                                  _descriptionController.text;
                                            }

                                            // Replace the existing event with the updated one
                                            widget.events[index] = updatedEvent;

                                            // Close the bottom sheet
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: Text(
                                          'Update Event ',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Color.fromRGBO(58, 66, 86, 1.0),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      )
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon:
                            Icon(Icons.edit, color: CupertinoColors.activeBlue),
                      ),
                      // SizedBox(
                      //   width: 15,
                      // ),
                      //delete icon
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.events.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        );
      },
    );
  }
}
