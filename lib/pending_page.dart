import 'package:flutter/material.dart';

class PendingPage extends StatelessWidget {
  const PendingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Requests'),
        backgroundColor: const Color(0xFF003366),
      ),
      body: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text('Room Request #${index + 1}'),
              subtitle: const Text('Status: Pending'),
              trailing: const Icon(Icons.hourglass_empty, color: Colors.orange),
            ),
          );
        },
      ),
    );
  }
}
