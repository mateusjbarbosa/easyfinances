import 'package:easyfinances/models/transaction.dart';
import 'package:easyfinances/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function onRefresh;
  final Function onEdit;
  final Function onDelete;

  const TransactionItem(
    this.transaction,
    this.onRefresh,
    this.onEdit,
    this.onDelete, {
    super.key,
  });

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
          "- ${CurrencyFormatter.addFormatting(transaction.value.toString())}",
          style: const TextStyle(
            fontSize: 16,
            color: Colors.red,
          ),
        );
      case TransactionType.income:
        return Text(
          CurrencyFormatter.addFormatting(transaction.value.toString()),
          style: const TextStyle(
            fontSize: 16,
            color: Colors.green,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.id.toString()),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        // esquerda para direita
        if (direction == DismissDirection.startToEnd) {
          onEdit(context, transaction);
          onRefresh();
        } else {
          onDelete(transaction.id);
          onRefresh();
        }
        return null;
      },
      background: Container(
        color: Colors.amber[900],
        padding: const EdgeInsets.only(left: 18),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.edit, color: Colors.white),
          ],
        ),
      ),
      secondaryBackground: Container(
        color: Colors.red,
        padding: const EdgeInsets.only(right: 18),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      child: ListTile(
        leading: getIcon(),
        title: Text(
          transaction.description,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(getTransactionDate()),
        trailing: getValueText(),
      ),
    );
  }
}
