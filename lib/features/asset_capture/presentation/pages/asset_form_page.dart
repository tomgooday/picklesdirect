import 'package:flutter/material.dart';

class AssetFormPage extends StatelessWidget {
  const AssetFormPage({
    required this.categoryKey,
    super.key,
    this.draftId,
  });

  final String categoryKey;
  final String? draftId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Asset Form — $categoryKey')),
      body: const Center(child: Text('AssetFormPage — coming soon')),
    );
  }
}
