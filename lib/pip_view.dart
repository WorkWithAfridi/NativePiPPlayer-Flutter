import 'dart:io';

import 'package:floating/floating.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class FlutterPipView extends StatefulWidget {
  const FlutterPipView({super.key});

  @override
  State<FlutterPipView> createState() => _FlutterPipViewState();
}

class _FlutterPipViewState extends State<FlutterPipView> with WidgetsBindingObserver {
  late VideoPlayerController _controller;
  final floating = Floating();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      ),
    )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    floating.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Platform.isAndroid) {
      if (state == AppLifecycleState.inactive) {
        floating.enable();
        _controller.play();
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  Future enablePip() async {
    final status = await floating.enable();
    print("Enabled pip: $status");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _controller.value.isInitialized
                  ? Column(
                      children: [
                        AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(
                            _controller,
                          ),
                        ),
                        SizedBox(
                          width: Get.width,
                          child: VideoProgressIndicator(
                            _controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.pink,
                              bufferedColor: Colors.grey,
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
              const Gap(12),
              ElevatedButton(
                onPressed: () {
                  if (Platform.isIOS) {
                    print("Current duration: ${_controller.value.position}");
                    _controller.pause();
                    Get.to(
                      () => SwiftUIPipView(
                        mode: "pip",
                        duration: _controller.value.position.inMilliseconds,
                      ),
                    );
                  } else {
                    enablePip();
                  }
                },
                child: const Text('START-PIP'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (Platform.isIOS) {
                    Get.to(
                      () => SwiftUIPipView(
                        mode: "background-play",
                        duration: const Duration(seconds: 0).inMilliseconds,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Native swift code can only be run on iOS devices."),
                    ));
                  }
                },
                child: const Text('START-BG-PLAY'),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying ? _controller.pause() : _controller.play();
                    });
                  },
                  icon: Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class SwiftUIPipView extends StatelessWidget {
  SwiftUIPipView({
    super.key,
    required this.mode,
    required this.duration,
  });

  String mode;
  int duration;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              child: UiKitView(
                viewType: 'swiftui_integration',
                creationParams: {
                  'link': "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                  'duration': duration,
                  'mode': mode,
                },
                creationParamsCodec: const StandardMessageCodec(),
                onPlatformViewCreated: (id) {
                  // You can communicate with the Swift code here if needed
                },
              ),
            ),
            // const Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Icon(
            //       Icons.info,
            //       color: Colors.white,
            //     ),
            //     Gap(8),
            //     Text(
            //       "Please wait for the video to load, before continuing.",
            //       style: TextStyle(color: Colors.white),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
