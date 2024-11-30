import 'package:flutter/material.dart';
import 'record_time_screen.dart';
import 'query_time_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Personal Time Manager')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecordTimeScreen())),
              child: Text('Record Time'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => QueryTimeScreen())),
              child: Text('Query Time'),
            ),
          ],
        ),
      ),
    );
  }
}
