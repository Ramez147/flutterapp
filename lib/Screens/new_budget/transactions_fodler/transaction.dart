class Transaction {
  final String? id;
  final String monthId;
  final double amount;
  final String type;
  final String category;
  final String? description;

  Transaction({
    this.id,
    required this.monthId,
    required this.amount,
    required this.type,
    required this.category,
    this.description,
  });

  // Von Map (statt JSON)
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String?,
      monthId: map['monthId'] as String,
      amount: (map['amount']) is int
          ? (map['amount'] as int).toDouble()
          : map['amount'] as double,
      type: map['type'] as String,
      category: map['category'] as String,
      description: map['description'] as String?,
    );
  }

  // Für Insert (ohne ID und Timestamps)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'monthId': monthId, // Konsistent mit fromMap
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
    };
  }
}