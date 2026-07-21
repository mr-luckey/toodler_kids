import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParentGatePage extends StatefulWidget {
  const ParentGatePage({super.key});

  @override
  State<ParentGatePage> createState() => _ParentGatePageState();
}

class _ParentGatePageState extends State<ParentGatePage> {
  late int _a;
  late int _b;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateQuestion();
  }

  void _generateQuestion() {
    final random = Random();
    _a = random.nextInt(9) + 1;
    _b = random.nextInt(9) + 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Gate')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Parents only! Solve this:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            Text(
              'What is $_a + $_b?',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Answer',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (int.tryParse(_controller.text) == _a + _b) {
                  context.go('/parent-dashboard');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Try again!')),
                  );
                  _generateQuestion();
                  _controller.clear();
                  setState(() {});
                }
              },
              child: const Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}
