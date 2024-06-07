import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/data/todo_item.dart';

// import 'dart:convert' as convert;

part 'todo_item_state.dart';

class TodoItemCubit extends Cubit<TodoItemState> {
  TodoItemCubit() : super(TodoItemInitial());
  final  _dio = Dio();
  Future<void> loadTodoItem() async {
    try{
      emit(TodoItemLoadingInProgress());
      var response = await _dio.get('http://10.0.2.2:5000/api/todoitems');
      if(response.statusCode == 200) {
        Iterable list = await jsonDecode(jsonEncode(response.data) ) ;
        List<TodoItem> todoItems = <TodoItem>[];
        todoItems = list.map((e) => TodoItem.fromJson(e)).toList();
        emit(TodoItemLoadingSucceeded(todoItems));

      } else {
        emit(TodoItemLoadingFailed(response.statusMessage));
      }
    } catch (e){
      emit(TodoItemLoadingFailed(e.toString()));
    }
  }

  Future<void> postTodoItem(String todoActivity, String? place, String? dueDate) async {
    var url = Uri.parse('http://10.0.2.2:5000/api/todoitems');
    try{
      emit(TodoItemLoadingInProgress());
      var parsedDate = DateTime.parse(dueDate!);
      var response = await http.post(url, headers: {
      "Accept": "application/json",
      "content-type":"application/json"
      }, body: jsonEncode({'todoActivity': todoActivity, 'place': place, 'dueDate': dueDate}));
      if(response.statusCode == 200) {
        loadTodoItem();
      } else {
        emit(TodoItemLoadingFailed(response.reasonPhrase));
      }
    } catch (e){
      emit(TodoItemLoadingFailed(e.toString()));
    }
  }

  Future<void> putTodoItem(String todoActivity, String? place, String? dueDate, int todoItemId) async {
    var url = Uri.parse('http://10.0.2.2:5000/api/todoitems/$todoItemId');
    try{
      emit(TodoItemLoadingInProgress());
      var parsedDate = DateTime.parse(dueDate!);
      var response = await http.put(url, headers: {
        "Accept": "application/json",
        "content-type":"application/json"
      }, body: jsonEncode({'todoActivity': todoActivity, 'place': place, 'dueDate': dueDate}));
      if(response.statusCode == 204) {
        loadTodoItem();
      } else {
        emit(TodoItemLoadingFailed(response.reasonPhrase));
      }
    } catch (e){
      emit(TodoItemLoadingFailed(e.toString()));
    }
  }

  Future<void> deleteTodoItem(int todoItemId) async {
    var url = Uri.parse('http://10.0.2.2:5000/api/todoitems/$todoItemId');
    try{
      emit(TodoItemLoadingInProgress());
      var response = await http.delete(url, headers: {
        "Accept": "application/json",
        "content-type":"application/json"
      });
      if(response.statusCode == 204) {
        loadTodoItem();
      } else {
        emit(TodoItemLoadingFailed(response.reasonPhrase));
      }
    } catch (e){
      emit(TodoItemLoadingFailed(e.toString()));
    }
  }
}



