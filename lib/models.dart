import 'package:flutter/material.dart';

@immutable
class Task{
  const Task({
    required this.id,
    required this.title,
    required this.isDone,
  });

  final int id;
  final String title;
  final int isDone;

  Task copyWith({int? id, String? title, int? isDone}) {
    return Task(
      id: id?? this.id,
      title: title?? this.title,
      isDone: isDone?? this.isDone,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
    };
  }

}