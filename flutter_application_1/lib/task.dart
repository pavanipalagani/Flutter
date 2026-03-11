import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/* -------------------- TASK MODEL -------------------- */

class Task {
  String id;
  String title;
  String description;
  String priority;
  String label;
  bool isCompleted;
  DateTime createdAt;
  DateTime? deadline;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    this.description = '',
    this.priority = 'Low',
    this.label = 'Personal',
    this.isCompleted = false,
    this.deadline,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      priority: json['priority'] ?? 'Low',
      label: json['label'] ?? 'Personal',
      isCompleted: json['isCompleted'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'label': label,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
    };
  }
}

/* -------------------- APP UI -------------------- */

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Dart App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isChecked = false;
  String entryTime = "";
  String delayTime = "";

  TextEditingController entryController = TextEditingController();
  TextEditingController delayController = TextEditingController();

  int currentIndex = 0;

  Task? currentTask;

  void submitData() {

    // Create a Task object using entered values
    Task task = Task(
      id: "1",
      title: "User Entry",
      createdAt: DateTime.now(),
      description: "Entry: ${entryController.text}, Delay: ${delayController.text}",
      priority: "Medium",
      isCompleted: isChecked,
    );

    setState(() {
      entryTime = entryController.text;
      delayTime = delayController.text;
      currentTask = task;
    });

    print("Task JSON Data: ${task.toJson()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dart App Example"),
      ),

      /* ---------- NAVIGATION BAR ---------- */

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),

      /* ---------- BODY ---------- */

      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [

            // Checkbox
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
                Text("Accept Terms")
              ],
            ),

            SizedBox(height: 20),

            // Entry Time
            TextField(
              controller: entryController,
              decoration: InputDecoration(
                labelText: "Entry Time",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Delay Time
            TextField(
              controller: delayController,
              decoration: InputDecoration(
                labelText: "Delay Time",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // Button
            ElevatedButton(
              onPressed: submitData,
              child: Text("Submit"),
            ),

            SizedBox(height: 20),

            Text("Entry Time: $entryTime"),
            Text("Delay Time: $delayTime"),

            SizedBox(height: 20),

            if (currentTask != null)
              Text("Task JSON: ${currentTask!.toJson()}"),
          ],
        ),
      ),
    );
  }
}