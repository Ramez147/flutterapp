class Months {
  
  final String? monthId;
  final DateTime date;
  final double monthlyBudget;
  final String? notes;

  Months({
    this.monthId,
    required this.date,
    required this.monthlyBudget,
    this.notes,
  });

  // Von Map (statt JSON)
  factory Months.fromMap(Map<String, dynamic> map) {
    return Months(
      monthId: map['monthId'] as String?,
      date: DateTime.parse(map['date'] as String),
      monthlyBudget: (map['monthly_budget']) is int
          ? (map['monthly_budget'] as int).toDouble()
          : map['monthly_budget'] as double,
      notes: map['notes'] as String?,
    );
  }

  // Für Insert (ohne ID und Timestamps)
  Map<String, dynamic> toMap() {
    return {
      'monthId': monthId,
      'date': date.toIso8601String(),
      'monthly_budget': monthlyBudget,
      'notes': notes,
    };
  }
}