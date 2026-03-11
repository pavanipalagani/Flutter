import 'package:flutter/material.dart';

void main() {
  runApp(TaskManagerApp());
}

List<Map<String, String>> users = [];

class TaskManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Task Manager",
      theme: ThemeData(
        primaryColor: Colors.purple.shade200,
        scaffoldBackgroundColor: Colors.grey.shade200,
      ),
      home: SplashScreen(),
    );
  }
}

/* ---------------- SPLASH SCREEN ---------------- */

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade200, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Text(
            "TASK MANAGER",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------- SIGN UP ---------------- */

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void signup(){

    users.add({
      "email":email.text,
      "password":password.text
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Account Created. Please Login"))
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Sign Up"),
        backgroundColor: Colors.purple.shade200,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: email,
              decoration: InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: password,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            SizedBox(height:20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),
              onPressed: signup,
              child: Text("Sign Up"),
            ),

            TextButton(
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
              child: Text("Already have account? Login"),
            )

          ],
        ),
      ),
    );
  }
}

/* ---------------- LOGIN ---------------- */

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void login(){

    bool found = false;

    for(var user in users){

      if(user["email"] == email.text){

        found = true;

        if(user["password"] == password.text){

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeScreen()),
          );

        }else{

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Incorrect Password"))
          );
        }
      }
    }

    if(!found){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User not found. Please Sign Up"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Login"),
        backgroundColor: const Color.fromARGB(255, 104, 58, 112),
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: email,
              decoration: InputDecoration(labelText: "Email"),
            ),

            TextField(
              controller: password,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),

            SizedBox(height:20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 11, 11, 11),
              ),
              onPressed: login,
              child: Text("Login"),
            ),

            TextButton(
              onPressed: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => SignUpScreen()),
                );
              },
              child: Text("Create new account"),
            )

          ],
        ),
      ),
    );
  }
}

/* ---------------- TASK MODEL ---------------- */

class Task {

  String title;
  String description;
  String priority;
  String purpose;
  DateTime deadline;
  bool completed;
  DateTime? completedTime;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.purpose,
    required this.deadline,
    this.completed=false,
    this.completedTime
  });
}

/* ---------------- HOME SCREEN ---------------- */

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<Task> tasks=[];

  Color priorityColor(String p){

    if(p=="High") return Colors.purple.shade100;
    if(p=="Medium") return Colors.grey.shade300;

    return Colors.grey.shade100;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: Colors.purple.shade200,

        actions: [

          IconButton(
            icon: Icon(Icons.logout),

            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen()),
              );
            },
          )

        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),

        onPressed: () async{

          final task = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );

          if(task!=null){

            setState(() {
              tasks.add(task);
            });

          }

        },
      ),

      body: ListView.builder(

        itemCount: tasks.length,

        itemBuilder: (_,index){

          final t = tasks[index];

          return AnimatedOpacity(

            duration: Duration(milliseconds: 500),
            opacity: t.completed ? 0.0 : 1.0,

            child: Card(

              color: priorityColor(t.priority),

              child: ListTile(

                title: Text(t.title),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(t.description),
                    Text("Purpose: ${t.purpose}"),
                    Text("Deadline: ${t.deadline}"),

                    if(t.completedTime!=null)
                      Text("Completed: ${t.completedTime}")

                  ],
                ),

                leading: Checkbox(

                  value: t.completed,

                  onChanged: (val){

                    setState(() {

                      t.completed = val!;

                      if(val){
                        t.completedTime = DateTime.now();
                      }

                    });

                    if(val!){

                      Future.delayed(Duration(milliseconds: 500),(){

                        setState(() {
                          tasks.removeAt(index);
                        });

                      });

                    }

                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/* ---------------- ADD TASK ---------------- */

class AddTaskScreen extends StatefulWidget {

  @override
  _AddTaskScreenState createState()=>_AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen>{

  TextEditingController title=TextEditingController();
  TextEditingController description=TextEditingController();

  String priority="Low";
  String purpose="College";

  DateTime deadline=DateTime.now();

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: Text("Add Task"),
        backgroundColor: Colors.purple.shade200,
      ),

      body: Padding(
        padding: EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(
              controller: title,
              decoration: InputDecoration(labelText: "Task Title"),
            ),

            TextField(
              controller: description,
              decoration: InputDecoration(labelText: "Description"),
            ),

            DropdownButton(

              value: priority,

              items: ["Low","Medium","High"]
                  .map((p)=>DropdownMenuItem(
                value:p,
                child: Text(p),
              )).toList(),

              onChanged:(val){
                setState(() {
                  priority=val.toString();
                });
              },
            ),

            DropdownButton(

              value: purpose,

              items: ["College","Personal","Other"]
                  .map((p)=>DropdownMenuItem(
                value:p,
                child: Text(p),
              )).toList(),

              onChanged:(val){
                setState(() {
                  purpose=val.toString();
                });
              },
            ),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
              ),

              child: Text("Select Deadline"),

              onPressed:() async{

                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if(date!=null){

                  TimeOfDay? time=await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now());

                  if(time!=null){

                    deadline = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute
                    );
                  }
                }
              },
            ),

            SizedBox(height:20),

            ElevatedButton(

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),

              child: Text("Save Task"),

              onPressed:(){

                Navigator.pop(

                  context,

                  Task(
                    title:title.text,
                    description:description.text,
                    priority:priority,
                    purpose:purpose,
                    deadline:deadline,
                  ),

                );

              },
            )

          ],
        ),
      ),
    );
  }
}