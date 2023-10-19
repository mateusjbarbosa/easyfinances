import 'package:easyfinances/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem(this.transaction, {super.key});

  Widget getIcon() {
    switch (transaction.type) {
      case TransactionType.expense:
        return const Icon(
          Icons.arrow_downward,
          color: Colors.red,
        );
      case TransactionType.income:
        return const Icon(
          Icons.arrow_upward,
          color: Colors.green,
        );
    }
  }

  String getTransactionDate() {
    return DateFormat('dd/MM/yyyy').format(transaction.date);
  }

  Widget getValueText() {
    switch (transaction.type) {
      case TransactionType.expense:
        return Text(
          "R\$ -${transaction.value.toString()}",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        );
      case TransactionType.income:
        return Text(
          "R\$ ${transaction.value.toString()}",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.green,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: getIcon(),
      title: Text(
        transaction.description,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(getTransactionDate()),
      trailing: getValueText(),
    );
  }
}
