import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models.dart';
import 'providers.dart';


void main() {
  runApp(const ProviderScope(child: MyApp()));
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref){

    final List<Task> taskList = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReorderableListView(
          onReorder:(oldIndex, newIndex) {
            ref.read(tasksProvider.notifier).dragAndDrop(oldIndex, newIndex);
          },
          children: taskList.map((task) =>
            CheckboxListTile(
              key: Key(task.title),
              value: task.isDone,
              onChanged: (value)=>ref.read(tasksProvider.notifier).toggleDone(task.id),
              title: Text(task.title)
            ),
          ).toList(),
        ),
      ),
    );
  }
}