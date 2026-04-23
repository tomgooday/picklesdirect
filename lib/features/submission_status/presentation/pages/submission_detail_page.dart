import 'package:flutter/material.dart';

class SubmissionDetailPage extends StatelessWidget {
  const SubmissionDetailPage({required this.submissionId, super.key});
  final String submissionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Submission Detail')),
      body: const Center(child: Text('SubmissionDetailPage — coming soon')),
    );
  }
}
