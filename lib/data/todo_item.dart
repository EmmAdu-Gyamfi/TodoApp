class TodoItem {
  late final int todoItemId;

  late final String todoActivity;

  late final String? place;

  late final String? dueDate;

  late  bool? isChecked = false;

  TodoItem({
    required this.todoItemId,
    required this.todoActivity,
    required this.place,
    required this.dueDate,
   });

  TodoItem.fromJson(dynamic json) {
    todoItemId = json['todoItemId'];
    todoActivity = json['todoActivity'];
    place = json['place'];
    dueDate = json['dueDate'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['todoItemId'] = todoItemId;
    _data['todoActivity'] = todoActivity;
    _data['place'] = place;
    _data['dueDate'] = dueDate;
    return _data;
  }
}