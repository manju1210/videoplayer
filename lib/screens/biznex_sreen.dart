
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool err = false;
  String msgErr = '';
  String? businessName;
  int selectedCategoryIndex =0;

  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
      _initializeVideoPlayerFuture = _controller!.initialize();
      // Use the controller to loop the video.
      // _controller!.setLooping(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;//await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),);
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.blueGrey,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20.0,top: 20.0),
              child: ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemBuilder: (context,index){
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 15,top: 20,right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("date"),
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {

                                        });
                                      },
                                      child: Container(
                                        child: Icon(Icons.info),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Text("title"),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Icon(Icons.info),
                                    const SizedBox(width: 5,),
                                    Text("45 min"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 17,),
                          Stack(
                            children: [
                              _controller == null ?  const SizedBox(
                                height: 160, child: Icon(Icons.info,color: Colors.transparent,),
                              ) : GestureDetector(
                                onTap: (){
                                  setState(() {
                                    getVideo();
                                  });
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: FutureBuilder(
                                    future: _initializeVideoPlayerFuture,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        // If the VideoPlayerController has finished initialization, use
                                        // the data it provides to limit the aspect ratio of the video.
                                        return AspectRatio(
                                          aspectRatio: _controller!.value.aspectRatio,
                                          // Use the VideoPlayer widget to display the video.
                                          child: VideoPlayer(_controller!),
                                        );
                                      } else {
                                        // If the VideoPlayerController is still initializing, show a
                                        // loading spinner.
                                        return SizedBox(height: 150,child: Center(child: CircularProgressIndicator(strokeWidth: 1.5,color: Colors.black,)));
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 50,left: 170,
                                child: GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      // If the video is playing, pause it.
                                      if(_controller == null){
                                        print("Video not found");
                                      }
                                      else{

                                        if (_controller!.value.isPlaying) {
                                          _controller!.pause();
                                        } else {
                                          // If the video is paused, play it.
                                          _controller!.play();
                                        }
                                      }

                                    });
                                  },
                                  child:  Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 15,top: 20,right: 10),
                  //   child: Stack(
                  //     children: [
                  //       _controller == null ?  const SizedBox(
                  //         height: 160, child: Icon(Icons.info,color: Colors.transparent,),
                  //       ) : GestureDetector(
                  //         onTap: (){
                  //           setState(() {
                  //             getVideo();
                  //           });
                  //         },
                  //         child: SizedBox(
                  //           width: MediaQuery.of(context).size.width,
                  //           child: FutureBuilder(
                  //             future: _initializeVideoPlayerFuture,
                  //             builder: (context, snapshot) {
                  //               if (snapshot.connectionState == ConnectionState.done) {
                  //                 // If the VideoPlayerController has finished initialization, use
                  //                 // the data it provides to limit the aspect ratio of the video.
                  //                 return AspectRatio(
                  //                   aspectRatio: _controller!.value.aspectRatio,
                  //                   // Use the VideoPlayer widget to display the video.
                  //                   child: VideoPlayer(_controller!),
                  //                 );
                  //               } else {
                  //                 // If the VideoPlayerController is still initializing, show a
                  //                 // loading spinner.
                  //                 return SizedBox(height: 150,child: Center(child: CircularProgressIndicator(strokeWidth: 1.5,color: Colors.black,)));
                  //               }
                  //             },
                  //           ),
                  //         ),
                  //       ),
                  //       Positioned(
                  //         top: 50,left: 170,
                  //         child: GestureDetector(
                  //           onTap: (){
                  //             setState(() {
                  //               // If the video is playing, pause it.
                  //               if(_controller == null){
                  //                 print("Video not found");
                  //               }
                  //               else{
                  //
                  //                 if (_controller!.value.isPlaying) {
                  //                   _controller!.pause();
                  //                 } else {
                  //                   // If the video is paused, play it.
                  //                   _controller!.play();
                  //                 }
                  //               }
                  //
                  //             });
                  //           },
                  //           child:  Icon(_controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }


  Future getVideo() async {
    _controller = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller!.play();
        });
      });
    _initializeVideoPlayerFuture = _controller!.initialize();
    // Use the controller to loop the video.
    _controller!.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller!.dispose();
    super.dispose();
  }

}
