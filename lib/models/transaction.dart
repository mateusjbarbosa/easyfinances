enum TransactionType { expense, income }

class Transaction {
  final String? id;
  final String title;
  final TransactionType type;
  final double value;
  final DateTime date;

  Transaction({
    required this.title,
    required this.type,
    required this.value,
    required this.date,
    this.id,
  });
}
