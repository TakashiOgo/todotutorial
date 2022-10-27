import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';

const List<Task> tasksList = [
  Task(id: 0, title: 'task1', isDone: false),
  Task(id: 1, title: 'task2', isDone: false),
  Task(id: 2, title: 'task3', isDone: false),
];

class TasksNotifier extends StateNotifier<List<Task>> {
  TasksNotifier(): super(tasksList);

  void addTask(Task newTask) {
    List<Task> newState = [];
    for (final task in state){
      newState.add(task);
    }
    newState.add(newTask);
    state = newState;
  }

  void toggleDone(int id){
    List<Task> newState = [];
    for (final task in state){
      if(task.id == id){
        newState.add(task.copyWith(isDone: !task.isDone));
      }else{
        newState.add(task);
      }
    }
    state = newState;
  }

  void dragAndDrop(int oldIndex, int newIndex) {
    List<Task> newState = [];
    if(oldIndex < newIndex) {
      newIndex -= 1;
    }
    Task task = tasksList.removeAt(oldIndex);
    tasksList.insert(newIndex, task);
    state = newState;
  }

}

final tasksProvider = StateNotifierProvider<TasksNotifier, List<Task>>((ref) {
  return TasksNotifier();
});