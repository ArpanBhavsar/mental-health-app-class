import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

class DemoAIScreen extends StatefulWidget {
  const DemoAIScreen({super.key});

  @override
  State<DemoAIScreen> createState() => _DemoAIScreenState();
}

class _DemoAIScreenState extends State<DemoAIScreen> {
  String _output = "";
  StreamSubscription? _streamSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Gemini.instance
              .promptStream(
                parts: [Part.text('Write a story about a magic backpack')],
              )
              .listen((value) {
                setState(() {
                  _output += value?.output ?? '';
                });
              })
              .onDone(() => _streamSubscription?.cancel());
        },

        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: LiquidLinearProgressIndicator(
                    value: 0.25, // Defaults to 0.5.
                    valueColor: AlwaysStoppedAnimation(
                      Colors.pink,
                    ), // Defaults to the current Theme's accentColor.
                    backgroundColor:
                        Colors
                            .white, // Defaults to the current Theme's backgroundColor.
                    borderColor: Colors.red,
                    borderWidth: 5.0,
                    borderRadius: 12.0,
                    direction:
                        Axis.horizontal, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                    center: Text("Loading..."),
                  ),
                ),
                Text(_output.isEmpty ? 'Demo AI Screen' : _output),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }
}
