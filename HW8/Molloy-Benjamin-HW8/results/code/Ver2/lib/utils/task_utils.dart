import '../models/time_entry.dart';
import 'package:intl/intl.dart';

/// Sort tasks by date and time (earliest first)
List<TimeEntry> sortTasksByDateTime(List<TimeEntry> tasks) {
  final dateFormat = DateFormat('yyyy/MM/dd h:mm a');

  tasks.sort((a, b) {
    try {
      DateTime dateTimeA = dateFormat.parse('${a.date} ${a.from}');
      DateTime dateTimeB = dateFormat.parse('${b.date} ${b.from}');

      return dateTimeA.compareTo(dateTimeB);
    } catch (e) {
      print('Error parsing task dates: $e');
      return 0;
    }
  });
  return tasks;
}

/// Filter tasks based on a search query
List<TimeEntry> filterTasksByQuery(List<TimeEntry> tasks, String query) {
  if (query.isEmpty) return tasks;
  return tasks.where((task) {
    return task.task.toLowerCase().contains(query.toLowerCase()) ||
        task.date.contains(query) ||
        task.tag.toLowerCase().contains(query);
  }).toList();
}

/// Calculate total time spent per tag
Map<String, Duration> calculateTimeByTag(List<TimeEntry> tasks) {
  final Map<String, Duration> timeByTag = {};
  final dateFormat = DateFormat('yyyy/MM/dd h:mm a');

  for (var task in tasks) {
    try {
      final startTime = dateFormat.parse('${task.date} ${task.from}');
      final endTime = dateFormat.parse('${task.date} ${task.to}');
      final duration = endTime.difference(startTime);

      final tag = task.tag.toLowerCase();
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
