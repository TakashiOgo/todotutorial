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
    bool editChange = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              return IconButton(
                onPressed: (){editChange != editChange;},
                icon: Icon(Icons.edit)
              );
            }
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            editChange == true?Card(
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('タスクを追加'),
                onTap: ()=> showDialog<String>(
                    context: context,
                    builder: (BuildContext context){
                      String appendTask = '';
                      return Consumer(
                        builder: (context, ref, _){
                          return AlertDialog(
                            title: const Text('タスクを追加'),
                            content: SizedBox(
                              child: TextField(
                                onChanged: (value){
                                  appendTask = value;
                                },
                                decoration: const InputDecoration(border: OutlineInputBorder()),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: (){
                                  ref.read(tasksProvider.notifier).addTask(
                                      Task(id: DateTime.now().millisecondsSinceEpoch, title: appendTask, isDone: false)
                                  );
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                ),
              ),
            ):Container(),
            Expanded(
              child: ReorderableListView(
                onReorder:(oldIndex, newIndex) {
                  ref.read(tasksProvider.notifier).dragAndDrop(oldIndex, newIndex);
                },
                children: taskList.map((task) =>
                  Card(
                    key: Key(task.title),
                    child: ListTile(
                      onTap: (){ref.read(tasksProvider.notifier).toggleDone(task.id);},
                      title: Text(task.title, style: task.isDone == true?const TextStyle(decoration: TextDecoration.lineThrough):null,),
                      trailing: task.isDone == true?const Icon(Icons.done):null,
                    ),
                  ),
                ).toList(),
              ),
            ),
            editChange == true?Card(
              child: ListTile(
                leading: Icon(Icons.add),
                title: Text('タスクを追加'),
                onTap: ()=> showDialog<String>(
                    context: context,
                    builder: (BuildContext context){
                      String appendTask = '';
                      return Consumer(
                        builder: (context, ref, _){
                          return AlertDialog(
                            title: const Text('タスクを追加'),
                            content: SizedBox(
                              child: TextField(
                                onChanged: (value){
                                  appendTask = value;
                                },
                                decoration: const InputDecoration(border: OutlineInputBorder()),
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: (){
                                  ref.read(tasksProvider.notifier).addTask(
                                      Task(id: DateTime.now().millisecondsSinceEpoch, title: appendTask, isDone: false)
                                  );
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                ),
              ),
            ):Container(),
          ],
        ),
      ),
    );
  }
}