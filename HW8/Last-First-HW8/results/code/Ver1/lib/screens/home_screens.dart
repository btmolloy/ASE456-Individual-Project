import 'package:flutter/material.dart';
import '../models/time_entry.dart';
import '../services/firebase_service.dart';
import '../utils/task_utils.dart';
import 'record_time_screen.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _firebaseService = FirebaseService();
  List<TimeEntry> _upcomingTasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUpcomingTasks();
  }

  Future<void> _loadUpcomingTasks() async {
    setState(() => _isLoading = true);

    try {
      List<TimeEntry> tasks = await _firebaseService.getAllTasks();
      tasks = sortTasksByDateTime(tasks);
      setState(() {
        _upcomingTasks = tasks.take(5).toList();
      });
    } catch (e) {
      print('Error loading tasks: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteTask(String taskId) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _firebaseService.deleteTask(taskId);
      await _loadUpcomingTasks();
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
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SizedBox(height: 110),

            Text(
              'Upcoming Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(vertical: 5),
              width: MediaQuery.of(context).size.width * 0.6,
              height: 380,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _upcomingTasks.isEmpty
                  ? Center(child: Text('No upcoming tasks'))
                  : ListView.builder(
                itemCount: _upcomingTasks.length,
                itemBuilder: (context, index) {
                  final task = _upcomingTasks[index];
                  return Card(
                    color: Colors.blue,
                    child: ListTile(
                      title: Text(task.task, style: TextStyle(color: Colors.white)),
                      subtitle: Text(
                        '${task.date} - ${task.from} to ${task.to}',
                        style: TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(task.tag, style: TextStyle(color: Colors.white)),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red[200]),
                            onPressed: () => _deleteTask(task.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RecordTimeScreen()),
                  ),
                  icon: Icon(Icons.add, color: Colors.blue),
                  label: Text('Add Task', style: TextStyle(color: Colors.blue)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: Colors.blue, width: 1),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
