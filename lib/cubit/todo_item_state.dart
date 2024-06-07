part of 'todo_item_cubit.dart';

abstract class TodoItemState extends Equatable {
  const TodoItemState();
  @override
  List<Object?> get props => [];
}

class TodoItemInitial extends TodoItemState {

}

class TodoItemLoadingInProgress extends TodoItemState {

}

class TodoItemLoadingSucceeded extends TodoItemState {
   final List<TodoItem> todoItem;

  const TodoItemLoadingSucceeded(this.todoItem);

  @override
  // TODO: implement props
    List<Object?> get props => [todoItem];
}
class TodoItemPostSucceeded extends TodoItemState {

}

class TodoItemLoadingFailed extends TodoItemState {
  final String? message;

  const TodoItemLoadingFailed(this.message);
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
