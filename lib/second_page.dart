import 'dart:async';

import 'package:flutter/material.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  bool shouldPop = false;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        print("didPop: $didPop, result: $result");
        if (didPop) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          shouldPop = true;
        });

        if (context.mounted && [null, false].contains(timer?.isActive)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Click back button again to go back"),
              duration: Duration(milliseconds: 800),
            ),
          );
        }
        if (timer?.isActive == true && context.mounted && shouldPop) {
          Navigator.pop(context, result);
          return;
        }

        timer = Timer(const Duration(milliseconds: 800), () {
          if (!context.mounted) return;
          shouldPop = false;
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("S E C O N D   P A G E"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          // leading: IconButton(
          //     onPressed: () {
          //       // Navigator.maybePop(context);
          //     },
          //     icon: Icon(Icons.adaptive.arrow_back)),
        ),
        body: Center(
          child: Column(
            spacing: 24,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Second page'),
              // Text("Should pop: $shouldPop"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, "Popping context...");
                },
                child: Text("Go back"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
