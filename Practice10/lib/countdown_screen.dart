import 'dart:async';

import 'package:flutter/material.dart';

import 'api/countdown.dart';

class CountdownScreen extends StatelessWidget {
  const CountdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Countdown'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Version A'),
              Tab(text: 'Version B'),
            ],
          ),
        ),
        body: const TabBarView(children: [CountdownA(), CountdownB()]),
      ),
    );
  }
}

// Version A: StreamBuilder manages subscription automatically.
class CountdownA extends StatelessWidget {
  const CountdownA({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: countdown(10),
      builder: (context, snapshot) {
        final value = snapshot.data ?? 10;

        return Center(
          child: Text(
            '$value',
            style: Theme.of(context).textTheme.displayLarge,
          ),
        );
      },
    );
  }
}

// Version B: manual subscription and cancellation.
class CountdownB extends StatefulWidget {
  const CountdownB({super.key});

  @override
  State<CountdownB> createState() => _CountdownBState();
}

class _CountdownBState extends State<CountdownB> {
  int _left = 10;

  late StreamSubscription<int> _sub;

  @override
  void initState() {
    super.initState();

    _sub = countdown(10).listen((i) {
      if (!mounted) return;

      setState(() {
        _left = i;
      });
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$_left', style: Theme.of(context).textTheme.displayLarge),
    );
  }
}
