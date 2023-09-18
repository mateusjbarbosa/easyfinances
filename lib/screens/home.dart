import 'package:easyfinances/components/transaction_item.dart';
import 'package:easyfinances/models/transaction.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Transaction> transactions = [
    Transaction(
      id: "1",
      title: "Conta de luz",
      type: TransactionType.expense,
      value: 100,
      date: DateTime.now(),
    ),
    Transaction(
      id: "2",
      title: "Salário",
      type: TransactionType.income,
      value: 1300,
      date: DateTime.now(),
    ),
    Transaction(
      id: "3",
      title: "Conta de água",
      type: TransactionType.expense,
      value: 100,
      date: DateTime.now(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "EasyFinances",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return TransactionItem(transactions[index]);
          },
          itemCount: transactions.length,
        ),
      ),
    );
  }
}
