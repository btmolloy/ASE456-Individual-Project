import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/time_entry.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<void> addTimeEntry(TimeEntry entry) async {
    await _db.collection('time_entries').doc(entry.id).set(entry.toMap());
  }

  Future<List<TimeEntry>> queryTimeEntries(String field, String value) async {
    final snapshot = await _db.collection('time_entries').where(field, isEqualTo: value).get();
    return snapshot.docs.map((doc) => TimeEntry.fromMap(doc.data())).toList();
  }

  Future<List<TimeEntry>> queryTimeEntriesByDateRange(String startDate, String endDate) async {
    final snapshot = await _db.collection('time_entries')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get();
    return snapshot.docs.map((doc) => TimeEntry.fromMap(doc.data())).toList();
  }
}
