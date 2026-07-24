import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'ai_engine.dart';
import 'context_manager.dart';
import 'recommendation_engine.dart';
import 'package:krishios/shared/models/chat_message.dart';
import 'package:krishios/features/scan/presentation/providers/scan_provider.dart';
import 'package:krishios/features/tasks/presentation/providers/task_provider.dart';
import 'package:krishios/features/tasks/domain/models/task_model.dart';

class KavyaService {
  final Ref _ref;
  final ContextManager _contextManager;
  final RecommendationEngine _recommendationEngine;

  KavyaService(this._ref)
      : _contextManager = ContextManager(_ref),
        _recommendationEngine = RecommendationEngine();

  ContextManager get contextManager => _contextManager;
  RecommendationEngine get recommendationEngine => _recommendationEngine;

  Future<ChatMessage> getResponse({
    required String query,
    required String scanId,
    required String languageCode,
  }) async {
    final lowercaseQuery = query.toLowerCase();

    // 1. Intercept "what should i do today" / "show today's tasks" / "show pending tasks"
    if (lowercaseQuery.contains('what should i do today') ||
        lowercaseQuery.contains("show today's tasks") ||
        lowercaseQuery.contains('show pending tasks') ||
        lowercaseQuery.contains('show tasks')) {
      final tasks = _ref.read(taskListProvider);
      final pending = tasks.where((t) => t.status != TaskStatus.completed).toList();
      if (pending.isEmpty) {
        return ChatMessage(
          isUser: false,
          text: "You have completed all your tasks for today! Outstanding job! 🌱",
          timestamp: DateTime.now(),
        );
      }
      final taskListString = pending.map((t) => "• ${t.title} (${t.priority.name.toUpperCase()})").join("\n");
      return ChatMessage(
        isUser: false,
        text: "Here are your pending tasks for today:\n\n$taskListString\n\nLet me know if you would like me to mark any of them as completed!",
        timestamp: DateTime.now(),
      );
    }

    // 2. Intercept "mark harvesting completed" / "mark done"
    if (lowercaseQuery.contains('mark') && (lowercaseQuery.contains('completed') || lowercaseQuery.contains('done'))) {
      String target = query
          .replaceAll(RegExp(r'\bmark\b', caseSensitive: false), '')
          .replaceAll(RegExp(r'\bcompleted\b', caseSensitive: false), '')
          .replaceAll(RegExp(r'\bdone\b', caseSensitive: false), '')
          .replaceAll(RegExp(r'\bas\b', caseSensitive: false), '')
          .trim();
      if (target.isEmpty) target = "harvest"; // fallback

      final found = _ref.read(taskListProvider.notifier).completeTaskByName(target);
      if (found) {
        return ChatMessage(
          isUser: false,
          text: "I have marked your task containing '$target' as completed! Keep up the good work! 👍",
          timestamp: DateTime.now(),
        );
      } else {
        return ChatMessage(
          isUser: false,
          text: "I couldn't find a pending task containing '$target'. Please verify the title or add it to your tasks list.",
          timestamp: DateTime.now(),
        );
      }
    }

    // 3. Intercept "move irrigation to tomorrow"
    if (lowercaseQuery.contains('move') && (lowercaseQuery.contains('tomorrow') || lowercaseQuery.contains('reschedule'))) {
      String target = "irrigation";
      if (lowercaseQuery.contains('harvest')) target = "harvest";
      if (lowercaseQuery.contains('spraying') || lowercaseQuery.contains('spray')) target = "spray";

      final tasks = _ref.read(taskListProvider);
      final tomorrow = DateTime.now().add(const Duration(days: 1));

      // Try to find a matching non-completed task
      try {
        final match = tasks.firstWhere(
          (t) => t.title.toLowerCase().contains(target) && t.status != TaskStatus.completed,
        );
        _ref.read(taskListProvider.notifier).rescheduleTask(match.id, tomorrow);
        return ChatMessage(
          isUser: false,
          text: "I have rescheduled the task '${match.title}' to tomorrow, ${DateFormat('EEEE, MMM dd').format(tomorrow)}.",
          timestamp: DateTime.now(),
        );
      } catch (_) {
        return ChatMessage(
          isUser: false,
          text: "I couldn't find any pending task matching '$target' to reschedule.",
          timestamp: DateTime.now(),
        );
      }
    }

    // 4. Intercept "schedule spraying" / "create reminder"
    if (lowercaseQuery.contains('schedule') || lowercaseQuery.contains('create reminder') || lowercaseQuery.contains('add task')) {
      final now = DateTime.now();
      String title = "Spray crops";
      if (lowercaseQuery.contains('fertilizer')) title = "Apply fertilizer";
      if (lowercaseQuery.contains('irrigate') || lowercaseQuery.contains('watering')) title = "Irrigate crops";

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: 'Scheduled via Kavya Voice/Text Assistant input command.',
        priority: TaskPriority.medium,
        estimatedDurationMinutes: 30,
        status: TaskStatus.pending,
        category: title.contains('Spray') ? TaskCategory.pesticide : TaskCategory.custom,
        dueDate: now.add(const Duration(days: 1)),
      );
      _ref.read(taskListProvider.notifier).addTask(newTask);

      return ChatMessage(
        isUser: false,
        text: "I have successfully created and scheduled the task '$title' for tomorrow! 🚀",
        timestamp: DateTime.now(),
      );
    }

    // 5. Compile active application context
    final context = await _contextManager.buildContext(scanId);

    // 6. Select pluggable AI engine dynamically (Hybrid online/offline execution)
    final manager = _ref.read(aiEngineManagerProvider);
    final AIEngine activeEngine;

    if (manager.isUsingLocal) {
      activeEngine = OfflineKnowledgeEngine();
    } else {
      activeEngine = FastAPIEngine(resolvedBaseUrl: manager.resolvedBaseUrl);
    }

    // 7. Delegate to AI runtime engine
    return activeEngine.sendMessage(
      query: query,
      context: context,
      languageCode: languageCode,
    );
  }
}

final kavyaServiceProvider = Provider<KavyaService>((ref) {
  return KavyaService(ref);
});
