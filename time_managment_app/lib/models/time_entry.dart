class TimeEntry {
  final String id;
  final String date; // Format: YYYY/MM/DD
  final String from; // Format: HH:MM AM/PM
  final String to; // Format: HH:MM AM/PM
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'from': from,
      'to': to,
      'task': task,
      'tag': tag,
    };
  }

  static TimeEntry fromMap(Map<String, dynamic> map) {
    return TimeEntry(
      id: map['id'],
      date: map['date'],
      from: map['from'],
      to: map['to'],
      task: map['task'],
      tag: map['tag'],
    );
  }
}
