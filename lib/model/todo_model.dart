import 'package:sqflite/sqflite.dart';

final String tableTodo = "todo";
final String columnId = "id";
final String columnTitle = "title";
final String columnDone = "done";

class Todo {
  int id;
  String title;
  bool done = false;

Map<String, dynamic> toMap(){
  var map = <String, dynamic>{
    columnTitle: title,
    columnDone: done == true ? 1 : 0
  };
  if (id != null){
    map[columnId] = id;
  }
  return map;
}

  Todo({String title}){
    this.title = title;
  }

  Todo.fromMap(Map<String, dynamic> map){
    id = map[columnId];
    title = map[columnTitle];
    done = map[columnDone] == 1;
  }
}

class TodoProvider {
  Database db;
  Future open() async{
    var dbpath = await getDatabasesPath();
    String path = dbpath + 'todo.db';

    db = await openDatabase(
      path, 
      version: 1,
      onCreate: (Database db, int version) async{
        await db. execute('''
          create table $tableTodo(
            $columnId integer primary key autoincrement,
            $columnTitle text not null,
            $columnDone integer not null
            )
          ''');
    });
  }

  Future<Todo> insert(Todo todo) async{
    todo.id = await db.insert(tableTodo, todo.toMap());
    return todo;
  }

  Future<List<Todo>> getNotDoneTodo() async{
    var notdoneTodo = await db.query(tableTodo, where: '$columnDone = 0');
    return notdoneTodo.map((d) => Todo.fromMap(d)).toList();
  }

  Future<List<Todo>> getDoneTodo() async{
    var doneTodo = await db.query(tableTodo, where: '$columnDone = 1');
    return doneTodo.map((d) => Todo.fromMap(d)).toList();
  }

  Future<void> setTodo(Todo todo) async{
    await db.update(
      tableTodo,
      todo.toMap(),
      where: '$columnId = ?',
      whereArgs: [todo.id]
      );
  }

  Future<void> deleteDoneTodo() async{
    return await db.delete(tableTodo, where: '$columnDone = 1');
  }

  Future<int> delete(int id) async{
    return await db.delete(tableTodo, where: "$columnId = ?", whereArgs: [id]);
  }


  Future close() async => db.close();
}