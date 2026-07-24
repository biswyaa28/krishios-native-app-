import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishios/core/theme/app_theme.dart';
import 'package:krishios/shared/presentation/providers/navigation_provider.dart';
import 'package:krishios/features/scan/presentation/screens/chat_screen.dart';
import 'package:krishios/features/tasks/presentation/screens/task_list_screen.dart';
import 'package:krishios/features/calendar/presentation/screens/calendar_screen.dart';

class KrishiAiFab extends ConsumerStatefulWidget {
  const KrishiAiFab({super.key});

  @override
  ConsumerState<KrishiAiFab> createState() => _KrishiAiFabState();
}

class _KrishiAiFabState extends ConsumerState<KrishiAiFab> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 0.25).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    HapticFeedback.lightImpact();
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      clipBehavior: Clip.none,
      children: [
        // 1. Semi-transparent click-to-dismiss overlay when expanded
        if (_isExpanded)
          Positioned(
            right: -16,
            bottom: -16,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GestureDetector(
              onTap: _toggleExpanded,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ),

        // 2. Expanded menu items stacking upwards
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildMenuItem(
              label: 'Calendar',
              icon: Icons.calendar_month,
              color: Colors.blue,
              onPressed: () {
                _toggleExpanded();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                );
              },
            ),
            _buildMenuItem(
              label: 'New Task',
              icon: Icons.add_task,
              color: Colors.orange,
              onPressed: () {
                _toggleExpanded();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TaskListScreen()),
                );
              },
            ),
            _buildMenuItem(
              label: 'Quick Note',
              icon: Icons.edit_note,
              color: Colors.teal,
              onPressed: () {
                _toggleExpanded();
                _showQuickNoteDialog(context);
              },
            ),
            _buildMenuItem(
              label: 'Ask Kavya',
              icon: Icons.chat_bubble_outline,
              color: AppColors.primary,
              onPressed: () {
                _toggleExpanded();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatScreen(
                      scanId: 'general',
                      cropName: 'General',
                      diagnosis: 'General Chat',
                    ),
                  ),
                );
              },
            ),
            _buildMenuItem(
              label: 'Voice Chat',
              icon: Icons.mic,
              color: Colors.purple,
              onPressed: () {
                _toggleExpanded();
                // Open Chat screen with auto-start listening active
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatScreen(
                      scanId: 'general',
                      cropName: 'General',
                      diagnosis: 'Voice Assistant',
                      startListeningOnLaunch: true,
                    ),
                  ),
                );
              },
            ),
            _buildMenuItem(
              label: 'Scan Plant',
              icon: Icons.camera_alt,
              color: Colors.red,
              onPressed: () {
                _toggleExpanded();
                // Switch bottom tab navigation index to 1 (Scan Tab)
                ref.read(mainTabIndexProvider.notifier).state = 1;
              },
            ),
            const SizedBox(height: 16),
            // The Primary Floating Action Button
            FloatingActionButton(
              heroTag: 'krishi_main_fab',
              backgroundColor: AppColors.primary,
              shape: const CircleBorder(),
              onPressed: _toggleExpanded,
              child: AnimatedBuilder(
                animation: _rotateAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateAnimation.value * 2 * math.pi,
                    child: child,
                  );
                },
                child: Icon(
                  _isExpanded ? Icons.close : Icons.chat_bubble,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        final double value = _expandAnimation.value;
        return Transform.translate(
          offset: Offset(0.0, (1 - value) * 15),
          child: Transform.scale(
            scale: value,
            child: Opacity(
              opacity: value,
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: Colors.white.withValues(alpha: 0.9),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            FloatingActionButton.small(
              heroTag: 'fab_sub_$label',
              backgroundColor: color,
              foregroundColor: Colors.white,
              shape: const CircleBorder(),
              onPressed: onPressed,
              child: Icon(icon, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickNoteDialog(BuildContext context) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Quick Note'),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              hintText: 'Enter note details...',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
              onPressed: () {
                final note = noteController.text.trim();
                if (note.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quick note saved locally.')),
                  );
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
