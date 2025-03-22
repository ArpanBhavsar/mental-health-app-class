import 'package:flutter/material.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  State<JournalListScreen> createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entries'),
      ),
      body: ListView.builder(
        itemCount: 0, // Replace with actual data length later
        itemBuilder: (context, index) {
          // Replace with actual list tile for each entry
          return ListTile(
            title: Text('Entry Title $index'),
            subtitle: Text('Date/Time'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Handle edit action
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
