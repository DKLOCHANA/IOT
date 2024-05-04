// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class AboutUsPage extends StatelessWidget {


  AboutUsPage({Key? key});

  
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
                Icon(Icons.help_center_outlined),
                SizedBox(width: 10),
                Text(
                  "About Us",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding:  EdgeInsets.all(15.0),
            child: Container(
              child: Text('Founded by a dedicated group of university students, ELEPHANT PULSE is a non-profit organization deeply committed to the preservation of wildlife and the enhancement of public safety. Our organization operates with a singular mission: to mitigate elephant-related accidents along the North Railway Line.At ELEPHANT PULSE, we recognize the critical need to protect both human lives and the majestic elephants that inhabit our region. Elephant accidents not only pose a threat to the safety of commuters but also result in devastating consequences for the wildlife population and local communities. With this in mind, our team has embarked on a noble endeavor to address this pressing issue.Our flagship project revolves around the development and implementation of a groundbreaking mobile application. Leveraging cutting-edge technology, our app utilizes advanced detection algorithms to identify the presence of elephants in proximity to railway tracks. Upon detection, real-time alerts are dispatched to train operators and relevant authorities, enabling prompt action to prevent potential collisions.Driven by a sense of duty and compassion, ELEPHANT PULSE stands at the forefront of wildlife conservation efforts in our region. Through collaborative partnerships with governmental agencies, railway authorities, and environmental organizations, we strive to enact meaningful change and foster a safer environment for all.Join us in our unwavering commitment to safeguarding lives, protecting wildlife habitats, and fostering harmony between humans and elephants. Together, we can make a profound impact and pave the way for a brighter, safer future.',
                style: TextStyle(
                fontSize: 14, 
                
              ),
              
              ),
            ),
          ),


      ],)
    );
  }
}
