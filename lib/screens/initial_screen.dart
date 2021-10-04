import 'package:flutter/material.dart';

class InitialScreen extends StatelessWidget {
  // const InitialScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Application for Eclipse')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () async {
              Navigator.pushNamed(context, '/listOfUsers');
            },
            child: const Text('List Of Users'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/userPage');
            },
            child: const Text('User Page'),
          ),
        ],
      ),
    );
  }
}
