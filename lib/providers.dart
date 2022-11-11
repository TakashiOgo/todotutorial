import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'database.dart';

List<Task> tasksList = [];

final editProvider = StateProvider<bool>((ref) => false);

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier(this._taskDatabase): super(tasksList);

  final TaskDatabase _taskDatabase;

  void addTask(Task newTask) {
    List<Task> newState = [];
    for (final task in state){
      newState.add(task);
    }
    newState.add(newTask);
    state = newState;
  }

  void insertTask(Task newTask) {
    List<Task> newState = [];
    for (final task in state){
      newState.add(task);
    }
    newState.insert(0,newTask);
    state = newState;
  }

  void removeTask(int id) {
    List<Task> newState = [];
    for (final task in state){
      if(task.id != id){
        newState.add(task);
      }
    }
    state = newState;
  }

  void editTask(int id, String title) {
    List<Task> newState = [];
    for (final task in state) {
      if (task.id == id) {
        newState.add(task.copyWith(title: title));
      } else {
        newState.add(task);
      }
    }
    state = newState;
  }

  void toggleDone(int id){
    List<Task> newState = [];
    for (final task in state){
      if(task.id == id){
        newState.add(task.copyWith(isDone: task.isDone==0?1:0));
      }else{
        newState.add(task);
      }
    }
    state = newState;
  }

  void dragAndDrop(int oldIndex, int newIndex) {
    List<Task> newState = [];
    for (final task in state) {
      newState.add(task);
    }
    final movedTask = newState.removeAt(oldIndex);
    final insertionIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    newState.insert(insertionIndex, movedTask);
    state = newState;
  }

  Future<void> getTodos() async {
    List<Task> newState = [];
    newState = await _taskDatabase.getTasks();
    state = newState;
  }

  Future<void> insertTodo(Task task) async {
    List<Task> newState = [];
    _taskDatabase.insertTask(task);
    newState = await _taskDatabase.getTasks();
    state = newState;
  }

  Future<void> updateTodo(Task task) async {
    List<Task> newState = [];
    _taskDatabase.updateTask(task);
    newState = await _taskDatabase.getTasks();
    state = newState;
  }

  Future<void> deleteTodo(int id) async {
    List<Task> newState = [];
    _taskDatabase.deleteTask(id);
    newState = await _taskDatabase.getTasks();
    state = newState;
  }

}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier(TaskDatabase());
});