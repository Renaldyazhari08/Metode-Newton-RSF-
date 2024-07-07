class Solution {
  final int? id;
  final String equation;
  final double x0;
  final double error;
  final double result;

  Solution({
    this.id,
    required this.equation,
    required this.x0,
    required this.error,
    required this.result,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equation': equation,
      'x0': x0,
      'error': error,
      'result': result,
    };
  }

  factory Solution.fromMap(Map<String, dynamic> map) {
    return Solution(
      id: map['id'],
      equation: map['equation'],
      x0: map['x0'],
      error: map['error'],
      result: map['result'],
    );
  }
}
