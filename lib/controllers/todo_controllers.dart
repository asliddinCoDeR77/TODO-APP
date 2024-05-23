// import 'package:flutter/material.dart';

// class TaskManager {
//   final List<Map<String, dynamic>> tasks;

//   TaskManager(this.tasks);

//   void addTask(VoidCallback setStateCallback) {
//     setStateCallback(() {
//       tasks.add({'title': 'Task ${tasks.length + 1}', 'completed': false});
//     });
//   }

//   void editTask(
//       BuildContext context, int index, VoidCallback setStateCallback) {
//     TextEditingController controller =
//         TextEditingController(text: tasks[index]['title']);
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Edit Task'),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(labelText: 'Task Name'),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 setStateCallback(() {
//                   tasks[index]['title'] = controller.text;
//                 });
//                 Navigator.of(context).pop();
//               },
//               child: Text('Save'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void deleteTask(int index, VoidCallback setStateCallback) {
//     setStateCallback(() {
//       tasks.removeAt(index);
//     });
//   }
// }
