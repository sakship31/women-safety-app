// import 'dart:html';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safety_app/screens/hospitals.dart';
import 'package:safety_app/screens/police.dart';
import 'package:safety_app/services/authservice.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:sms/sms.dart';
import './contacts.dart';
import '../models/contactModel.dart';
import '../services/storage.dart';
import 'package:audioplayers/audio_cache.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var dbHelper = Storage();
  List<ContactModel> contacts;
  AudioCache cache = AudioCache();
  AudioPlayer player = AudioPlayer();

  bool isPlaying = false;
  static const platform = const MethodChannel('sendSms');

  Future<Position> getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    return position;
  }

  void _playFile() async {
    player = await cache.loop('audio/note1.wav'); // assign player here
  }

  void _stopFile() {
    player?.stop(); // stop the file like this
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(
      //         Icons.contacts,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => ContactList()),
      //         );
      //       },
      //     )
      //   ],
      // ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/back.jpg'),
                fit: BoxFit.cover)),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.9),
            Colors.black.withOpacity(.4)
          ])),
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // SizedBox(height: 100),
                  Container(
                    width: double.infinity,
                    // height: 60,
                    // color: Colors.white,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          // color: Colors.red[900],
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  if (isPlaying) {
                                    _stopFile();
                                    isPlaying = false;
                                  } else {
                                    _playFile();
                                    isPlaying = true;
                                  }
                                  setState(() {});
                                },
                                child: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow),
                                // height: 50,
                              ),
                              Container(
                                child: Text(
                                  "Distress",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          // color: Colors.red[900],
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HospitalScreen()),
                                  );
                                },
                                child: Icon(Icons.local_hospital),
                                // height: 50,
                              ),
                              Container(
                                child: Text(
                                  "Hospitals",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          // color: Colors.red[900],
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PoliceScreen(),
                                    ),
                                  );
                                },
                                child: Icon(Icons.local_police),
                                // height: 50,
                              ),
                              Container(
                                child: Text(
                                  "Police",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: InkWell(
                      onTap: () async {
                        Position position = await getCurrentLocation();
                        print("Pressed");
                        contacts = await dbHelper.getContacts();
                        print(contacts[0].number);
                        SmsSender sender = new SmsSender();
                        for (int i = 0; i < contacts.length; i++) {
                          print(i);
                          await sender.sendSms(new SmsMessage(
                              contacts[i].number.trim(),
                              'Help Me ' +
                                  'http://maps.google.com/?q=' +
                                  position.latitude.toString() +
                                  ',' +
                                  position.longitude.toString()));
                        }
                        // contacts.map((contact) {
                        //   await sender.sendSms(new SmsMessage(contact.number.trim(), 'Help ME!!'));
                        // });
                        // String address = "+918460729886";
                        // sender.sendSms(new SmsMessage("+918460729886", 'Hello flutter!'));
                        // sendSms();
                        // _sendSMS(message, recipents);
                      },
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/images/button.jpg'),
                                fit: BoxFit.cover),
                            border: Border.all(color: Colors.white, width: 5),
                            borderRadius: BorderRadius.circular(300),
                            color: Colors.red),
                        child: Center(
                          child: Container(
                            child: Text("SOS",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 90,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContactList()),
                          );
                        },
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  child: Icon(
                                    Icons.contacts,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Center(
                                    child: Text("Add Contacts",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ))),
                              ],
                            ),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50),
                              //color:Colors.white
                            )),
                      ),
                      // SizedBox(height: 20),
                      // InkWell(
                      //   onTap: () {
                      //     if (isPlaying) {
                      //       _stopFile();
                      //       isPlaying = false;
                      //     } else {
                      //       _playFile();
                      //       isPlaying = true;
                      //     }
                      //   },
                      //   child: Container(
                      //       child: Center(
                      //           child: Text("Distress Alarm",
                      //               style: TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //               ))),
                      //       // height: 50,
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         border: Border.all(color: Colors.white),
                      //         borderRadius: BorderRadius.circular(50),
                      //         //color:Colors.white
                      //       )),
                      // ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          AuthService().signOut();
                        },
                        child: Container(
                            child: Center(
                                child: Text("Sign Out",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ))),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(50),
                              //color:Colors.white
                            )),
                      ),
                    ],
                  ),
                  // RaisedButton(
                  //   child: Text("SignOut"),
                  //   onPressed: () {
                  //     AuthService().signOut();
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
