import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:track_elephants/Pages/About.dart';
import 'package:track_elephants/Pages/RecordsPage.dart';
import 'package:track_elephants/firebase_options.dart';
import 'Pages/AddRecord.dart';
import 'Pages/Device.dart';
import 'Pages/EmergencyContact.dart';
import 'Pages/ReportPage.dart';
import 'widgets/itemDashboard.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: Home()));
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

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
          Image.asset(
            'assets/The_Common_Wanderer_-9889.jpg',
            width: 600,
            height: 160,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Container(
              // color: Color.fromRGBO(13, 146, 118, 5),
              height: 100.0,
              child: Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(20),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 40,
                  mainAxisSpacing: 30,
                  children: [
                    itemDashboard('Add Record', Icons.post_add_outlined,
                        Colors.lightGreen, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRecord()),
                      );
                    }),
                    itemDashboard('Records', Icons.insert_comment_outlined,
                        Colors.lightGreen, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecordsPage()),
                      );
                    }),
                    itemDashboard(
                        'Device', Icons.build_outlined, Colors.lightGreen, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Device()),
                      );
                    }),
                    itemDashboard(
                        'Report', Icons.report_outlined, Colors.lightGreen, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportPage()),
                      );
                    }),
                    itemDashboard(
                        'Emergency', Icons.sos, Colors.lightGreen, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EmergencyContactPage()),
                      );
                    }),
                    
                    itemDashboard(
                        'About Us', Icons.help_center_outlined, Colors.lightGreen, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutUsPage()),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
