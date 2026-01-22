import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/manifest_provider.dart';
import '../providers/dream_provider.dart';
import '../models/manifest_item.dart';
import '../models/dream.dart';
import '../theme/app_theme.dart';
import 'action_feedback_screen.dart';

class ManifestScreen extends StatefulWidget {
  const ManifestScreen({super.key});

  @override
  State<ManifestScreen> createState() => _ManifestScreenState();
}

class _ManifestScreenState extends State<ManifestScreen> {
  bool _showCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppTheme.primaryPurple, AppTheme.primaryPink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.playlist_add_check,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 8),
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [AppTheme.primaryPurple, AppTheme.primaryPink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds),
                  child: const Text(
                    'Manifest',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              'Track your progress ✨',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Toggle button for Active/Completed
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment<bool>(
                      value: false,
                      label: Text('Active'),
                      icon: Icon(Icons.work, size: 18),
                    ),
                    ButtonSegment<bool>(
                      value: true,
                      label: Text('Completed'),
                      icon: Icon(Icons.history, size: 18),
                    ),
                  ],
                  selected: {_showCompleted},
                  onSelectionChanged: (Set<bool> newSelection) {
                    setState(() {
                      _showCompleted = newSelection.first;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppTheme.primaryPurple;
                      }
                      return Colors.grey.shade200;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return AppTheme.textSecondary;
                    }),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ManifestProvider>(
              builder: (context, manifestProvider, child) {
                final manifests = _showCompleted
                    ? manifestProvider.completedManifests
                    : manifestProvider.activeManifests;

                if (manifests.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: manifests.length,
                  itemBuilder: (context, index) {
                    final manifest = manifests[index];
                    return _buildManifestCard(context, manifest);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: SizedBox(
        height: 64,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryPurple, AppTheme.primaryPink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => showAddManifestDialog(context),
                    borderRadius: BorderRadius.circular(32),
                    child: const Icon(
                      Icons.add_task,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.playlist_add_check,
              size: 60,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _showCompleted ? 'No completed manifests' : 'No active manifests',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _showCompleted
                ? 'Completed items will appear here'
                : 'Start tracking progress on your dreams!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildManifestCard(BuildContext context, ManifestItem manifest) {
  return Consumer<DreamProvider>(
    builder: (context, dreamProvider, child) {
      final dream = dreamProvider.allDreams
          .where((d) => d.id == manifest.dreamId)
          .firstOrNull;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _showManifestDetail(context, manifest, dream),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          manifest.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: manifest.isCompleted
                              ? Colors.green.withValues(alpha: 0.1)
                              : AppTheme.primaryPurple.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          manifest.isCompleted
                              ? 'Complete'
                              : '${(manifest.progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: manifest.isCompleted
                                ? Colors.green
                                : AppTheme.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: manifest.progress,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        manifest.isCompleted
                            ? Colors.green
                            : AppTheme.primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Show different info based on mode
                  if (manifest.isNumericMode)
                    Text(
                      '${manifest.goalValues['current']?.toStringAsFixed(0) ?? '0'} / ${manifest.goalValues['max']?.toStringAsFixed(0) ?? '0'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary.withValues(alpha: 0.8),
                      ),
                    )
                  else if (manifest.isChecklistMode)
                    Text(
                      '${manifest.checklist.where((item) => item.isCompleted).length}/${manifest.checklist.length} tasks completed',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary.withValues(alpha: 0.8),
                      ),
                    )
                  else
                    Text(
                      'Tap to add tracking goals',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.primaryPurple.withValues(alpha: 0.8),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

  void showAddManifestDialog(BuildContext context) {
    final manifestProvider =
        Provider.of<ManifestProvider>(context, listen: false);

    // Find manifests that don't have goals yet (empty checklist and no goalValues)
    final manifestsWithoutGoals = manifestProvider.activeManifests
        .where((manifest) =>
            manifest.checklist.isEmpty && manifest.goalValues.isEmpty)
        .toList();

    if (manifestsWithoutGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All manifests have goals! Manifest a dream first.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    ManifestItem? selectedManifest = manifestsWithoutGoals.first;
    String trackingMode = 'checklist'; // 'checklist' or 'numeric'
    final checklistControllers = <TextEditingController>[
      TextEditingController()
    ];
    final goalController = TextEditingController();
    final currentController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Start Tracking Progress'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select manifest:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ManifestItem>(
                  initialValue: selectedManifest,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: manifestsWithoutGoals.map((manifest) {
                    return DropdownMenuItem<ManifestItem>(
                      value: manifest,
                      child: Text(manifest.title),
                    );
                  }).toList(),
                  onChanged: (ManifestItem? newValue) {
                    setDialogState(() {
                      selectedManifest = newValue;
                    });
                  },
                ),
              const SizedBox(height: 24),
              const Text(
                'Tracking method:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(
                    value: 'checklist',
                    label: Text('Checklist'),
                    icon: Icon(Icons.checklist, size: 18),
                  ),
                  ButtonSegment<String>(
                    value: 'numeric',
                    label: Text('Numeric'),
                    icon: Icon(Icons.numbers, size: 18),
                  ),
                ],
                selected: {trackingMode},
                onSelectionChanged: (Set<String> newSelection) {
                  setDialogState(() {
                    trackingMode = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 24),
              if (trackingMode == 'checklist') ...[
                const Text(
                  'Create checklist:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...List.generate(checklistControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: checklistControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Task ${index + 1}',
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        if (checklistControllers.length > 1)
                          IconButton(
                            onPressed: () {
                              setDialogState(() {
                                checklistControllers[index].dispose();
                                checklistControllers.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                            color: Colors.red,
                          ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () {
                    setDialogState(() {
                      checklistControllers.add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add task'),
                ),
              ] else ...[
                const Text(
                  'Set numeric goal:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: currentController,
                        decoration: InputDecoration(
                          labelText: 'Current',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '/',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: goalController,
                        decoration: InputDecoration(
                          labelText: 'Goal',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'e.g., "5 / 10 chapters read"',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              for (var controller in checklistControllers) {
                controller.dispose();
              }
              goalController.dispose();
              currentController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (trackingMode == 'checklist') {
                // Validate checklist
                final tasks = checklistControllers
                    .map((c) => c.text.trim())
                    .where((text) => text.isNotEmpty)
                    .toList();

                if (tasks.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add at least one task!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Update the selected manifest with checklist
                selectedManifest!.checklist = tasks
                    .map((task) => ChecklistItem(title: task))
                    .toList();
                selectedManifest!.save();

                Provider.of<ManifestProvider>(context, listen: false)
                    .updateManifest(selectedManifest!);
              } else {
                // Validate numeric goal
                final goalText = goalController.text.trim();
                final currentText = currentController.text.trim();

                if (goalText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a goal value!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                final goal = double.tryParse(goalText);
                final current = double.tryParse(currentText) ?? 0;

                if (goal == null || goal <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Please enter a valid positive number for goal!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                // Update the selected manifest with numeric goals
                selectedManifest!.goalValues = {
                  'current': current,
                  'max': goal,
                };
                selectedManifest!.save();

                Provider.of<ManifestProvider>(context, listen: false)
                    .updateManifest(selectedManifest!);
              }

              for (var controller in checklistControllers) {
                controller.dispose();
              }
              goalController.dispose();
              currentController.dispose();

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Started tracking progress!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryPurple,
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    ),
  );
}

void _showManifestDetail(
  BuildContext context,
  ManifestItem manifest,
  Dream? dream,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ManifestDetailSheet(manifest: manifest, dream: dream),
  );
}

class ManifestDetailSheet extends StatefulWidget {
  final ManifestItem manifest;
  final Dream? dream;

  const ManifestDetailSheet({
    super.key,
    required this.manifest,
    required this.dream,
  });

  @override
  State<ManifestDetailSheet> createState() => _ManifestDetailSheetState();
}

class _ManifestDetailSheetState extends State<ManifestDetailSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.manifest.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: widget.manifest.progress,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.manifest.isCompleted
                          ? Colors.green
                          : AppTheme.primaryPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(widget.manifest.progress * 100).toInt()}% Complete',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Content based on mode
          Expanded(
            child: !widget.manifest.isNumericMode &&
                    !widget.manifest.isChecklistMode
                ? _buildNoGoalsPrompt()
                : widget.manifest.isNumericMode
                    ? _buildNumericProgress()
                    : _buildChecklistProgress(),
          ),
          // Actions
          if (!widget.manifest.isCompleted)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  if (widget.manifest.isChecklistMode ||
                      widget.manifest.isNumericMode)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showEditGoalsDialog(context),
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit Goals'),
                      ),
                    ),
                  if (widget.manifest.isChecklistMode ||
                      widget.manifest.isNumericMode)
                    const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Manifest'),
                            content: const Text(
                              'Are you sure you want to delete this manifest?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  final manifestProvider =
                                      Provider.of<ManifestProvider>(
                                    context,
                                    listen: false,
                                  );
                                  manifestProvider
                                      .deleteManifest(widget.manifest.id);
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pop(context); // Close detail sheet
                                  
                                  // Show action feedback
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder:
                                          (context, animation, secondaryAnimation) =>
                                              ActionFeedbackScreen(
                                        actionType: ActionType.deleted,
                                      ),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration:
                                          const Duration(milliseconds: 300),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            )
          else
            // Completed manifest - show move to memories button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Mark dream as completed
                        if (widget.dream != null) {
                          widget.dream!.markAsCompleted();
                          Provider.of<DreamProvider>(
                            context,
                            listen: false,
                          ).updateDream(widget.dream!);
                        }

                        // Close detail sheet
                        Navigator.pop(context);

                        // Show feedback
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    ActionFeedbackScreen(
                                      actionType: ActionType.completed,
                                    ),
                            opaque: false,
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                          ),
                        );

                        // Delete manifest after moving to memories
                        Provider.of<ManifestProvider>(
                          context,
                          listen: false,
                        ).deleteManifest(widget.manifest.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade500,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.favorite),
                      label: const Text(
                        'Move to Memories',
                        style: TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildChecklistProgress() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: widget.manifest.checklist.length,
      itemBuilder: (context, index) {
        final item = widget.manifest.checklist[index];
        return CheckboxListTile(
          value: item.isCompleted,
          onChanged: widget.manifest.isCompleted
              ? null
              : (bool? value) {
                  setState(() {
                    item.toggle();
                    widget.manifest.save();

                    // Check if all items are completed
                    if (widget.manifest.progress == 1.0 &&
                        !widget.manifest.isCompleted) {
                      widget.manifest.markAsCompleted();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🎉 Manifest completed!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }

                    Provider.of<ManifestProvider>(
                      context,
                      listen: false,
                    ).updateManifest(widget.manifest);
                  });
                },
          title: Text(
            item.title,
            style: TextStyle(
              decoration: item.isCompleted ? TextDecoration.lineThrough : null,
              color: item.isCompleted
                  ? AppTheme.textSecondary.withValues(alpha: 0.6)
                  : AppTheme.textPrimary,
            ),
          ),
          activeColor: AppTheme.primaryPurple,
        );
      },
    );
  }

  Widget _buildNumericProgress() {
    final current = widget.manifest.goalValues['current'] ?? 0;
    final max = widget.manifest.goalValues['max'] ?? 1;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text(
            current.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryPurple,
            ),
          ),
          Text(
            '/ ${max.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 32, color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 40),
          if (!widget.manifest.isCompleted) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: () {
                    setState(() {
                      final newCurrent = (current - 1).clamp(0.0, max);
                      widget.manifest.updateNumericProgress(newCurrent);
                      Provider.of<ManifestProvider>(
                        context,
                        listen: false,
                      ).updateManifest(widget.manifest);
                    });
                  },
                  icon: const Icon(Icons.remove),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  onPressed: () {
                    setState(() {
                      final newCurrent = (current + 1).clamp(0.0, max);
                      widget.manifest.updateNumericProgress(newCurrent);

                      // Check if goal is reached
                      if (newCurrent >= max && !widget.manifest.isCompleted) {
                        widget.manifest.markAsCompleted();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🎉 Goal reached!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }

                      Provider.of<ManifestProvider>(
                        context,
                        listen: false,
                      ).updateManifest(widget.manifest);
                    });
                  },
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.primaryPurple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {
                final controller = TextEditingController(
                  text: current.toStringAsFixed(0),
                );
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Update Progress'),
                    content: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        labelText: 'Current value',
                      ),
                      keyboardType: TextInputType.number,
                      autofocus: true,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          final newValue = double.tryParse(controller.text);
                          if (newValue != null) {
                            setState(() {
                              widget.manifest.updateNumericProgress(
                                newValue.clamp(0.0, max),
                              );

                              if (newValue >= max &&
                                  !widget.manifest.isCompleted) {
                                widget.manifest.markAsCompleted();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🎉 Goal reached!'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }

                              Provider.of<ManifestProvider>(
                                context,
                                listen: false,
                              ).updateManifest(widget.manifest);
                            });
                          }
                          Navigator.pop(context);
                        },
                        child: const Text('Update'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Enter custom value'),
            ),
          ],
        ],
      ),
      ),
    );
  }

  Widget _buildNoGoalsPrompt() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.primaryPurple.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_task,
              size: 50,
              color: AppTheme.primaryPurple,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No tracking goals yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Click "Start Tracking" to add goals\nfor this manifest',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditGoalsDialog(BuildContext context) {
    if (widget.manifest.isChecklistMode) {
      _showEditChecklistDialog(context);
    } else if (widget.manifest.isNumericMode) {
      _showEditNumericDialog(context);
    }
  }

  void _showEditChecklistDialog(BuildContext context) {
    final checklistControllers = widget.manifest.checklist
        .map((item) => TextEditingController(text: item.title))
        .toList();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Checklist'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(checklistControllers.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: checklistControllers[index],
                            decoration: InputDecoration(
                              hintText: 'Task ${index + 1}',
                              filled: true,
                              fillColor: Colors.grey.shade100,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setDialogState(() {
                              checklistControllers[index].dispose();
                              checklistControllers.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () {
                    setDialogState(() {
                      checklistControllers.add(TextEditingController());
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add task'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                for (var controller in checklistControllers) {
                  controller.dispose();
                }
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final tasks = checklistControllers
                    .map((c) => c.text.trim())
                    .where((text) => text.isNotEmpty)
                    .toList();

                if (tasks.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please add at least one task!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                }

                setState(() {
                  // Preserve completion status where possible
                  final newChecklist = <ChecklistItem>[];
                  for (int i = 0; i < tasks.length; i++) {
                    if (i < widget.manifest.checklist.length) {
                      // Update existing item
                      widget.manifest.checklist[i].title = tasks[i];
                      newChecklist.add(widget.manifest.checklist[i]);
                    } else {
                      // Add new item
                      newChecklist.add(ChecklistItem(title: tasks[i]));
                    }
                  }
                  widget.manifest.checklist = newChecklist;
                  widget.manifest.save();
                  Provider.of<ManifestProvider>(context, listen: false)
                      .updateManifest(widget.manifest);
                });

                for (var controller in checklistControllers) {
                  controller.dispose();
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditNumericDialog(BuildContext context) {
    final currentController = TextEditingController(
      text: widget.manifest.goalValues['current']?.toStringAsFixed(0) ?? '0',
    );
    final goalController = TextEditingController(
      text: widget.manifest.goalValues['max']?.toStringAsFixed(0) ?? '0',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Numeric Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              decoration: const InputDecoration(
                labelText: 'Current value',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: goalController,
              decoration: const InputDecoration(
                labelText: 'Goal value',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              currentController.dispose();
              goalController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final current = double.tryParse(currentController.text) ?? 0;
              final goal = double.tryParse(goalController.text);

              if (goal == null || goal <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid positive goal!'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              setState(() {
                widget.manifest.goalValues = {
                  'current': current,
                  'max': goal,
                };
                widget.manifest.save();
                
                if (current >= goal && !widget.manifest.isCompleted) {
                  widget.manifest.markAsCompleted();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 Goal reached!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                
                Provider.of<ManifestProvider>(context, listen: false)
                    .updateManifest(widget.manifest);
              });

              currentController.dispose();
              goalController.dispose();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
