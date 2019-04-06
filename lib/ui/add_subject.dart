import 'package:flutter/material.dart';
import '../model/todo_model.dart';

class addListScreen extends StatefulWidget {
  @override
  _addListScreenState createState() => _addListScreenState();
}

class _addListScreenState extends State<addListScreen> {
  TextEditingController subjectcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TodoProvider todo = TodoProvider();

  void initState(){
    super.initState();
    todo.open().then((d){});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Subject"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Subject'),
              controller: subjectcontroller,
              validator: (value){
                if (subjectcontroller.text == '') return 'Please fill subject';
              },
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: RaisedButton(
                    child: Text("Save"),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        Todo value = Todo(title: subjectcontroller.text);
                        todo.insert(value).then((d){
                          Navigator.pushNamed(context, "/");
                        });
                      }
                      // Navigator.pushNamed(context, "/");
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),)
    );
  }
}