import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/time_entry.dart';
import '../services/firebase_service.dart';

class RecordTimeScreen extends StatefulWidget {
  @override
  _RecordTimeScreenState createState() => _RecordTimeScreenState();
}

class _RecordTimeScreenState extends State<RecordTimeScreen> {
  final _dateController = TextEditingController();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _taskController = TextEditingController();
  final _tagController = TextEditingController();
  final _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();

  String? _previewDate = "YYYY/MM/DD";
  String? _previewFrom = "HH:MM AM/PM";
  String? _previewTo = "HH:MM AM/PM";
  String? _previewTask = "Sample Task";
  String? _previewTag = "Sample Tag";

  @override
  void dispose() {
    _dateController.dispose();
    _fromController.dispose();
    _toController.dispose();
    _taskController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _updatePreview() {
    setState(() {
      _previewDate = _dateController.text.isNotEmpty ? _dateController.text : "YYYY/MM/DD";
      _previewFrom = _fromController.text.isNotEmpty ? _fromController.text : "HH:MM AM/PM";
      _previewTo = _toController.text.isNotEmpty ? _toController.text : "HH:MM AM/PM";
      _previewTask = _taskController.text.isNotEmpty ? _taskController.text : "Sample Task";
      _previewTag = _tagController.text.isNotEmpty ? _tagController.text : "Sample Tag";
    });
  }

  void _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final timeError = _validateFromToTime(
        _fromController.text,
        _toController.text,
      );
      if (timeError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(timeError)),
        );
        return;
      }

      try {
        final task = TimeEntry(
          id: Uuid().v4(),
          date: _dateController.text,
          from: _fromController.text,
          to: _toController.text,
          task: _taskController.text,
          tag: _tagController.text,
        );

        await _firebaseService.addTask(task);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Task added successfully!')),
        );

        _formKey.currentState!.reset();
        _updatePreview();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving task: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Personal Time Manager',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Tooltip(
                    message: 'Back',
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.blue),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Text(
                  'Add New Task',
                  style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Date (YYYY/MM/DD)',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateDate,
                      onChanged: (_) => _updatePreview(),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _fromController,
                      decoration: InputDecoration(
                        labelText: 'From Time (HH:MM AM/PM)',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateTime,
                      onChanged: (_) => _updatePreview(),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _toController,
                      decoration: InputDecoration(
                        labelText: 'To Time (HH:MM AM/PM)',
                        border: OutlineInputBorder(),
                      ),
                      validator: _validateTime,
                      onChanged: (_) => _updatePreview(),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        labelText: 'Task',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a task';
                        }
                        return null;
                      },
                      onChanged: (_) => _updatePreview(),
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                      controller: _tagController,
                      decoration: InputDecoration(
                        labelText: 'Tag',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a tag';
                        }
                        return null;
                      },
                      onChanged: (_) => _updatePreview(),
                    ),
                  ),
                  SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                    ),
                    child: Text(
                      'Save Task',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Card(
                color: Colors.blue,
                child: ListTile(
                  title: Text(
                    _previewTask!,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${_previewDate!} - ${_previewFrom!} to ${_previewTo!}',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: Text(
                    _previewTag!,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid date';
    }

    final dateFormat = DateFormat('yyyy/MM/dd');
    try {
      final date = dateFormat.parseStrict(value);
      if (date.isBefore(DateTime.now())) {
        return 'Date cannot be in the past';
      }
    } catch (_) {
      return 'Please enter a date in the format YYYY/MM/DD';
    }

    return null;
  }

  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid time';
    }

    final timeFormat = DateFormat('h:mm a');
    try {
      timeFormat.parseStrict(value);
    } catch (_) {
      return 'Please enter a time in the format HH:MM AM/PM';
    }

    return null;
  }

  String? _validateFromToTime(String? from, String? to) {
    final timeFormat = DateFormat('h:mm a');
    try {
      final fromTime = timeFormat.parseStrict(from!);
      final toTime = timeFormat.parseStrict(to!);
      if (toTime.isBefore(fromTime) || toTime.isAtSameMomentAs(fromTime)) {
        return 'End time must be after start time';
      }
    } catch (_) {
      return 'Please enter valid times in the format HH:MM AM/PM';
    }

    return null;
  }
}
