import 'package:easyfinances/components/transaction_form.dart';
import 'package:easyfinances/components/transaction_item.dart';
import 'package:easyfinances/models/transaction.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Transaction> transactions = [];

  Future<dynamic> handleAddNewTransaction(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const TransactionForm();
      },
    );
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => handleAddNewTransaction(context),
        backgroundColor: Colors.amber[900],
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
