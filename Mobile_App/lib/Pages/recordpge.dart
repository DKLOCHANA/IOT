import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:track_elephants/models/detection.dart';
import 'package:intl/intl.dart'; // Import DateFormat for date formatting

class RecordsPage extends StatefulWidget {
  const RecordsPage({Key? key}) : super(key: key);

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  String _selectedOption = 'Today'; // Default selected option
  late DateTime _today; // Variable to store today's date

  @override
  void initState() {
    super.initState();
    _today = DateTime.now(); // Get today's date
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
          Row(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.history_edu),
                    SizedBox(width: 10),
                    Text("Records History", style: TextStyle(fontSize: 20,))
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: DropdownButton<String>(
                  value: _selectedOption,
                  items: <String>['Today', 'All']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedOption = value!;
                    });
                  },
                ),
              )
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _selectedOption == 'Today'
                  ? FirebaseFirestore.instance
                      .collection('Detections_mobile')
                      .where('detected_date',
                          isEqualTo: DateFormat('yyyy-MM-dd').format(_today))
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('Detections_mobile')
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No records found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final record = Detections.fromMap(
                        snapshot.data!.docs[index].data()
                            as Map<String, dynamic>);
                    return ListTile(
                      title: Text('Elephant detected at location'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${record.detectedDate}'),
                          Text('Time: ${record.detectedTime}'),
                          Text('Distance: ${record.distance}'),
                          Text('comment: ${record.comment}'),
                          Text('longitude: ${record.longitude}'),
                          Text('latitude: ${record.latitude}'),
                         
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
