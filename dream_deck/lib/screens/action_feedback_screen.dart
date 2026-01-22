import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum ActionType {
  completed,
  snoozed,
  reactivated,
  manifested,
  deleted,
}

class ActionFeedbackScreen extends StatefulWidget {
  final ActionType actionType;

  const ActionFeedbackScreen({super.key, required this.actionType});

  @override
  State<ActionFeedbackScreen> createState() => _ActionFeedbackScreenState();
}

class _ActionFeedbackScreenState extends State<ActionFeedbackScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _iconRotation;

  String get _title {
    switch (widget.actionType) {
      case ActionType.completed:
        return 'Dream Completed!';
      case ActionType.snoozed:
        return 'Not Now!';
      case ActionType.reactivated:
        return 'Dream Reactivated!';
      case ActionType.manifested:
        return 'Manifesting!';
      case ActionType.deleted:
        return 'Manifest Deleted!';
    }
  }

  String get _emoji {
    switch (widget.actionType) {
      case ActionType.completed:
        return '🎉';
      case ActionType.snoozed:
        return '💤';
      case ActionType.reactivated:
        return '🔄';
      case ActionType.manifested:
        return '✨';
      case ActionType.deleted:
        return '🗑️';
    }
  }

  IconData get _icon {
    switch (widget.actionType) {
      case ActionType.completed:
        return Icons.check_circle;
      case ActionType.snoozed:
        return Icons.access_time;
      case ActionType.reactivated:
        return Icons.replay;
      case ActionType.manifested:
        return Icons.playlist_add_check;
      case ActionType.deleted:
        return Icons.delete_outline;
    }
  }

  Color get _color {
    switch (widget.actionType) {
      case ActionType.completed:
        return Colors.green.shade500;
      case ActionType.snoozed:
        return Colors.orange.shade500;
      case ActionType.reactivated:
        return AppTheme.primaryPurple;
      case ActionType.manifested:
        return AppTheme.primaryPurple;
      case ActionType.deleted:
        return Colors.red.shade500;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _iconRotation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();

    // Auto close after animation completes
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with background
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _iconRotation.value * 3.14159,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: _color.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _icon,
                          size: 60,
                          color: _color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Title text
                  Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      children: [
                        Text(
                          _title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _emoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
