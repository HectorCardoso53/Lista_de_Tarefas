class Todo{
  Todo({required this.title, required this.dateTime});

  Todo.fromJson(Map<String,dynamic> json)
      : title = json['title'],
        dateTime = DateTime.parse(json['datetime']); // convertendo o datetime

  String title;
  DateTime dateTime;

  Map<String, dynamic>toJson (){
    return {
      'title':title,
      'datetime':dateTime.toIso8601String(),// conertendo o formato data em string

    };
  }
}