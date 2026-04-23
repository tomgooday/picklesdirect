import 'package:flutter/material.dart';

class PhotoCapturePage extends StatelessWidget {
  const PhotoCapturePage({required this.draftId, super.key});
  final String draftId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo Capture')),
      body: const Center(child: Text('PhotoCapturePage — coming soon')),
    );
  }
}
