import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
Duration durer = Duration(seconds: 2);
Duration durerEnd = Duration(seconds: 16);
String text = '';
List<dynamic> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    periodicCode(durer, durerEnd);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress bar'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 100),
            height: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SimpleAnimationProgressBar(
                    height: 30,
                    width: 300,
                    backgroundColor: Colors.grey,
                    foregrondColor: Colors.green,
                    ratio: 1,
                    direction: Axis.horizontal,
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: const Duration(seconds: 15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 25,right: 25),
                    separatorBuilder: (context, index) => Divider(height: 20, color: Colors.green,),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text('${items[index]}'),
        
                      );
                    },
                    itemCount: items.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  void periodicCode(Duration periodicDuration, Duration endTimer) {

    var counter = 5;

    // immediately
    Timer(Duration(seconds: 0), () {
      print("This line is printed immediately");
      setState(() {
        text = 'Bonjour';
        items.add(text);
        print(items);
      });
    });


    //periodic
    Timer.periodic(const Duration(seconds: 10), (timer) {
      print(timer.tick);
      counter--;
      setState(() {
        text = 'Bonjour';
        items.add(text);
        print(items);
      });
      if (counter == 0) {
        print('Cancel timer');
        timer.cancel();
      }
    });
  }

}
