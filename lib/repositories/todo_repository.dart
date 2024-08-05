import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

const todoListKey = 'todo_list';

class TodoRepository {

  late SharedPreferences sharedPreferences; // late vai ser iniciada no futuro

  Future <List<Todo>> getTodoList() async{
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(todoListKey) ?? '[]'; // se a lista for vazia, chama essa função
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e)=> Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos){
    final String jsonString = json.encode(todos); // tranforma tudo que tenho em texto
    sharedPreferences.setString(todoListKey, jsonString);
  }
}

/*
 **`Future`**: Representa um valor que será disponibilizado no futuro, após a conclusão de uma operação assíncrona.

- **`async`**: Marca uma função para que ela possa usar `await` e retornar um `Future`. Indica que a função executará operações assíncronas.

- **`await`**: Pausa a execução de uma função `async` até que o `Future` seja concluído, facilitando a escrita de código assíncrono de forma mais linear.

    */