import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/task_storage.dart';
import '../../domain/models/task_model.dart';

final taskListProvider = StateNotifierProvider<TaskListNotifier, List<Task>>((ref) {
  return TaskListNotifier(storage: HiveTaskStorage());
});

class TaskListNotifier extends StateNotifier<List<Task>> {
  TaskListNotifier({required TaskStorage storage})
      : _storage = storage,
        super([]) {
    _loadInitialTasks();
  }

  final TaskStorage _storage;

  void _loadInitialTasks() {
    state = _storage.loadTasks();
    checkOverdueTasks();
  }

  void _persist() {
    _storage.saveTasks(state);
  }

  void checkOverdueTasks() {
    final now = DateTime.now();
    state = state.map((task) {
      if ((task.status == TaskStatus.pending || task.status == TaskStatus.inProgress) &&
          task.dueDate.isBefore(now)) {
        return task.copyWith(status: TaskStatus.overdue);
      }
      return task;
    }).toList();
    _persist();
  }

  void addTask(Task task) {
    state = [...state, task];
    checkOverdueTasks();
    _persist();
  }

  void toggleTaskComplete(String id) {
    state = state.map((task) {
      if (task.id == id) {
        if (task.status == TaskStatus.completed) {
          return task.copyWith(
            status: TaskStatus.pending,
            completedAt: null,
          );
        } else {
          return task.copyWith(
            status: TaskStatus.completed,
            completedAt: DateTime.now(),
          );
        }
      }
      return task;
    }).toList();
    checkOverdueTasks();
    _persist();
  }

  void updateTaskStatus(String id, TaskStatus status) {
    state = state.map((task) {
      if (task.id == id) {
        return task.copyWith(
          status: status,
          completedAt: status == TaskStatus.completed ? DateTime.now() : null,
        );
      }
      return task;
    }).toList();
    checkOverdueTasks();
    _persist();
  }

  void rescheduleTask(String id, DateTime newDueDate) {
    state = state.map((task) {
      if (task.id == id) {
        final now = DateTime.now();
        final newStatus = newDueDate.isBefore(now) ? TaskStatus.overdue : TaskStatus.pending;
        return task.copyWith(
          dueDate: newDueDate,
          status: newStatus,
        );
      }
      return task;
    }).toList();
    _persist();
  }

  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
    _persist();
  }

  bool completeTaskByName(String name) {
    bool found = false;
    state = state.map((task) {
      if (task.title.toLowerCase().contains(name.toLowerCase())) {
        found = true;
        return task.copyWith(
          status: TaskStatus.completed,
          completedAt: DateTime.now(),
        );
      }
      return task;
    }).toList();
    _persist();
    return found;
  }
}
