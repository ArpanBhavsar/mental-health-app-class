// Suggested code may be subject to a license. Learn more: ~LicenseLog:561218062.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2083398100.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:4078478684.
import 'package:flutter/material.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {
  final TextEditingController _bodyTextEditingController = TextEditingController();
  final TextEditingController _titleTextEditingController = TextEditingController();

  @override
  void dispose() {
    _bodyTextEditingController.dispose();
    _titleTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // TODO: Implement save functionality
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleTextEditingController,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            Expanded(
        child: TextField(
                controller: _bodyTextEditingController,
          maxLines: null,
          expands: true,
          decoration: const InputDecoration(
            hintText: 'Start writing your journal entry...',
            border: InputBorder.none,
                ),
              ),
            ),
          ]
          ),
        ),
      );
  }
}
