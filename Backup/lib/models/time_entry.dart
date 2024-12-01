class TimeEntry {
  final String id; // Firestore document ID
  final String date;
  final String from;
  final String to;
  final String task;
  final String tag;

  TimeEntry({
    required this.id,
    required this.date,
    required this.from,
    required this.to,
    required this.task,
    required this.tag,
  });

  // Factory method to create a TimeEntry from Firestore data
  factory TimeEntry.fromMap(Map<String, dynamic> data, String id) {
    return TimeEntry(
      id: id, // Pass Firestore document ID here
      date: data['date'] as String,
      from: data['from'] as String,
      to: data['to'] as String,
      task: data['task'] as String,
      tag: data['tag'] as String,
    );
  }

  // Convert a TimeEntry to a Firestore document
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'from': from,
      'to': to,
      'task': task,
      'tag': tag,
    };
  }
}
