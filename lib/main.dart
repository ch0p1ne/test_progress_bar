import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import 'package:http/http.dart' as http;

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
  double currentStep = 0.0;
  dynamic dataWeather;

  String appId = '4b474d97362c293c477bf5e0efc82840';
  List<String> location = ['London', 'France', 'Senegal', 'Maroc', 'Italy'];
  String currentLimit = '1';
  int locationLimit = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    periodicCode(durer, durerEnd);
    print(location[locationLimit]);
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StepProgressIndicator(
                        totalSteps: 100,
                        currentStep: currentStep.floor(),
                        size: 16,
                        padding: 0,
                        selectedColor: Colors.green,
                        unselectedColor: Colors.grey.shade300,
                        roundedEdges: Radius.circular(15),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Container(
                        child: Text(
                          currentStep.floor().toString() + ' %',
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    separatorBuilder: (context, index) => Divider(
                      height: 20,
                      color: Colors.green,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Text('${items[index]['name']}'),
                            SizedBox(
                              width: 10,
                            ),
                            Text(' LAT : ${items[index]['lat']}'),
                          ],
                        ),
                      );
                    },
                    itemCount: dataWeather == null ? 0 : items.length,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void periodicCode(Duration periodicDuration, Duration endTimer) async {
    var counter = 5;
    var counterProgressBar = 60;
    Uri url = Uri.https('api.openweathermap.org', '/geo/1.0/direct', {
      'q': '${location[locationLimit]}',
      'limit': '$currentLimit',
      'appid': '$appId'
    });
    locationLimit++;
    var response = await http.get(url);

    // immediately
    Timer(Duration(seconds: 0), () {
      print("This line is printed immediately");
      setState(() {
        if (response.statusCode == 200) {
          dataWeather = jsonDecode(response.body) as List<dynamic>;
          items.addAll(dataWeather);
        } else {
          print('Resquest failed with status : ${response.statusCode}');
        }
      });
    });

    //periodic
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      print(timer.tick);
      counter--;
      if (locationLimit <= location.length) {
        url = Uri.https('api.openweathermap.org', '/geo/1.0/direct', {
          'q': '${location[locationLimit]}',
          'limit': '$currentLimit',
          'appid': '$appId'
        });
        response = await http.get(url);
        locationLimit++;

        setState(() {
          print(url);
          if (response.statusCode == 200) {
            dataWeather = jsonDecode(response.body) as List<dynamic>;
            items.addAll(dataWeather);
          } else {
            print('Resquest failed with status : ${response.statusCode}');
          }
        });
      }
      if (counter == 0) {
        print('Cancel timer for api call');
        timer.cancel();
      }
    });

    //periodic timer for progress bar
    Timer.periodic(const Duration(seconds: 2), (timer) {
      print(timer.tick);
      counterProgressBar = counterProgressBar - 2;
      setState(() {
        currentStep = currentStep + 4;
      });
      if (counter == 0) {
        print('Cancel timer for progress bar');
        timer.cancel();
      }
    });
  }
}
