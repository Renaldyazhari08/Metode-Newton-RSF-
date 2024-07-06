import 'package:math_expressions/math_expressions.dart';
import '../models/iteration.dart';

class NewtonSolver {
  final String equation;
  final double x0;
  final double error;

  NewtonSolver({required this.equation, required this.x0, required this.error});

  List<Iteration> solve() {
    Parser p = Parser();
    Expression exp = p.parse(equation);
    Expression derivative = exp.derive('x');
    ContextModel cm = ContextModel();

    List<Iteration> iterations = [];
    double x = x0;
    double h = exp.evaluate(
            EvaluationType.REAL, cm..bindVariableName('x', Number(x))) /
        derivative.evaluate(
            EvaluationType.REAL, cm..bindVariableName('x', Number(x)));
    int step = 1;

    while (h.abs() >= error) {
      iterations.add(Iteration(step: step, x: x, h: h));
      h = exp.evaluate(
              EvaluationType.REAL, cm..bindVariableName('x', Number(x))) /
          derivative.evaluate(
              EvaluationType.REAL, cm..bindVariableName('x', Number(x)));
      x = x - h;
      step++;
    }
    iterations.add(Iteration(step: step, x: x, h: h));
    return iterations;
  }
}
