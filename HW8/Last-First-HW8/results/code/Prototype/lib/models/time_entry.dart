class TimeEntry {
  final String id;
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

  factory TimeEntry.fromMap(Map<String, dynamic> data, String id) {
    return TimeEntry(
      id: id,
      date: data['date'] as String,
      from: data['from'] as String,
      to: data['to'] as String,
      task: data['task'] as String,
      tag: data['tag'] as String,
    );
  }

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
