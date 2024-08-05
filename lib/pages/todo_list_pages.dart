import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import 'package:lista_de_tarefas/repositories/todo_repository.dart';

import '../widgets/todo_list_item.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController todoController = TextEditingController();//variavel para controlar o estado do meu campo de texto
  final TodoRepository todoRepository = new TodoRepository();


  List<Todo> todos = []; // todos são tarefas em inglês

  Todo? deleteTodo; // deleta o intem da lista
  int? deleteTodoPos; // pega a posição do item deletado

  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value){ //foi criado uma função pra salvar o ultimo estado da aplicação e ele é chamado aqui pra
      // não perder as informações
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      //mantem o app na tela de forma que fique totalemnte ajustado
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lista de Tarefas',
            style:TextStyle(
              color: Colors.white,
            ) ,),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            // afastamento entre os componentes
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ocupa a menor area possivel
              children: [
                Row(
                  // Aqui que faço pra colocar lado a lado um componente
                  children: [
                    Expanded(
                      // dimesiona o componente na largura maxima da tela
                      //flex: 3, // Aqui eu determino que meu campo texto vai ter um peso maior que o botão, por isso vai preencher  a tela inteira
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                          labelText: 'Adicione uma tarefa',
                          hintText: 'ex.: Estudar Inglês',
                          errorText: errorText ,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                              width: 2 // borda com campo texto
                            )
                          ),
                          labelStyle: TextStyle(
                            color: Colors.teal
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ), // largura entre o botão e campo de texto
                    ElevatedButton(
                      onPressed: () {
                        String text = todoController.text;
                        if(text.isEmpty){
                          setState(() {
                            errorText = 'Insira uma tarefa para continuar!!';
                          });
                          return;
                        }
                        setState(() {
                          Todo newTodo =
                              Todo(title: text, dateTime: DateTime.now());
                          todos.add(newTodo);
                          errorText =null; // Aqui eu tiro a mensagem de erro caso o campo esteja completo
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);// quando salvar uma nova tarefa ela é guardada no sharedPrederences
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.all(10)
                          //padding: EdgeInsets.zero espaçamento dentro do botão
                          //fixedSize: Size(width, height) tamanho do botão
                          ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                        color: Colors.white,
                      ),
                      /* Text('+',
                     style: TextStyle(
                       fontSize: 40,
                       color: Colors.white
                     ),
                    ),*/
                    ),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Flexible(
                  // ajusta a tela no seu tamanho maximo
                  child: ListView(
                    // Ao utlizar list View você pode fazer varios compontes na tela infinitos pois vc pode rolar a tela
                    shrinkWrap: true,
                    // faz com que minha lista ocupe oe melhor espaço possivel na tela ex: pode ser 1 item ou variois vai ocupar a tela
                    children: [
                      for (Todo todo
                          in todos) //para cada tarefa na minha lista de tarefas
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                      /*ListTile(
                          title: Text(todo),
                          //subtitle: Text('20/11/2024'),
                          //leading: Icon(Icons.save),
                          onTap: (){
                            print('tarefa $todo');
                          },
                        ),*/
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          'Você possui ${todos.length} tarefas pendentes'), // pega a quantia de tarefas
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.all(10),
                        //padding: EdgeInsets.zero espaçamento dentro do botão
                        //fixedSize: Size(width, height) tamanho do botão
                      ),
                      child: Text(
                        'Limpar tudo',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deleteTodo = todo; //qual intem vai ser removido da lista
    deleteTodoPos = todos.indexOf(todo); // e qual posição

    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);// quando salvar uma nova tarefa ela é guardada no sharedPrederences

    ScaffoldMessenger.of(context)
        .clearSnackBars(); // remover o snackbar atual e mostra o seguinte
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tarefa ${todo.title} foi removida com sucesso!!',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.teal,
          onPressed: () {
            setState(() {
              todos.insert(deleteTodoPos!, deleteTodo!);
            });
            todoRepository.saveTodoList(todos);// quando salvar uma nova tarefa ela é guardada no sharedPrederences
          },
        ),
        duration: Duration(seconds: 5),
      ),
    );
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar Tudo?'),
        content: Text('Você tem Certeza que deseja apagar todas as tarefas?'),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();// fecha o dialogo
            },
            style: TextButton.styleFrom(foregroundColor: Colors.teal), // mudar só a cor do texto
            child: Text('Cancelar',style: TextStyle(),),
          ),
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();// fecha o dialogo
              deleteAllTodos();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red), // mudar só a cor do texto
            child: Text('Limpar Tudo'),

          ),
        ],
      ),
    );
  }
  void deleteAllTodos() { // Limpa toda a lista
      setState(() {
        todos.clear();
      });
      todoRepository.saveTodoList(todos);// quando salvar uma nova tarefa ela é guardada no sharedPrederences
  }
}



/*void login(){
    String text = emailController.text;
    print(text);
    emailController.clear(); // serve para apagar o que tiver no campo texto
  }
  void onChanged(String text){
    //esse aqui retorna oq esta tudo a todod momento no campo texto

  void onSubmitted(String text){
    print(text); //esse aqui retorna oq esta escrttio no campo texto, quando aperta enter para confimar
  }
   */

/*
body: Center(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 32),// Coloca afastamento nos componentes
child: Column(
mainAxisSize: MainAxisSize.min, // define o tamanho da coluna
children: [
TextField(
controller: emailController, //controla oq tiver escrito no campo de texto email
decoration: InputDecoration(
labelText: 'Email',
border: OutlineInputBorder(),
),
onChanged: onChanged , // essa função mostra todas as mudanças que acontecerem no campo texto
// onSubmitted: onSubmitted,
),
ElevatedButton(
onPressed: login,
child: Text('Entrar'),
),
],
) //campo de texto flutter
),
),
decoration: InputDecoration(
labelText: 'Email',
//hintText: 'xxxxx@gmail.com',
border: OutlineInputBorder(),
//border: InputBorder.none pata tirar todas as linhas da borda
errorText: null ,// aparece a mensagem caso o usuario esqueça o campo vazio
//prefixText: 'R\$',
//suffixText: 'cm'
),
//obscureText: true, //Deixa oculto a senha
keyboardType: TextInputType.emailAddress, // Aqui eu defino o tipo de texto: numero, palavra...
style: TextStyle(
fontSize: 20, //tamanho da fonte
//fontWeight: FontWeight.w500, // fonte em negrito
//color: Colors.cyanAccent // Cor da fonte
),
// obscuringCharacter: '-', // define como vai ficar a bolinha oculta da senha

 */
