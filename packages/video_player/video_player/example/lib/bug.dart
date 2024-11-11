import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BugDemo extends StatelessWidget {
  const BugDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _BumbleBeeRemoteVideo(),
      ),
    );
  }
}

class _BumbleBeeRemoteVideo extends StatefulWidget {
  @override
  _BumbleBeeRemoteVideoState createState() => _BumbleBeeRemoteVideoState();
}

class _BumbleBeeRemoteVideoState extends State<_BumbleBeeRemoteVideo> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4'),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize();
    _controller.setVolume(0);
    _controller.play();
    _controller.addListener(
      () => print(_controller.value.hasError ? 'Error' : 'No error'),
    );
  }

  bool isFullScreen = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player = VideoPlayer(_controller);
    return Center(
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: SizedBox(
          width: 200,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              // if (!isFullScreen)
              Align(
                child: SizedBox(width: 200, child: player),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: IconButton(
                  icon: const Icon(Icons.fullscreen),
                  onPressed: () {
                    setState(() {
                      isFullScreen = true;
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: <Widget>[
                                player,
                                Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: IconButton(
                                    icon: const Icon(Icons.fullscreen),
                                    onPressed: () {
                                      setState(() {
                                        isFullScreen = false;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
