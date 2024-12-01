import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/time_entry.dart';
import '../services/firebase_service.dart';
import '../utils/task_utils.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final _firebaseService = FirebaseService();
  Map<String, Duration> _tagDurations = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    setState(() => _isLoading = true);

    try {
      List<TimeEntry> tasks = await _firebaseService.getAllTasks();
      Map<String, Duration> tagDurations = calculateTimeByTag(tasks);

      setState(() {
        _tagDurations = tagDurations;
      });
    } catch (e) {
      print('Error loading analytics: $e');
    } finally {
      setState(() => _isLoading = false);
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
        automaticallyImplyLeading: false, // Removes default back arrow
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Back Arrow and Subtitle
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
                  'Time Usage Analytics',
                  style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Page Title
            Text(
              'Time Allocation by Tag',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),

            // Content Area
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _tagDurations.isEmpty
                  ? Center(
                child: Text(
                  'No data available.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : _buildChartBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBox() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width * 0.8, // Reduced width
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: _buildBarChart(),
      ),
    );
  }

  Widget _buildBarChart() {
    final chartData = _tagDurations.entries.map((entry) {
      return _ChartData(entry.key, entry.value.inMinutes.toDouble());
    }).toList();

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        labelStyle: TextStyle(color: Colors.blue),
        majorGridLines: MajorGridLines(width: 0), // Removes grid lines
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
        labelStyle: TextStyle(color: Colors.blue),
        majorGridLines: MajorGridLines(width: 1),
      ),
      tooltipBehavior: TooltipBehavior(enable: true, header: '', format: 'point.x: point.y minutes'),
      series: <ChartSeries<_ChartData, String>>[
        ColumnSeries<_ChartData, String>(
          dataSource: chartData,
          xValueMapper: (data, _) => data.tag,
          yValueMapper: (data, _) => data.duration,
          pointColorMapper: (data, index) => _getBarColor(index), // Assign different colors
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  /// Generate different colors for the bars
  Color _getBarColor(int? index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.cyan,
      Colors.amber,
    ];
    return colors[index! % colors.length];
  }
}

class _ChartData {
  final String tag;
  final double duration;

  _ChartData(this.tag, this.duration);
}
