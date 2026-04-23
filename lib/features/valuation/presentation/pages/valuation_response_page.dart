import 'package:flutter/material.dart';

class ValuationResponsePage extends StatelessWidget {
  const ValuationResponsePage({required this.submissionId, super.key});
  final String submissionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Valuation Response')),
      body: const Center(child: Text('ValuationResponsePage — coming soon')),
    );
  }
}
