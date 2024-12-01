import '../models/time_entry.dart';
import 'package:intl/intl.dart';

/// Sort tasks by date and time (earliest first)
List<TimeEntry> sortTasksByDateTime(List<TimeEntry> tasks) {
  final dateFormat = DateFormat('yyyy/MM/dd h:mm a'); // Define the custom format

  tasks.sort((a, b) {
    try {
      // Parse the combined date and time
      DateTime dateTimeA = dateFormat.parse('${a.date} ${a.from}');
      DateTime dateTimeB = dateFormat.parse('${b.date} ${b.from}');

      return dateTimeA.compareTo(dateTimeB); // Sort by date and time
    } catch (e) {
      print('Error parsing task dates: $e');
      return 0; // Treat unparsable tasks as equal
    }
  });
  return tasks;
}

/// Filter tasks based on a search query
List<TimeEntry> filterTasksByQuery(List<TimeEntry> tasks, String query) {
  if (query.isEmpty) return tasks; // Return all tasks if the query is empty
  return tasks.where((task) {
    return task.task.toLowerCase().contains(query.toLowerCase()) ||
        task.date.contains(query) ||
        task.tag.toLowerCase().contains(query);
  }).toList();
}

/// Calculate total time spent per tag
Map<String, Duration> calculateTimeByTag(List<TimeEntry> tasks) {
  final Map<String, Duration> timeByTag = {};
  final dateFormat = DateFormat('yyyy/MM/dd h:mm a'); // Custom date format

  for (var task in tasks) {
    try {
      // Parse start and end times
      final startTime = dateFormat.parse('${task.date} ${task.from}');
      final endTime = dateFormat.parse('${task.date} ${task.to}');
      final duration = endTime.difference(startTime);

      // Add to the tag's total duration
      final tag = task.tag.toLowerCase(); // Make tags case-insensitive
      if (timeByTag.containsKey(tag)) {
        timeByTag[tag] = timeByTag[tag]! + duration;
      } else {
        timeByTag[tag] = duration;
      }
    } catch (e) {
      print('Error calculating time for task "${task.task}": $e');
    }
  }

  return timeByTag;
}
