import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportPage extends StatelessWidget {
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
                Icon(Icons.bar_chart_outlined),
                SizedBox(width: 10),
                Text(
                  "Monthly Report",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Detections_mobile')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              final data = snapshot.data;
              if (data == null || data.docs.isEmpty) {
                return Center(child: Text('No report available'));
              }
              final cctvRecords = data.docs.where((doc) => doc['username'] == 'CCTV');
              final totalCount = cctvRecords.length;
              var highestManualCount = 0;
              var highestManualLocation = '';
              final manualRecords = data.docs.where((doc) => doc['username'] != 'CCTV');
              final manualRecordCounts = <String, int>{};
              for (final doc in manualRecords) {
                final location = doc['location'];
                final count = (manualRecordCounts[location] ?? 0) + 1;
                manualRecordCounts[location] = count;
                if (count > highestManualCount) {
                  highestManualCount = count;
                  highestManualLocation = location;
                }
              }
              final manualMessage = highestManualLocation.isNotEmpty
                  ? ' $highestManualLocation '
                  : 'No manual records available';
              final manualMessage1 = highestManualLocation.isNotEmpty
                  ? '( $highestManualCount records )'
                  : 'No manual records available';
              final cctvMessage =
                  ' $totalCount detections';
              return Center(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(10),
                          // color: Colors.grey[200],
                        ),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            
                            SizedBox(height: 10),
                            Text(
                              'Highest number of manual records reported in :',
                              style: TextStyle(
                                fontSize: 17,
                                
                              ),
                            ),
                            
                            SizedBox(height: 10),
                            Text(
                              manualMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            Text(
                              manualMessage1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            
                            SizedBox(height: 20),
                            
                            Text(
                              'Total number of CCTV detections :',
                              style: TextStyle(
                                fontSize: 17,  
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              cctvMessage,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              )
                            ),
                            SizedBox(height: 40),
                            
                    
                            Text(
                              '(1) We recommend establishing additional CCTV establishments in areas with the highest number of manual records reported. This measure aims to enhance surveillance and monitoring, potentially deterring manual record incidents and promoting safety and security within those areas.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,

                              )
                            ),
                            SizedBox(height: 10),
                            Text(
                              '(2) We suggest considering revisions to speed limits in locations with a high number of CCTV detections. This evaluation enables adjustments to speed limits, ensuring road safety and reducing the probability of accidents.',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,

                              )
                            ),

                          ],
                        ),
                      ),
                    );

                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                
              