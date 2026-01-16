import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../themes/app_theme.dart';

class TaskForm extends StatefulWidget {
  final int projectId;
  final Task? task;
  final void Function(Task task) onSave;

  const TaskForm({
    super.key,
    required this.projectId,
    this.task,
    required this.onSave,
  });

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedHoursController;
  late TextEditingController _tagsController;
  
  TaskStatus _status = TaskStatus.pending;
  TaskComplexity _complexity = TaskComplexity.simple;
  DateTime? _dueDate;
  late List<Subtask> _subtasks;

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _estimatedHoursController = TextEditingController(
      text: widget.task?.estimatedHours?.toString() ?? '',
    );
    _tagsController = TextEditingController(
      text: widget.task?.tags.join(', ') ?? '',
    );
    _subtasks = List<Subtask>.from(widget.task?.subtasks ?? const []);
    
    if (widget.task != null) {
      _status = widget.task!.status;
      _complexity = widget.task!.complexity;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedHoursController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      final tags = _tagsController.text
          .split(',')
          .map((t) => t.trim())
          .where((t) => t.isNotEmpty)
          .toList();
      
      final estimatedHours = _estimatedHoursController.text.isNotEmpty
          ? int.tryParse(_estimatedHoursController.text)
          : null;

      final now = DateTime.now();
      
      final task = Task(
        id: widget.task?.id ?? 0, // Se asignará el ID real en el servicio
        projectId: widget.projectId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        status: _status,
        dueDate: _dueDate,
        kanbanPosition: widget.task?.kanbanPosition ?? 1.0,
        estimatedHours: estimatedHours,
        complexity: _complexity,
        tags: tags,
        subtasks: _subtasks,
        createdAt: widget.task?.createdAt ?? now,
        updatedAt: now,
      );

      widget.onSave(task);
    }
  }

  int _nextSubtaskId() {
    if (_subtasks.isEmpty) return 1;
    final maxId = _subtasks.map((s) => s.id).reduce(max);
    return maxId + 1;
  }

  Future<String?> _promptSubtaskTitle({
    required String dialogTitle,
    String initialValue = '',
  }) async {
    final controller = TextEditingController(text: initialValue);
    String? result;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(dialogTitle),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Título',
            hintText: 'Ej: Preparar endpoint / crear tabla',
          ),
          onSubmitted: (_) => Navigator.of(dialogContext).pop(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );

    final title = controller.text.trim();
    if (title.isEmpty) return null;
    result = title;
    return result;
  }

  Future<void> _addSubtask() async {
    final title = await _promptSubtaskTitle(dialogTitle: 'Nueva subtarea');
    if (title == null) return;

    setState(() {
      _subtasks = [
        ..._subtasks,
        Subtask(id: _nextSubtaskId(), title: title, isDone: false),
      ];
    });
  }

  Future<void> _editSubtask(Subtask subtask) async {
    final title = await _promptSubtaskTitle(
      dialogTitle: 'Editar subtarea',
      initialValue: subtask.title,
    );
    if (title == null) return;

    setState(() {
      _subtasks = _subtasks
          .map((s) => s.id == subtask.id ? s.copyWith(title: title) : s)
          .toList();
    });
  }

  void _toggleSubtask(Subtask subtask, bool isDone) {
    setState(() {
      _subtasks = _subtasks
          .map((s) => s.id == subtask.id ? s.copyWith(isDone: isDone) : s)
          .toList();
    });
  }

  void _deleteSubtask(Subtask subtask) {
    setState(() {
      _subtasks = _subtasks.where((s) => s.id != subtask.id).toList();
    });
  }

  Widget _buildChecklistSection() {
    final done = _subtasks.where((s) => s.isDone).length;
    final total = _subtasks.length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.checklist, color: AppColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  total > 0 ? 'Checklist ($done/$total)' : 'Checklist',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: 'Añadir subtarea',
                onPressed: _addSubtask,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_subtasks.isEmpty)
            Text(
              'Añade subtareas para poder marcarlas con un check.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            )
          else
            ..._subtasks.map((subtask) {
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.textSecondary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: subtask.isDone,
                      onChanged: (value) => _toggleSubtask(subtask, value ?? false),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        subtask.title,
                        style: TextStyle(
                          decoration: subtask.isDone ? TextDecoration.lineThrough : null,
                          color: subtask.isDone ? AppColors.textSecondary : AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Editar',
                      onPressed: () => _editSubtask(subtask),
                      icon: const Icon(Icons.edit, size: 18),
                    ),
                    IconButton(
                      tooltip: 'Eliminar',
                      onPressed: () => _deleteSubtask(subtask),
                      icon: const Icon(Icons.delete, size: 18, color: AppColors.error),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.accentPrimary,
              onPrimary: AppColors.textOnDark,
              surface: AppColors.backgroundPrimary,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título del formulario
              Text(
                _isEditing ? 'Editar Tarea' : 'Nueva Tarea',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Campo Título
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título *',
                  hintText: 'Nombre de la tarea',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es requerido';
                  }
                  return null;
                },
                autofocus: !_isEditing,
              ),
              const SizedBox(height: 16),
              
              // Campo Descripción
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  hintText: 'Descripción detallada de la tarea',
                  prefixIcon: Icon(Icons.description),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              
              // Estado y Complejidad en fila
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<TaskStatus>(
                      value: _status,
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        prefixIcon: Icon(Icons.flag),
                      ),
                      items: TaskStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.displayName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<TaskComplexity>(
                      value: _complexity,
                      decoration: const InputDecoration(
                        labelText: 'Complejidad',
                        prefixIcon: Icon(Icons.speed),
                      ),
                      items: TaskComplexity.values.map((complexity) {
                        return DropdownMenuItem(
                          value: complexity,
                          child: Text(complexity.displayName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _complexity = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Horas estimadas y Fecha límite en fila
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _estimatedHoursController,
                      decoration: const InputDecoration(
                        labelText: 'Horas estimadas',
                        hintText: 'Ej: 8',
                        prefixIcon: Icon(Icons.schedule),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final hours = int.tryParse(value);
                          if (hours == null || hours < 0) {
                            return 'Número inválido';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Fecha límite',
                          prefixIcon: const Icon(Icons.event),
                          suffixIcon: _dueDate != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() => _dueDate = null);
                                  },
                                )
                              : null,
                        ),
                        child: Text(
                          _dueDate != null
                              ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                              : 'Sin fecha',
                          style: TextStyle(
                            color: _dueDate != null
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Campo Tags
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Etiquetas',
                  hintText: 'frontend, urgente, bug (separadas por coma)',
                  prefixIcon: Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 24),

              // Checklist / Subtareas
              _buildChecklistSection(),
              const SizedBox(height: 24),
              
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _handleSave,
                    child: Text(_isEditing ? 'Guardar' : 'Crear'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
