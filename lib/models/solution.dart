class Solution {
  int? id;
  String equation;
  double x0;
  double error;
  double result;

  Solution(
      {this.id,
      required this.equation,
      required this.x0,
      required this.error,
      required this.result});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'equation': equation,
      'x0': x0,
      'error': error,
      'result': result,
    };
  }
}
