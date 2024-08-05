import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/pages/todo_list_pages.dart';

void main(){
  runApp(MyApp()); // Reponsavel por rodar todo nosso app em flutter
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(    //trás diversas opções, como: navegação, temas, configuração de localização e etc.
      debugShowCheckedModeBanner: false,
      home: TodoListPage() , // é o parametro que especifica a tela inicial do app
    );
  }
}



