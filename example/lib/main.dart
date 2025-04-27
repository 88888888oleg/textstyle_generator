import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:untitled/palette.dart';
import 'package:untitled/textstyle_generator_trigger.dart';

void main() {
  // Configure brightness settings in the Palette class and set up a listener
  _configureDispatcher();
  // Run the application
  runApp(const MyApp());
}

void _configureDispatcher() {
  final dispatcher = WidgetsBinding.instance.platformDispatcher;
  _configureBrightness(dispatcher: dispatcher);
  dispatcher.onPlatformBrightnessChanged = () {
    _configureBrightness(dispatcher: dispatcher);
  };
}

void _configureBrightness({required PlatformDispatcher dispatcher}) {
  Palette().brightness = dispatcher.platformBrightness;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        /// You can use the generated text styles directly
        title: Text(widget.title, style: TextStyles.ubuntu18w400i()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              /// You can use text styles with parameters
              style: TextStyles.ubuntu16w400(h: 1.15),
            ),
            /// If there are not enough parameters, you can use copyWith()
            Text(
              '$_counter',
              style: TextStyles.ubuntu10w300l().copyWith(wordSpacing: 2),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}