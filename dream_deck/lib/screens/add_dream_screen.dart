import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../providers/dream_provider.dart';
import '../models/dream.dart';
import '../models/dream_category.dart';
import '../theme/app_theme.dart';

class AddDreamScreen extends StatefulWidget {
  const AddDreamScreen({super.key});

  @override
  State<AddDreamScreen> createState() => _AddDreamScreenState();
}

class _AddDreamScreenState extends State<AddDreamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _firstStepController = TextEditingController();
  DreamCategory _selectedCategory = DreamCategory.quickWin;

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _firstStepController.dispose();
    super.dispose();
  }

  void _saveDream() async {
    if (_formKey.currentState!.validate()) {
      final uuid = const Uuid();
      final dream = Dream(
        id: uuid.v4(),
        title: _titleController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        firstStep: _firstStepController.text.trim().isEmpty
            ? null
            : _firstStepController.text.trim(),
        categoryIndex: _selectedCategory.index,
        createdAt: DateTime.now(),
      );

      await Provider.of<DreamProvider>(context, listen: false).addDream(dream);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✨ Idea captured!'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Capture an Idea',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                const Text(
                  'What\'s your idea? *',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Learn to play guitar',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your idea';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),

                // Notes field
                const Text(
                  'Any notes? (optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    hintText: 'Extra context, inspiration, links...',
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),

                // First step field
                const Text(
                  'First small step (optional)',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Makes it easier to start when you\'re tired!',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary.withValues(alpha: 0.8),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _firstStepController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Watch a 10-min tutorial',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 24),

                // Category selection
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: DreamCategory.values.map((category) {
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? category.color
                              : category.color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? category.color
                                : category.color.withValues(alpha: 0.3),
                            width: 2,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              category.emoji,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              category.displayName,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : category.color,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 32),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveDream,
                    icon: const Icon(Icons.auto_awesome, size: 24),
                    label: const Text(
                      'Capture Idea!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
