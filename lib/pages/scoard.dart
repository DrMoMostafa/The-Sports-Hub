import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Scoard extends StatefulWidget {
  const Scoard({
    super.key,
  });

  @override
  State<Scoard> createState() => _ScoardState();
}

class _ScoardState extends State<Scoard> {
  int _counterplus = 0;
  int _counterminus = 0;
  Duration duration = Duration();
  Timer? timer;
  bool started = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counterplus++;
    });
  }

  void start() {
    started = true;
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  void reset() {
    setState(() {
      duration = Duration();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: [
                    Text(
                      'HOME',
                      style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _counterplus < 1
                                    ? _counterplus = 0
                                    : _counterplus--;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                '-1',
                                style: TextStyle(
                                    fontSize: 35, color: Colors.white),
                              ),
                            )),
                        TextButton(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10)),
                            height: 190,
                            width: 200,
                            child: Center(
                                child: Text('$_counterplus',
                                    style: TextStyle(
                                        fontSize: 100, color: Colors.white))),
                          ),
                          onPressed: _incrementCounter,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    buildTime(),
                    Row(
                      children: [
                        RawMaterialButton(
                            shape: const StadiumBorder(
                                side: BorderSide(
                                    color: Colors.black, strokeAlign: 10)),
                            onPressed: () {
                              (!started) ? start() : stopTimer();
                            },
                            child: Text(
                              (!started) ? 'Start' : 'Pause',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                        SizedBox(
                          width: 25,
                        ),
                        RawMaterialButton(
                            shape: const StadiumBorder(
                                side: BorderSide(
                                    color: Colors.black, strokeAlign: 10)),
                            onPressed: () {
                              reset();
                              _counterplus = 0;
                              _counterminus = 0;
                            },
                            child: Text('Reset',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Text('GUEST',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                _counterminus < 1
                                    ? _counterminus = 0
                                    : _counterminus--;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                '-1',
                                style: TextStyle(
                                    fontSize: 35, color: Colors.white),
                              ),
                            )),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _counterminus++;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                                child: Text(
                                  '$_counterminus',
                                  style:
                                  TextStyle(color: Colors.white, fontSize: 100),
                                )),
                            height: 190,
                            width: 200,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ));
  }

  buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final hours = twoDigits(duration.inHours.remainder(60));
    return Text(
      '$hours:$minutes:$seconds',
      style: TextStyle(
          fontSize: 40, color: Colors.teal, fontWeight: FontWeight.bold),
    );
  }

  addTime() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer() {
    timer!.cancel();
    setState(() {
      started = false;
    });
  }
}
