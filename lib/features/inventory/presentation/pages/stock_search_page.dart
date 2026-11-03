import 'package:flutter/material.dart';

class StockSearchPage extends StatelessWidget {
  const StockSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Search'),
      ),
      body: const Center(
        child: Text('Stock Search Page'),
      ),
    );
  }
}
