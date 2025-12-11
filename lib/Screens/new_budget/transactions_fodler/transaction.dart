class Transaction {
  final int? id;
  final int monthId;
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
      id: map['id'] as int?,
      monthId: map['monthId'] as int,
      amount: (map['amount']) is int
          ? (map['amount'] as int).toDouble()
          : (map['amount'] as num).toDouble(),
      type: (map['type'] as String?) ?? '',
      category: (map['category'] as String?) ?? '',
      description: map['description'] as String?,
    );
  }

  // Für Insert (ohne ID und Timestamps)
  Map<String, dynamic> toMap() {
    return {
      
      'monthId': monthId, 
      'amount': amount,
      'type': type,
      'category': category,
      'description': description,
    };
  }
}