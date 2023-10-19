import 'package:easyfinances/components/transaction_form.dart';
import 'package:easyfinances/components/transaction_item.dart';
import 'package:easyfinances/external/sqflite_database.dart';
import 'package:easyfinances/models/transaction.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> transactions = [];

  Future<dynamic> handleAddNewTransaction(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TransactionForm(
          callback: _handleGetTransactions
        );
      },  
    );
  }

  void _handleGetTransactions() async {
    final data = await SqfliteDatabase.getAll("transactions");
    final convertedTransactions = data.map((transaction) {
      return Transaction(
          description: transaction['description'] as String,
          type: TransactionType.values
              .firstWhere((e) => e.toString() == transaction['type']),
          value: transaction['value'] as double,
          date: DateTime.tryParse(transaction['date'] as String) as DateTime,
          id: transaction['id'] as int);
    }).toList();

    setState(() {
      transactions = convertedTransactions;
    });
  }

  @override
  void initState() {
    _handleGetTransactions();
    super.initState();
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
