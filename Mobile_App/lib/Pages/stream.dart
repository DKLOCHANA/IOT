import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class LivestreamScreen extends StatefulWidget {
  const LivestreamScreen({Key? key}) : super(key: key);

  @override
  _LivestreamScreenState createState() => _LivestreamScreenState();
}

class _LivestreamScreenState extends State<LivestreamScreen> {
  late final VlcPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VlcPlayerController.network(
      'rtsp://192.168.8.130/live/ch00_0',
      //hwAcc: HwAcc.full,
      autoPlay: true,
      options: VlcPlayerOptions(),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Icon(Icons.video_camera_front_outlined),
                      SizedBox(width: 10),
                      Text(
                        "Live Feed",
                        style: TextStyle(fontSize: 20,),
                      ),
                    ],
                  ),
                ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
               "Please allow 5-10 seconds to load the livestream.Don't press back button.",
               style: TextStyle(fontSize: 14,),
               ),
          ),
          SizedBox(height: 10),
          
          VlcPlayer(
            controller: _videoPlayerController,
            aspectRatio: 16 / 9,
            placeholder: const Center(
              child: CircularProgressIndicator(),
              
            ),
          ),
        ],
      ),
    );
  }
}
