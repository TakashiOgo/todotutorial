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
  final bool isDone;

  Task copyWith({int? id, String? title, bool? isDone}) {
    return Task(
      id: id?? this.id,
      title: title?? this.title,
      isDone: isDone?? this.isDone,
    );
  }
}