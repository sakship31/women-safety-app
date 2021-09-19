// import 'dart:html';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safety_app/screens/hospitals.dart';
import 'package:safety_app/screens/sos.dart';
import 'package:safety_app/services/authservice.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:sms/sms.dart';
import './contacts.dart';
import '../models/contactModel.dart';
import '../services/storage.dart';
import 'package:audioplayers/audio_cache.dart';

class SOSPage extends StatefulWidget {
  @override
  _SOSPageState createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/back.jpg'),
                fit: BoxFit.cover)),
        child: SafeArea(
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
                    Row(
                      children: [InkWell(
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
                                'I am safe ' +
                                    'http://maps.google.com/?q=' +
                                    position.latitude.toString() +
                                    ',' +
                                    position.longitude.toString()));
                          }
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 5),
                              borderRadius: BorderRadius.circular(300),
                              color: Colors.green[600]),
                          child: Center(
                            child: Container(
                              child: Text("Safe",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  )),
                            ),
                          ),
                        ),
                      ),]
                    ),
                    
                    Row(
                      children:[InkWell(
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
                              'Being Cautious ' +
                                  'http://maps.google.com/?q=' +
                                  position.latitude.toString() +
                                  ',' +
                                  position.longitude.toString()));
                        }
                        },

                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 5),
                              borderRadius: BorderRadius.circular(300),
                              color: Colors.yellow[600]),
                          child: Center(
                            child: Container(
                              child: Text("Suspicious",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    SizedBox(width: 20),
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
                        },
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 5),
                              borderRadius: BorderRadius.circular(300),
                              color: Colors.red[600]),
                          child: Center(
                            child: Container(
                              child: Text("Danger",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),],),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
