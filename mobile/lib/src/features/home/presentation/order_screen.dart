import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/src/routing/app_router.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hello World Flutter',
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                if (context.mounted) {
                  context.goNamed(AppRoute.home.name);
                }
              },
              icon: const Icon(Icons.arrow_back)),
          title: const Text('Hello World Flutter'),
        ),
        body: const Center(
          child: Text(
            'Hello, World!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
