import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:track_elephants/Pages/gpssensor.dart';
import 'package:track_elephants/Pages/stream.dart';

class Device extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Elephant Pulse',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(13, 146, 118, 5),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.on_device_training),
                SizedBox(width: 10),
                Text(
                  "Test Device",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Container(
            child: Expanded(
              child: ListView(
                padding: EdgeInsets.all(10),
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.sensor_occupied_outlined),
                      title: Text('Camera'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LivestreamScreen()),
                        );
                      },
                    ),
                  ),
                  // Card(
                  //   child: ListTile(
                  //     leading: Icon(Icons.swap_horiz_outlined),
                  //     title: Text('Distance Sensor'),
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => distancesensor()),
                  //       );
                  //     },
                  //   ),
                  // ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.gps_fixed_outlined),
                      title: Text('Sensors'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GpsSensorPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
