import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalScreen extends StatefulWidget {
  @override
  _HospitalScreenState createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  bool isLoading = true;

  List hospitals = [];
  String url =
      "https://api.geoapify.com/v2/places?categories=healthcare.hospital&filter=circle:";
  @override
  void initState() {
    super.initState();
    _getHospitals();
  }

  _getHospitals() async {
    Position position = await getCurrentLocation();
    String latitude = position.latitude.toString();
    String longitude = position.longitude.toString();
    String query = url +
        longitude +
        "," +
        latitude +
        ",1000&bias=proximity:" +
        longitude +
        "," +
        latitude +
        "&limit=20&apiKey=545fa0bb821746e4b617fdfab0d522c6";
    print(query);

    var res = await http.get(query);
    hospitals = json.decode(res.body)["features"];
    print(hospitals);
    setState(() {
      isLoading = false;
    });
  }

  _launchURL(_url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  Future<Position> getCurrentLocation() async {
    final position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    return position;
  }

  _getHospitalItem(int index) {
    return GestureDetector(
      onTap: () {
        String openUrl = 'http://maps.google.com/?q=' +
            hospitals[index]["geometry"]["coordinates"][1].toString() +
            ',' +
            hospitals[index]["geometry"]["coordinates"][0].toString();
        _launchURL(openUrl);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        // height: 40,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                // color: Colors.red,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(
                        hospitals[index]["properties"]["name"],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child:
                          Text(hospitals[index]["properties"]["address_line2"]),
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      child: Text(hospitals[index]["properties"]["distance"]
                              .toString() +
                          "m"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                child: Icon(Icons.map),
                // color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
    );
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
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
            Colors.black.withOpacity(.9),
            Colors.black.withOpacity(.4)
          ])),
          child: isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    child: ListView.builder(
                        itemCount: hospitals.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _getHospitalItem(index);
                        }),
                  ),
                ),
        ),
      ),
    );
  }
}
