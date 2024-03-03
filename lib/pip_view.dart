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
                Get.to(
                  () => const SwiftUIPipView(),
                );
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
