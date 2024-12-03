import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/time_entry.dart';
import '../services/firebase_service.dart';
import '../utils/task_utils.dart';

class QueryReportScreen extends StatefulWidget {
  @override
  _QueryReportScreenState createState() => _QueryReportScreenState();
}

class _QueryReportScreenState extends State<QueryReportScreen> {
  final _searchController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _firebaseService = FirebaseService();
  List<TimeEntry> _searchResults = [];
  Map<String, Duration> _tagReport = {};
  bool _isLoading = false;

  /// Search for tasks by query (supports tag, date, and task name)
  void _searchTasks(String query) async {
    setState(() => _isLoading = true);

    try {
      List<TimeEntry> allTasks = await _firebaseService.getAllTasks();

      // Filter tasks by query (tag, date, or task name)
      List<TimeEntry> results = allTasks.where((task) {
        final lowerQuery = query.toLowerCase();
        return task.task.toLowerCase().contains(lowerQuery) ||
            task.tag.toLowerCase().contains(lowerQuery) ||
            task.date.contains(query);
      }).toList();

      results = sortTasksByDateTime(results);

      setState(() {
        _searchResults = results;
        _tagReport = {};
      });
    } catch (e) {
      print('Error searching tasks: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Filter tasks by date range
  void _searchByDateRange() async {
    setState(() => _isLoading = true);

    try {
      List<TimeEntry> allTasks = await _firebaseService.getAllTasks();
      final DateFormat dateFormat = DateFormat('yyyy/MM/dd');
      final DateTime? startDate = _startDateController.text.isNotEmpty
          ? dateFormat.parse(_startDateController.text)
          : null;
      final DateTime? endDate = _endDateController.text.isNotEmpty
          ? dateFormat.parse(_endDateController.text)
          : null;

      List<TimeEntry> results = allTasks.where((task) {
        try {
          DateTime taskDate = dateFormat.parse(task.date);
          return (startDate == null || taskDate.isAfter(startDate) || taskDate.isAtSameMomentAs(startDate)) &&
              (endDate == null || taskDate.isBefore(endDate) || taskDate.isAtSameMomentAs(endDate));
        } catch (e) {
          print('Error parsing task date: $e');
          return false;
        }
      }).toList();

      results = sortTasksByDateTime(results);

      setState(() {
        _searchResults = results;
        _tagReport = {};
      });
    } catch (e) {
      print('Error querying by date range: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Generate report for total time spent per tag
  void _generateReport() async {
    setState(() => _isLoading = true);

    try {
      List<TimeEntry> allTasks = await _firebaseService.getAllTasks();
      Map<String, Duration> report = calculateTimeByTag(allTasks);

      final sortedReport = Map.fromEntries(
        report.entries.toList()..sort((a, b) => b.value.compareTo(a.value)),
      );

      setState(() {
        _tagReport = sortedReport;
        _searchResults = [];
      });
    } catch (e) {
      print('Error generating report: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Delete a task
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
      _searchTasks(_searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Personal Time Manager',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Tooltip(
                  message: 'Back',
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Text(
                  'Search Tasks',
                  style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),

            Text(
              'Search & Filter Tasks',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Search Bar with Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search tasks by date, tag, or task name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _searchTasks(_searchController.text),
                  child: Text('Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Date Range Filter with Filter Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: TextField(
                    controller: _startDateController,
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      hintText: 'yyyy/MM/dd',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: TextField(
                    controller: _endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      hintText: 'yyyy/MM/dd',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _searchByDateRange,
                  child: Text('Filter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Generate Report Button
            ElevatedButton.icon(
              onPressed: _generateReport,
              icon: Icon(Icons.bar_chart),
              label: Text('Generate Report'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 20),

            // Results/Reports
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _searchResults.isNotEmpty
                  ? _buildSearchResults()
                  : _tagReport.isNotEmpty
                  ? _buildTagReport()
                  : Center(child: Text('Search for tasks or generate a report.')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView.builder(
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final task = _searchResults[index];
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
    );
  }

  Widget _buildTagReport() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView.builder(
        itemCount: _tagReport.keys.length,
        itemBuilder: (context, index) {
          final tag = _tagReport.keys.elementAt(index);
          final duration = _tagReport[tag]!;
          return Card(
            color: Colors.blue,
            child: ListTile(
              title: Text(
                tag,
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'Total Time: ${_formatDuration(duration)}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}
