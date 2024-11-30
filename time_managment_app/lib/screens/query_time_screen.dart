import 'package:flutter/material.dart';
import '../models/time_entry.dart';
import '../services/firebase_services.dart'

class QueryTimeScreen extends StatelessWidget {
  final _queryController = TextEditingController();
  final _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query Time')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _queryController, decoration: InputDecoration(labelText: 'Enter query (e.g., Tag, Date, Task)')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final results = await _firebaseService.queryTimeEntries('tag', _queryController.text); // Example: Query by tag
                // Display results (not implemented yet)
              },
              child: Text('Search'),
            ),
          ],
        ),
      ),
    );
  }
}
