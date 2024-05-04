import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddRecord extends StatefulWidget {
  @override
  _AddRecordState createState() => _AddRecordState();
}

class _AddRecordState extends State<AddRecord> {
  final _formKey = GlobalKey<FormState>();
  // Controllers
  TextEditingController _usernameController = TextEditingController();
  String? _selectedLocation; // Updated to allow null for initial state
  TextEditingController _commentController = TextEditingController();
  String? _locationErrorMessage;

  // Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      body: SingleChildScrollView( // SingleChildScrollView to enable scrolling if the content overflows
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,// Assign global key for form validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.on_device_training),
                    SizedBox(width: 10),
                    Text(
                      "Add New Record",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username *'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter username*';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Location *',
                  style: TextStyle(fontSize: 16),
                ),
                DropdownButton<String>(// DropdownButton for location selection
                  value: _selectedLocation,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedLocation = value;
                      _locationErrorMessage = null; // Clear error message when location is selected
                    });
                  },
                  // Mapping items to DropdownMenuItem
                  items: <String?>['Maho-Galgamuwa', 'Galgamuwa-Tambuththegama', 'Tambuththegama-Anuradhapura'].map<DropdownMenuItem<String>>((String? value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value ?? ''),
                    );
                  }).toList(),
                ),
                if (_locationErrorMessage != null) // Show error message if location is not selected
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4), // Adjust vertical padding as needed
                    child: Text(
                      _locationErrorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(height: 5),
                TextFormField(
                  controller: _commentController,
                  decoration: InputDecoration(labelText: 'Comment *'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a comment *';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_selectedLocation == null) {
                          setState(() {
                            _locationErrorMessage = 'Please select a location';
                          });
                        } else {
                          String username = _usernameController.text;
                          String location = _selectedLocation!;
                          String comment = _commentController.text;
                  
                          // Generate current date and time
                          DateTime now = DateTime.now();
                          String detectedDate = DateFormat('yyyy-MM-dd').format(now);
                          String detectedTime = DateFormat('HH:mm:ss').format(now);
                          String timestamp = DateFormat('yyyyMMdd-HHmmss').format(now);
                          //send data to firestore
                          _firestore.collection('Detections_mobile').add({
                            'username': username,
                            'location': location,
                            'comment': comment,
                            'detected_date': detectedDate,
                            'detected_time': detectedTime,
                            'distance': "Visible range",
                            'timestamp': timestamp,
                            'latitude': 'Unknown',
                            'longitude': 'Unknown',
                          }).then((_) {
                            // Clear fields and selections after successful submission
                            _usernameController.clear();
                            _selectedLocation = null;
                            _commentController.clear();
                            _locationErrorMessage = null;
        
                            setState(() {
                              _selectedLocation = null; // Clear the dropdown selection
                            });
        
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Submitted successfully!'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }).catchError((error) {
                            print('Failed to add record: $error');
                          });
                        }
                      }
                    },
                    child: Text('Submit', style: TextStyle(color: Colors.green, fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
