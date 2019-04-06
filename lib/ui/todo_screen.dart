import 'package:flutter/material.dart';
import '../model/todo_model.dart';

class todoScreen extends StatefulWidget {
  @override
  _todoScreenState createState() => _todoScreenState();
}

class _todoScreenState extends State<todoScreen> {
  int _currentIndex = 0;
  TodoProvider todo = TodoProvider();
  List<Todo> notdoneTodo = List<Todo>();
  List<Todo> doneTodo = List<Todo>();
  
  @override
  void initState(){
    super.initState();
    todo.open().then((s){
      getAllTodo();
      });
  }
  void getAllTodo(){
    todo.getNotDoneTodo().then((d){
      setState(() {
        notdoneTodo = d;
      });
      todo.getDoneTodo().then((d){
        setState(() {
          doneTodo = d;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _appbar = [
      AppBar(
        title: Text("Todo"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, "/addListScreen");
            },
          )
        ],
      ),
      AppBar(
        title: Text("Todo"),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              todo.deleteDoneTodo().then((d){
                getAllTodo();
              });
            },
          )
        ],
      )
  ];
  final List<Widget> _children = [
    Center(
      child:
        notdoneTodo.length == 0
        ? Text('No data found..')
        :ListView(
          children: notdoneTodo.map((d){
            return CheckboxListTile(
              title: Text(d.title),
              value: d.done,
              onChanged: (bool value){
                setState(() {
                  d.done = value;
                  todo.setTodo(d);
                  getAllTodo();
                });
              },
            );
          }).toList(),
    )),
    Center(
      child:
     doneTodo.length == 0
    ? Text('No data found..')
    :ListView(
      children: doneTodo.map((d){
        return CheckboxListTile(
          title: Text(d.title),
          value: d.done,
          onChanged: (bool value){
            setState(() {
              d.done = value;
              todo.setTodo(d);
              getAllTodo();
            });
          },
        );
      }).toList(),
    )),
  ];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: _appbar[_currentIndex],
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: onTabTapped,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.list), title: Text("Task")),
              BottomNavigationBarItem(
                  icon: Icon(Icons.done_all), title: Text("Completed"))
            ],
          )),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
