import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final List<Map<String, dynamic>> _tasks = List.generate(
    0,
    (index) => {'title': 'Task ${index + 1}', 'completed': false},
  );

  void _addTask() {
    setState(() {
      _tasks.add({'title': 'Task ${_tasks.length + 1}', 'completed': false});
    });
  }

  void _editTask(int index) {
    TextEditingController controller =
        TextEditingController(text: _tasks[index]['title']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Task'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'Task Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _tasks[index]['title'] = controller.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
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
            key: ValueKey(_tasks[index]['title']),
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
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
