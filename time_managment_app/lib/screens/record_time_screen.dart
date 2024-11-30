import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/time_entry.dart';
import '../services/firebase_service.dart';

class RecordTimeScreen extends StatelessWidget {
  final _dateController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _taskController = TextEditingController();
  final _tagController = TextEditingController();
  final _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Record Time')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _dateController, decoration: InputDecoration(labelText: 'Date (YYYY/MM/DD)')),
            TextField(controller: _fromController, decoration: InputDecoration(labelText: 'From (HH:MM AM/PM)')),
            TextField(controller: _toController, decoration: InputDecoration(labelText: 'To (HH:MM AM/PM)')),
            TextField(controller: _taskController, decoration: InputDecoration(labelText: 'Task')),
            TextField(controller: _tagController, decoration: InputDecoration(labelText: 'Tag')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final entry = TimeEntry(
                  id: Uuid().v4(),
                  date: _dateController.text,
                  from: _fromController.text,
                  to: _toController.text,
                  task: _taskController.text,
                  tag: _tagController.text,
                );
                await _firebaseService.addTimeEntry(entry);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
