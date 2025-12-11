class Months {
  
  final int? id;
  final DateTime date;
  final double monthlyBudget;
  final String? notes;

  Months({
    this.id,
    required this.date,
    required this.monthlyBudget,
    this.notes,
  });

  // Von Map (statt JSON)
  factory Months.fromMap(Map<String, dynamic> map) {
    return Months(
      id: map['id'] as int?,
      date: DateTime.parse(map['date'] as String),
      monthlyBudget: (map['monthlyBudget']) is int
          ? (map['monthlyBudget'] as int).toDouble()
          : map['monthlyBudget'] as double,
      notes: map['notes'] as String?,
    );
  }

  // Für Insert (ohne ID und Timestamps)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'monthlyBudget': monthlyBudget,
      'notes': notes,
    };
  }
}