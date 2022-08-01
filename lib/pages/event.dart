import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

class EventTestPage extends StatefulWidget {
  const EventTestPage({Key? key}) : super(key: key);

  @override
  State<EventTestPage> createState() => _EventTestPageState();
}

class _EventTestPageState extends State<EventTestPage> {
  late MyEventBus event;
  int intValue = 0;

  @override
  void initState() {
    super.initState();
    event = MyEventBus.getInstance();
    event.on<DataChangeEvent<int>>().listen((event) {
      print(event);
    });
    event.on<DataChangeEvent<double>>().listen((event) {
      print(event);
    });
    event.on<DataChangeEvent<String>>().listen((event) {
      print(event);
    });
    event.on<DataChangeEvent<Map<String, String>>>().listen((event) {
      print(event);
    });
    event.on<DataChangeEvent<Map<String, int>>>().listen((event) {
      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('event bus')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  event.fire(DataChangeEvent<int>(intValue++));
                },
                child: const Text('int event')),
            ElevatedButton(
                onPressed: () {
                  event.fire(DataChangeEvent<String>((intValue++).toString()));
                },
                child: const Text('String event')),
            ElevatedButton(
                onPressed: () {
                  event.fire(DataChangeEvent<double>((intValue++).toDouble()));
                },
                child: const Text('double event')),
            ElevatedButton(
                onPressed: () {
                  event.fire(DataChangeEvent<Map<String, String>>(
                      {"string": (intValue++).toString()}));
                },
                child: const Text('Map<String, String> event')),
            ElevatedButton(
                onPressed: () {
                  event.fire(DataChangeEvent<Map<String, int>>(
                      {"string": intValue++}));
                },
                child: const Text('Map<String, int> event')),
          ],
        ),
      ),
    );
  }
}

class DataChangeEvent<T> {
  T? data;

  DataChangeEvent(this.data);

  @override
  String toString() {
    return "Event<$T ${data.toString()}>";
  }
}

class MyEventBus extends EventBus {
  static MyEventBus? instance;
  static MyEventBus getInstance() {
    instance ??= MyEventBus();
    return instance!;
  }
}
