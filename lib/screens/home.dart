import 'package:easyfinances/components/transaction_form.dart';
import 'package:easyfinances/components/transaction_item.dart';
import 'package:easyfinances/external/sqflite_database.dart';
import 'package:easyfinances/models/transaction.dart';
import 'package:easyfinances/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Transaction> transactions = [];
  double balance = 0.0;

  final hideButtonController = ScrollController();
  bool isVisible = true;

  Future<dynamic> handleOpenTransactionForm(
    BuildContext context, [
    Transaction? transaction,
  ]) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return TransactionForm(
          callback: _handleGetTransactions,
          data: transaction,
        );
      },
    );
  }

  void _handleGetTransactions() async {
    final data = await SqfliteDatabase.getAll("transactions");
    if (data.isNotEmpty) {
      final convertedTransactions = data.map((transaction) {
        return Transaction(
            description: transaction['description'] as String,
            type: TransactionType.values
                .firstWhere((e) => e.toString() == transaction['type']),
            value: transaction['value'] as double,
            date: DateTime.tryParse(transaction['date'] as String) as DateTime,
            id: transaction['id'] as int);
      }).toList();

      _updateBalance(convertedTransactions);

      setState(() {
        transactions = convertedTransactions;
      });
    } else {
      _updateBalance([]);
      setState(() {
        transactions = [];
      });
    }
  }

  Future<void> _handleDeleteTransaction(int id) async {
    await SqfliteDatabase.delete(id, "transactions");
  }

  void _updateBalance(List<Transaction> transactions) async {
    if (transactions.isNotEmpty) {
      final transactionsValue = transactions.map((transaction) {
        if (transaction.type == TransactionType.expense) {
          return transaction.value * -1;
        } else {
          return transaction.value;
        }
      }).toList();
      final totalBalance = transactionsValue.reduce(
        (currentBalance, transactionValue) => currentBalance + transactionValue,
      );

      setState(() {
        balance = totalBalance;
      });
    } else {
      setState(() {
        balance = 0;
      });
    }
  }

  void _addScrollListener() {
    hideButtonController.addListener(() {
      if (hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (isVisible) {
          setState(() {
            isVisible = false;
          });
        }
      } else {
        if (hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (!isVisible) {
            setState(() {
              isVisible = true;
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _handleGetTransactions();
    _addScrollListener();
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
        actions: [
          Visibility(
            visible: !isVisible,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: Colors.amber[900],
                ),
                color: Colors.white,
                onPressed: () => handleOpenTransactionForm(context),
                icon: const Icon(Icons.add),
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Saldo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  CurrencyFormatter.addFormatting(balance.toString()),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: balance.isNegative ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              controller: hideButtonController,
              itemBuilder: (BuildContext context, int index) {
                return TransactionItem(
                  transactions[index],
                  _handleGetTransactions,
                  handleOpenTransactionForm,
                  _handleDeleteTransaction,
                );
              },
              itemCount: transactions.length,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton(
          onPressed: () => handleOpenTransactionForm(context),
          backgroundColor: Colors.amber[900],
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
