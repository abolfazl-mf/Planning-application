
import 'package:hive/hive.dart';

part 'todo_model.g.dart';
@HiveType(typeId: 1)
class Todo{

  @HiveField(0)

  String text;

  Todo(this.text);
}