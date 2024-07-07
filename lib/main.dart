import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helpers/db_helper.dart';
import 'helpers/newton_solver.dart';
import 'models/solution.dart';
import 'models/iteration.dart';
import 'screens/load_solutions_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metode Newton',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _equationController = TextEditingController();
  final _x0Controller = TextEditingController();
  final _errorController = TextEditingController();

  double? _result;
  List<Iteration> _iterations = [];
  late DBHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DBHelper();
  }

  void _solveEquation() {
    if (_formKey.currentState!.validate()) {
      String equation = _equationController.text;
      double x0 = double.parse(_x0Controller.text);
      double error = double.parse(_errorController.text);

      try {
        NewtonSolver solver =
            NewtonSolver(equation: equation, x0: x0, error: error);
        List<Iteration> iterations = solver.solve();
        double result = iterations.last.x;

        setState(() {
          _iterations = iterations;
          _result = result;
        });
      } catch (e) {
        setState(() {
          _iterations = [];
          _result = double.nan;
        });
        print('Error: $e');
      }
    }
  }

  void _saveSolution() async {
    if (_result != null && !_result!.isNaN) {
      Solution solution = Solution(
        equation: _equationController.text,
        x0: double.parse(_x0Controller.text),
        error: double.parse(_errorController.text),
        result: _result!,
      );
      await _dbHelper.insertSolution(solution);
    }
  }

  Future<void> _loadSolution() async {
    final Solution? solution = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadSolutionsScreen()),
    );

    if (solution != null) {
      setState(() {
        _equationController.text = solution.equation;
        _x0Controller.text = solution.x0.toString();
        _errorController.text = solution.error.toString();
        _result = solution.result;
        // Optionally, load the iterations if you save them in the DB
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newton Solver'),
        actions: [
          IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: _loadSolution,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _equationController,
                decoration: InputDecoration(labelText: 'Persamaan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan persamaan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _x0Controller,
                decoration: InputDecoration(labelText: 'Nilai x0'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai x0';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _errorController,
                decoration: InputDecoration(labelText: 'Nilai Error'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai error';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _solveEquation,
                    child: Text('Solve'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _saveSolution,
                    child: Text('Save'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (_result != null)
                Text(
                    'Hasil: ${_result!.isNaN ? 'Tidak valid (NaN)' : _result}'),
              if (_iterations.isNotEmpty) ...[
                Text('Iterasi:'),
                ..._iterations.map((iteration) {
                  return Text(
                      'Langkah: ${iteration.step}, x: ${iteration.x}, h: ${iteration.h}');
                }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
