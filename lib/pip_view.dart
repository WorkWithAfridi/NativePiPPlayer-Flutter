import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class FlutterPipView extends StatelessWidget {
  const FlutterPipView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("This is done in flutter"),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                if (Platform.isIOS) {
                  Get.to(
                    () => SwiftUIPipView(
                      mode: "pip",
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Native swift code can only be run on iOS devices."),
                  ));
                }
              },
              child: const Text('PIP-SWIFTUI'),
            ),
            ElevatedButton(
              onPressed: () {
                if (Platform.isIOS) {
                  Get.to(
                    () => SwiftUIPipView(
                      mode: "background-play",
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Native swift code can only be run on iOS devices."),
                  ));
                }
              },
              child: const Text('PIP-SWIFTUI'),
            )
          ],
        ),
      ),
    );
  }
}

class SwiftUIPipView extends StatelessWidget {
  SwiftUIPipView({
    super.key,
    required this.mode,
  });

  String mode;

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
              height: 300,
              child: UiKitView(
                viewType: 'swiftui_integration',
                creationParams: {
                  'link': "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
                  'duration': const Duration(minutes: 2).inMilliseconds,
                  'mode': mode,
                },
                creationParamsCodec: const StandardMessageCodec(),
                onPlatformViewCreated: (id) {
                  // You can communicate with the Swift code here if needed
                },
              ),
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                Gap(8),
                Text(
                  "Please wait for the video to load, before continuing.",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
