import 'package:flutter/material.dart';

class PurchaseEntryPage extends StatelessWidget {
  const PurchaseEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Entry'),
      ),
      body: const Center(
        child: Text('Purchase Entry Page'),
      ),
    );
  }
}
