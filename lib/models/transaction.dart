enum TransactionType { expense, income }

class Transaction {
  final int? id;
  final String description;
  final TransactionType type;
  final double value;
  final DateTime date;

  Transaction({
    required this.description,
    required this.type,
    required this.value,
    required this.date,
    this.id,
  });

  Map<String, Object> toMap() {
    Map<String, Object> obj = {
      'description': description,
      'type': type.toString(),
      'value': value,
      'date': date.toIso8601String(),
    };

    if (id != null) {
      obj['id'] = id as int;
    }

    return obj;
  }
}
