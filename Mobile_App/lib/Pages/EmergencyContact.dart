// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactPage extends StatelessWidget {// URIs for emergency contact numbers
  final Uri dialNumber = Uri(scheme: 'tel', path: '119');
  final Uri dialNumber2 = Uri(scheme: 'tel', path: '110');
  final Uri dialNumber3 = Uri(scheme: 'tel', path: '1971');

  EmergencyContactPage({Key? key});
  // Function to initiate a call to the specified number
  Future<void> _callNumber(Uri number) async { 
    await launch(number.toString()); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elephant Pulse'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(13, 146, 118, 5),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.emergency_outlined),
                SizedBox(width: 10),
                Text(
                  "Emergency Contacts",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 15.0),
            child: ListView( //show contacts in a list
              shrinkWrap: true, // Shrink-wrap the ListView to its contents
              children: [
                Card(
                  child: ListTile(
                    leading: Icon(Icons.local_police),
                    title: Text('POLICE EMERGENCY HOTLINE'),
                    subtitle: Text('118/119'),
                    onTap: () => _callNumber(dialNumber),// Call function on tap
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.local_hospital),
                    title: Text('AMBULANCE / FIRE DEPARTMENT HOTLINE'),
                    subtitle: Text('110'),
                    onTap: () => _callNumber(dialNumber2),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.railway_alert),
                    title: Text('SRI LANKA RAILWAY HOTLINE'),
                    subtitle: Text('1971'),
                    onTap: () => _callNumber(dialNumber3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
