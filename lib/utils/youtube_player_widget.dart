import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class OptimizedYouTubePlayerWidget extends StatefulWidget {
  final String videoId;

  const OptimizedYouTubePlayerWidget({Key? key, required this.videoId}) : super(key: key);

  @override
  _OptimizedYouTubePlayerWidgetState createState() => _OptimizedYouTubePlayerWidgetState();
}

class _OptimizedYouTubePlayerWidgetState extends State<OptimizedYouTubePlayerWidget> {
  late Future<YoutubePlayerController> _controllerFuture;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _initializeController();
  }

  Future<YoutubePlayerController> _initializeController() async {
    return YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<YoutubePlayerController>(
      future: _controllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: snapshot.data!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: Colors.blueAccent,
              progressColors: const ProgressBarColors(
                playedColor: Colors.blue,
                handleColor: Colors.blueAccent,
              ),
              onReady: () {
                print('Player is ready.');
              },
            ),
            builder: (context, player) {
              return Column(
                children: [
                  player,

                ],
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _controllerFuture.then((controller) => controller.dispose());
    super.dispose();
  }
}