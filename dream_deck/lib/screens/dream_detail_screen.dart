import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/dream.dart';
import '../models/manifest_item.dart';
import '../providers/category_provider.dart';
import '../providers/manifest_provider.dart';
import '../theme/app_theme.dart';
import 'action_feedback_screen.dart';

class DreamDetailScreen extends StatefulWidget {
  final Dream dream;

  const DreamDetailScreen({super.key, required this.dream});

  @override
  State<DreamDetailScreen> createState() => _DreamDetailScreenState();
}

class _DreamDetailScreenState extends State<DreamDetailScreen> {
  bool _isManifestHovered = false;
  bool _isBackToShuffleHovered = false;
  bool _isBackButtonHovered = false;

  void _manifestThis() {
    // Check if manifest already exists
    final manifestProvider = Provider.of<ManifestProvider>(context, listen: false);
    final existingManifest = manifestProvider.getManifestByDreamId(widget.dream.id);
    
    if (existingManifest != null) {
      // Already has a manifest, show message and go back
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This dream is already being tracked!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Create a manifest without goals - goals will be added via "Start Tracking"
    final manifest = ManifestItem(
      id: const Uuid().v4(),
      dreamId: widget.dream.id,
      title: widget.dream.title,
      checklist: [],
      goalValues: {},
      startedAt: DateTime.now(),
    );
    
    manifestProvider.addManifest(manifest);
    
    // Pop the detail screen first
    Navigator.pop(context);
    
    // Show animated feedback
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ActionFeedbackScreen(actionType: ActionType.manifested),
        opaque: false,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  void _backToShuffle() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasFirstStep =
        widget.dream.firstStep != null && widget.dream.firstStep!.isNotEmpty;
    final hasNotes =
        widget.dream.notes != null && widget.dream.notes!.isNotEmpty;
    final hasAnyOptionalContent = hasFirstStep || hasNotes;

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            onEnter: (_) => setState(() => _isBackButtonHovered = true),
            onExit: (_) => setState(() => _isBackButtonHovered = false),
            child: Material(
              color: Colors.white.withValues(
                alpha: _isBackButtonHovered ? 0.4 : 0.3,
              ),
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: _backToShuffle,
                borderRadius: BorderRadius.circular(20),
                child: const Center(
                  child: Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Colored header section with category and title
                  Consumer<CategoryProvider>(
                    builder: (context, categoryProvider, child) {
                      final categoryColor = widget.dream.categoryId != null
                          ? (categoryProvider.getCategoryById(widget.dream.categoryId!)?.color ??
                              widget.dream.category.color)
                          : widget.dream.category.color;
                      
                      final categoryEmoji = widget.dream.categoryId != null
                          ? (categoryProvider.getCategoryById(widget.dream.categoryId!)?.emoji ??
                              widget.dream.category.emoji)
                          : widget.dream.category.emoji;
                      
                      final categoryName = widget.dream.categoryId != null
                          ? (categoryProvider.getCategoryById(widget.dream.categoryId!)?.title ??
                              widget.dream.category.displayName)
                          : widget.dream.category.displayName;
                      
                      return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor.withValues(alpha: 0.9),
                          categoryColor,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 100, 24, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category badge with icon
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    categoryEmoji,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  categoryName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Title
                          Text(
                            widget.dream.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                    },
                  ),
                  // Content section
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!hasAnyOptionalContent) ...[
                          // Empty state message
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              'Ready to make this dream a reality?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.textSecondary.withValues(
                                  alpha: 0.8,
                                ),
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                height: 1.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ] else ...[
                          // First step section (if exists)
                          if (hasFirstStep) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.amber.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        '🚀',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'START WITH THIS',
                                        style: TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.dream.firstStep!,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 16,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (hasNotes) const SizedBox(height: 16),
                          ],
                          // Notes section (if exists)
                          if (hasNotes) ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Text(
                                        '📝',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'NOTES',
                                        style: TextStyle(
                                          color: AppTheme.textPrimary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    widget.dream.notes!,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 16,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Manifest this! button
                MouseRegion(
                  onEnter: (_) => setState(() => _isManifestHovered = true),
                  onExit: (_) => setState(() => _isManifestHovered = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isManifestHovered
                            ? [
                                AppTheme.primaryPurple.withValues(alpha: 0.9),
                                AppTheme.primaryPink.withValues(alpha: 0.9),
                              ]
                            : [
                                AppTheme.primaryPurple,
                                AppTheme.primaryPink,
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _manifestThis,
                        borderRadius: BorderRadius.circular(28),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.playlist_add_check, color: Colors.white, size: 24),
                              SizedBox(width: 8),
                              Text(
                                'Manifest this!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Back to Shuffle button
                MouseRegion(
                  onEnter: (_) =>
                      setState(() => _isBackToShuffleHovered = true),
                  onExit: (_) =>
                      setState(() => _isBackToShuffleHovered = false),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      color: _isBackToShuffleHovered
                          ? Colors.grey.shade200
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: _isBackToShuffleHovered
                            ? Colors.grey.shade400
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _backToShuffle,
                        borderRadius: BorderRadius.circular(28),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.replay,
                                color: _isBackToShuffleHovered
                                    ? AppTheme.textPrimary
                                    : AppTheme.textSecondary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Back to Shuffle',
                                style: TextStyle(
                                  color: _isBackToShuffleHovered
                                      ? AppTheme.textPrimary
                                      : AppTheme.textSecondary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
