import 'package:krishios/features/tasks/domain/models/task_model.dart';
import 'package:krishios/shared/services/hive_service.dart';

abstract class TaskStorage {
  List<Task> loadTasks();
  void saveTasks(List<Task> tasks);
}

class HiveTaskStorage implements TaskStorage {
  @override
  List<Task> loadTasks() {
    final box = HiveService.getTasksBox();
    final rawTasks = box.get('items', defaultValue: const <Map<String, dynamic>>[]) as List;
    return rawTasks
        .map((entry) => _taskFromMap(Map<String, dynamic>.from(entry as Map)))
        .toList();
  }

  @override
  void saveTasks(List<Task> tasks) {
    final box = HiveService.getTasksBox();
    box.put('items', tasks.map(_taskToMap).toList(growable: false));
  }
}

class InMemoryTaskStorage implements TaskStorage {
  InMemoryTaskStorage({List<Task>? initialTasks})
      : _tasks = List<Task>.from(initialTasks ?? const <Task>[]);

  List<Task> _tasks;

  @override
  List<Task> loadTasks() => List<Task>.from(_tasks);

  @override
  void saveTasks(List<Task> tasks) {
    _tasks = List<Task>.from(tasks);
  }
}

Task _taskFromMap(Map<String, dynamic> map) {
  return Task(
    id: map['id'] as String,
    title: map['title'] as String,
    description: map['description'] as String,
    priority: TaskPriority.values.byName(map['priority'] as String),
    estimatedDurationMinutes: map['estimatedDurationMinutes'] as int,
    status: TaskStatus.values.byName(map['status'] as String),
    category: TaskCategory.values.byName(map['category'] as String),
    dueDate: DateTime.parse(map['dueDate'] as String),
    completedAt: map['completedAt'] == null ? null : DateTime.parse(map['completedAt'] as String),
    reminderTime: map['reminderTime'] == null ? null : DateTime.parse(map['reminderTime'] as String),
    isRecurrent: map['isRecurrent'] as bool? ?? false,
  );
}

Map<String, dynamic> _taskToMap(Task task) {
  return {
    'id': task.id,
    'title': task.title,
    'description': task.description,
    'priority': task.priority.name,
    'estimatedDurationMinutes': task.estimatedDurationMinutes,
    'status': task.status.name,
    'category': task.category.name,
    'dueDate': task.dueDate.toIso8601String(),
    'completedAt': task.completedAt?.toIso8601String(),
    'reminderTime': task.reminderTime?.toIso8601String(),
    'isRecurrent': task.isRecurrent,
  };
}
