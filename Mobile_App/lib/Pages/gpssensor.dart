// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class GpsSensorPage extends StatefulWidget {
  @override
  _GpsSensorPageState createState() => _GpsSensorPageState();
}

class _GpsSensorPageState extends State<GpsSensorPage> {
  late DatabaseReference _databaseReference;// Reference to Firebase Realtime Database
  int? _resultCode; // Variable to store the result code received from the database

  @override
  void initState() {
    super.initState();
    // Listen to changes in the 'ResultCode' node and update the UI accordingly
    _databaseReference = FirebaseDatabase.instance.reference().child('dev_data');
    _databaseReference.child('ResultCode').onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _resultCode = int.parse(event.snapshot.value.toString());
        });
      }
    });
  }

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
                Icon(Icons.sensors),
                SizedBox(width: 10),
                Text(
                  "Sensors Status",
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Text(
               'Sensors current status is:',
                style: TextStyle(
                fontSize: 20,
                ),
              ),
          SizedBox(height: 20),
          Center(
            child: _resultCode == null
                ? CircularProgressIndicator()
                : Text('CODE $_resultCode',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600
                    ),),
          ),
          SizedBox(height: 30),
          Text(
               'What is mean by this code?',
                style: TextStyle(
                fontSize: 18,
                ),
              ),

          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Code',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600  
                              ),
                            textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Result',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600  
                              ),
                            textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CODE 0',
                            style: TextStyle(
                                fontSize: 15, 
                              ),
                            textAlign: TextAlign.center,
                            ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Distance sensor hardware fault',
                      style: TextStyle(
                                fontSize: 15, 
                              ),
                            
                            ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CODE 1',
                          style: TextStyle(
                                fontSize: 15, 
                              ),
                            textAlign: TextAlign.center,                     
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Failed to Connect',
                      style: TextStyle(
                                fontSize: 15, 
                              ),
                            
                            ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CODE 2',
                      style: TextStyle(
                                fontSize: 15, 
                              ),
                            textAlign: TextAlign.center,),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('GPS sensor hardware fault',
                      style: TextStyle(
                                fontSize: 15, 
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CODE 3',
                      style: TextStyle(
                                fontSize: 15, 
                              ),
                            textAlign: TextAlign.center,),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('All sensors working perfectly',
                      style: TextStyle(
                                fontSize: 15, 
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              TableRow(
                children: [
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('CODE 4',
                      style: TextStyle(
                                fontSize: 15, 
                              ),
                            textAlign: TextAlign.center,),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('GPS location not updating',
                      style: TextStyle(
                                fontSize: 15, 
                              ),
                           ),
                    ),
                  ),
                ],
              ),
              // Add more TableRow widgets for additional rows
            ],
                    ),
          ),
        ],
      ),
    );
  }
}
      