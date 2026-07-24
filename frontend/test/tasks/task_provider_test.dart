import 'package:flutter_test/flutter_test.dart';
import 'package:krishios/features/tasks/data/task_storage.dart';
import 'package:krishios/features/tasks/domain/models/task_model.dart';
import 'package:krishios/features/tasks/presentation/providers/task_provider.dart';

Task _task(String id) {
  return Task(
    id: id,
    title: 'Task $id',
    description: 'desc',
    priority: TaskPriority.medium,
    estimatedDurationMinutes: 30,
    status: TaskStatus.pending,
    category: TaskCategory.custom,
    dueDate: DateTime(2026, 7, 24),
  );
}

void main() {
  test('task notifier loads persisted tasks on recreation', () async {
    final storage = InMemoryTaskStorage(initialTasks: [_task('a')]);

    final notifier = TaskListNotifier(storage: storage);
    expect(notifier.state.map((task) => task.id), ['a']);

    notifier.addTask(_task('b'));

    final recreated = TaskListNotifier(storage: storage);
    expect(recreated.state.map((task) => task.id), ['a', 'b']);
  });

  test('completeTaskByName persists status changes', () async {
    final storage = InMemoryTaskStorage(initialTasks: [_task('a')]);
    final notifier = TaskListNotifier(storage: storage);

    final updated = notifier.completeTaskByName('Task a');
    expect(updated, isTrue);

    final recreated = TaskListNotifier(storage: storage);
    expect(recreated.state.single.status, TaskStatus.completed);
  });
}
