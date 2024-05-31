import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl =
    'https://dars3ux-default-rtdb.firebaseio.com/products.json';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Map<String, dynamic>> _tasks = [];

  Future<void> _fetchTasks() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _tasks.clear();
          for (var item in data) {
            _tasks.add({
              'id': item['id'],
              'title': item['title'],
              'completed': item['completed'],
            });
          }
        });
      }
    } catch (error) {}
  }

  Future<void> _addTask() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json
            .encode({'title': 'Task ${_tasks.length + 1}', 'completed': false}),
      );
      if (response.statusCode == 201) {
        final Map<String, dynamic> newTask = json.decode(response.body);
        setState(() {
          _tasks.add({
            'id': newTask['id'],
            'title': newTask['title'],
            'completed': newTask['completed'],
          });
        });
      }
    } catch (error) {
      return null;
    }
  }

  Future<void> _editTask(int index) async {
    TextEditingController controller =
        TextEditingController(text: _tasks[index]['title']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Task Name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final response = await http.patch(
                    Uri.parse('$apiUrl/${_tasks[index]['id']}'),
                    headers: {'Content-Type': 'application/json'},
                    body: json.encode({'title': controller.text}),
                  );
                  if (response.statusCode == 200) {
                    setState(() {
                      _tasks[index]['title'] = controller.text;
                    });
                  }
                } catch (error) {
                  return null;
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(int index) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/${_tasks[index]['id']}'),
      );
      if (response.statusCode == 200) {
        setState(() {
          _tasks.removeAt(index);
        });
      }
    } catch (error) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: const Text(
          'TODO APP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.account_circle))
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return Slidable(
            key: ValueKey(_tasks[index]['id']),
            startActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _editTask(index),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.edit,
                  label: 'Edit',
                ),
              ],
            ),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) => _deleteTask(index),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: CupertinoIcons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: CheckboxListTile(
              selectedTileColor: Colors.green,
              title: Text(_tasks[index]['title']),
              value: _tasks[index]['completed'],
              onChanged: (value) {
                setState(() {
                  _tasks[index]['completed'] = value!;
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: _addTask,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
