import 'package:easyfinances/models/transaction.dart';

class TransactionsRepositoryInMemory {
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

  void add(Transaction transaction) {
    transactions.add(transaction);
  }
}
