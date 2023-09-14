import 'package:flutter/material.dart';

class Transaction {
  final String id;
  final String title;
  final String type;
  final double value;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.type,
    required this.value,
    required this.date,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      Transaction(
        id: "1",
        title: "Conta de luz",
        type: "expense",
        value: 100,
        date: DateTime.now(),
      ),
      Transaction(
        id: "2",
        title: "Conta de luz",
        type: "expense",
        value: 100,
        date: DateTime.now(),
      ),
      Transaction(
        id: "3",
        title: "Conta de luz",
        type: "expense",
        value: 100,
        date: DateTime.now(),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyFinances"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text('item $index'),
            );
          },
          separatorBuilder: (ctx, index) => const Divider(),
          itemCount: transactions.length,
        ),
      ),
    );
  }
}
