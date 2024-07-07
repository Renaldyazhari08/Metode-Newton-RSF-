import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/solution.dart';

class LoadSolutionsScreen extends StatelessWidget {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Solution>> _loadSolutions() async {
    return await _dbHelper.getSolutions();
  }

  void _deleteSolution(int id) async {
    await _dbHelper.deleteSolution(id);
    // Perbarui layar setelah solusi dihapus
    (await _loadSolutions()).clear(); // Membersihkan list sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Load Solutions'),
      ),
      body: FutureBuilder<List<Solution>>(
        future: _loadSolutions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No saved solutions found'));
          } else {
            final solutions = snapshot.data!;
            return ListView.builder(
              itemCount: solutions.length,
              itemBuilder: (context, index) {
                final solution = solutions[index];
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
                    onTap: () {
                      Navigator.pop(context, solution);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
