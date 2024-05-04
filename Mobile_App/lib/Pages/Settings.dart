import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
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
            margin: EdgeInsets.symmetric(vertical: 30,horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.volume_up_outlined, color: Colors.black,),
                SizedBox(width: 10),
                Text("Notifications", 
                style: TextStyle(fontSize: 20))
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(10),
              children:[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.notification_important_outlined),
                    title: Text('General Notifications'),
                    trailing: Switch(
                      activeColor: Colors.green[500],
                      inactiveThumbColor: Colors.black,
                      value: true, // Change this to your desired initial value
                      onChanged: (bool newValue) {
                        // Add your logic for handling the switch state change here
                      },
                    ),
                    // onTap: callnumber,
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.speaker_outlined),
                    title: Text('Sounds'),
                    trailing: Switch(
                      activeColor: Colors.green[500],
                      inactiveThumbColor: Colors.black,
                      value: true, // Change this to your desired initial value
                      onChanged: (bool newValue) {
                        // Add your logic for handling the switch state change here
                      },
                    ),
                    // onTap: callnumber,
                  ),
                ),
                Card(
                  child: ListTile(
                   leading: Icon(Icons.vibration_outlined),
                    title: Text('Vibrations'),
                    trailing: Switch(
                      activeColor: Colors.green[500],
                      inactiveThumbColor: Colors.black,
                      value: true, // Change this to your desired initial value
                      onChanged: (bool newValue) {
                        // Add your logic for handling the switch state change here
                      },
                    ),
                    // onTap: callnumber,
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
