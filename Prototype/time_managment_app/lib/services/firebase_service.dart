import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/time_entry.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<List<TimeEntry>> getAllTasks() async {
    try {
      final snapshot = await _db.collection('time_entries').get();
      print('Fetched documents: ${snapshot.docs.length}');
      return snapshot.docs.map((doc) {
        return TimeEntry.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching tasks: $e');
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<void> addTask(TimeEntry task) async {
    try {
      await _db.collection('time_entries').add(task.toMap());
      print('Task added successfully');
    } catch (e) {
      print('Error adding task: $e');
      throw Exception('Failed to add task');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _db.collection('time_entries').doc(taskId).delete();
      print('Task $taskId deleted successfully.');
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
