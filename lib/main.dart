import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'helpers/db_helper.dart';
import 'helpers/newton_solver.dart';
import 'models/solution.dart';
import 'models/iteration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newton Solver',
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
  List<Solution> _solutions = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DBHelper();
    _loadSolutions();
  }

  void _loadSolutions() async {
    List<Solution> solutions = await _dbHelper.getSolutions();
    setState(() {
      _solutions = solutions;
    });
  }

  void _solveEquation() {
    if (_formKey.currentState!.validate()) {
      String equation = _equationController.text;
      double x0 = double.parse(_x0Controller.text);
      double error = double.parse(_errorController.text);

      NewtonSolver solver =
          NewtonSolver(equation: equation, x0: x0, error: error);
      List<Iteration> iterations = solver.solve();
      double result = iterations.last.x;

      setState(() {
        _iterations = iterations;
        _result = result;
      });

      _saveSolution(equation, x0, error, result);
    }
  }

  void _saveSolution(
      String equation, double x0, double error, double result) async {
    Solution solution = Solution(
      equation: equation,
      x0: x0,
      error: error,
      result: result,
    );
    await _dbHelper.insertSolution(solution);
    _loadSolutions();
  }

  void _deleteSolution(int id) async {
    await _dbHelper.deleteSolution(id);
    _loadSolutions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newton Solver'),
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai x0';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _errorController,
                decoration: InputDecoration(labelText: 'Nilai Error'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*\.?[0-9]*'))
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nilai error';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _solveEquation,
                child: Text('Solve'),
              ),
              SizedBox(height: 20),
              if (_result != null)
                Column(
                  children: [
                    Text('Hasil: $_result', style: TextStyle(fontSize: 20)),
                    SizedBox(height: 20),
                    Text('Iterasi:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: _iterations.length,
                        itemBuilder: (context, index) {
                          final iteration = _iterations[index];
                          return ListTile(
                            title: Text('Langkah: ${iteration.step}'),
                            subtitle:
                                Text('x: ${iteration.x}, h: ${iteration.h}'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _solutions.length,
                  itemBuilder: (context, index) {
                    final solution = _solutions[index];
                    return Card(
                      child: ListTile(
                        title: Text('Persamaan: ${solution.equation}'),
                        subtitle: Text(
                            'x0: ${solution.x0}, Error: ${solution.error}, Hasil: ${solution.result}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteSolution(solution.id!);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
