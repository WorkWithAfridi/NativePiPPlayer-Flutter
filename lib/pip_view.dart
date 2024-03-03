import 'dart:io';

import 'package:flutter/material.dart';
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
                    () => const SwiftUIPipView(),
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
  const SwiftUIPipView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: Get.width,
        height: Get.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400,
              // child: UiKitView(
              //   viewType: "swiftui_integration",
              //   layoutDirection: TextDirection.ltr,
              //   creationParams: const {},
              //   creationParamsCodec: const StandardMessageCodec(),
              //   onPlatformViewCreated: (int id) {},
              // ),
              child: UiKitView(
                viewType: 'swiftui_integration',
                onPlatformViewCreated: (id) {
                  // You can communicate with the Swift code here if needed
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
