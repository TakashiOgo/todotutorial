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
    final editChange = ref.watch(editProvider.state);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDoリスト'),
        actions: [
          IconButton(
            onPressed: (){ref.read(editProvider.notifier).state = !ref.read(editProvider.notifier).state;},
            icon: editChange.state == false?const Icon(Icons.edit):const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReorderableListView(
          header: editChange.state == false?null:ListTile(
            onTap: ()=> showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                String title = '';
                return Consumer(
                    builder: (context, ref, _) {
                    return AlertDialog(
                      title: const Text('タスクを追加'),
                      content: SizedBox(
                        child: TextField(
                          onChanged: (value){
                            title = value;
                          },
                          decoration: const InputDecoration(labelText: 'タスク名'),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: (){
                            ref.read(tasksProvider.notifier).insertTask(
                                Task(id: DateTime.now().millisecondsSinceEpoch, title: title, isDone: false)
                            );
                            Navigator.pop(context, 'OK');
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  }
                );
              }
            ),
            leading: const Icon(Icons.add),
            title: const Text('タスクを追加'),
          ),
          onReorder:(oldIndex, newIndex) {
            ref.read(tasksProvider.notifier).dragAndDrop(oldIndex, newIndex);
          },
          footer: editChange.state == false?null:ListTile(
            onTap: ()=> showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  String title = '';
                  return Consumer(
                      builder: (context, ref, _) {
                        return AlertDialog(
                          title: const Text('タスクを追加'),
                          content: SizedBox(
                            child: TextField(
                              onChanged: (value){
                                title = value;
                              },
                              decoration: const InputDecoration(labelText: 'タスク名'),
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
                                    Task(id: DateTime.now().millisecondsSinceEpoch, title: title, isDone: false)
                                );
                                Navigator.pop(context, 'OK');
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      }
                  );
                }
            ),
            leading: const Icon(Icons.add),
            title: const Text('タスクを追加'),
          ),
          children: taskList.map((task) =>
            Card(
              key: Key(task.title),
              child: ListTile(
                onTap: (){editChange.state == false?
                  ref.read(tasksProvider.notifier).toggleDone(task.id):
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        String title = '';
                        return Consumer(
                            builder: (context, ref, _) {
                              return AlertDialog(
                                title: const Text('タスクの編集'),
                                content: SizedBox(
                                  child: TextField(
                                    onChanged: (value){
                                      title = value;
                                    },
                                    decoration: const InputDecoration(labelText: 'タスク名'),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: (){
                                      ref.read(tasksProvider.notifier).editTask(task.id, title);
                                      Navigator.pop(context, 'OK');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            }
                        );
                      }
                  );},
                title: Text(task.title, style: task.isDone == true?const TextStyle(decoration: TextDecoration.lineThrough):null,),
                trailing: editChange.state == true?
                IconButton(
                  onPressed: (){ref.read(tasksProvider.notifier).removeTask(task.id);},
                  icon: Icon(Icons.clear),
                ): task.isDone == true?const Icon(Icons.done):null
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}