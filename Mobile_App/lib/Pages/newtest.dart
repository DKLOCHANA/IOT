import 'package:flutter/material.dart';

class RecordPage extends StatelessWidget {
  final String driverId;
  final String coDriverId;
  final String trainNo;
  final String location;
  final String comment;

  RecordPage({
    required this.driverId,
    required this.coDriverId,
    required this.trainNo,
    required this.location,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record'),
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Driver ID: $driverId'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Co-Driver ID: $coDriverId'),
                Text('Train Number: $trainNo'),
                Text('Location: $location'),
                Text('Comment: $comment'),
              ],
            ),
          );
        },
      ),
    );
  }
}
