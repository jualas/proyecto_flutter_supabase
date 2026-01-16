import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/models.dart';
import '../taskboard_data_source.dart';

class SupabaseDataSource implements TaskboardDataSource {
  final SupabaseClient _client;

  SupabaseDataSource(this._client);

  static const String _projectsTable = 'projects';
  static const String _tasksTable = 'tasks';

  Project _projectFromRow(Map<String, dynamic> row) {
    final statusValue = (row['status'] as String?) ?? ProjectStatus.planning.dbValue;
    final status = ProjectStatus.values.firstWhere(
      (s) => s.dbValue == statusValue,
      orElse: () => ProjectStatus.planning,
    );

    return Project(
      id: (row['id'] as num).toInt(),
      title: (row['title'] as String?) ?? '',
      description: (row['description'] as String?) ?? '',
      status: status,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, dynamic> _projectToRow(Project project) {
    return {
      'id': project.id,
      'title': project.title,
      'description': project.description,
      'status': project.status.dbValue,
      'created_at': project.createdAt.toIso8601String(),
      'updated_at': project.updatedAt.toIso8601String(),
    };
  }

  Task _taskFromRow(Map<String, dynamic> row) {
    final statusValue = (row['status'] as String?) ?? TaskStatus.pending.dbValue;
    final status = TaskStatus.values.firstWhere(
      (s) => s.dbValue == statusValue,
      orElse: () => TaskStatus.pending,
    );

    final complexityValue =
        (row['complexity'] as String?) ?? TaskComplexity.simple.dbValue;
    final complexity = TaskComplexity.values.firstWhere(
      (c) => c.dbValue == complexityValue,
      orElse: () => TaskComplexity.simple,
    );

    final tagsRaw = row['tags'];
    final tags = (tagsRaw is List)
        ? tagsRaw.map((e) => e.toString()).toList()
        : <String>[];

    final subtasksRaw = row['subtasks'];
    final subtasks = (subtasksRaw is List)
        ? subtasksRaw
            .whereType<Map>()
            .map((e) => Subtask.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <Subtask>[];

    final dueDateRaw = row['due_date'];

    return Task(
      id: (row['id'] as num).toInt(),
      projectId: (row['project_id'] as num).toInt(),
      title: (row['title'] as String?) ?? '',
      description: (row['description'] as String?) ?? '',
      status: status,
      dueDate: dueDateRaw == null ? null : DateTime.parse(dueDateRaw as String),
      kanbanPosition: (row['kanban_position'] as num?)?.toDouble() ?? 1.0,
      estimatedHours: (row['estimated_hours'] as num?)?.toInt(),
      complexity: complexity,
      tags: tags,
      subtasks: subtasks,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, dynamic> _taskToRow(Task task) {
    return {
      'id': task.id,
      'project_id': task.projectId,
      'title': task.title,
      'description': task.description,
      'status': task.status.dbValue,
      'due_date': task.dueDate?.toIso8601String(),
      'kanban_position': task.kanbanPosition,
      'estimated_hours': task.estimatedHours,
      'complexity': task.complexity.dbValue,
      'tags': task.tags,
      'subtasks': task.subtasks.map((s) => s.toJson()).toList(),
      'created_at': task.createdAt.toIso8601String(),
      'updated_at': task.updatedAt.toIso8601String(),
    };
  }

  @override
  Future<List<Project>> getProjects() async {
    final res = await _client.from(_projectsTable).select().order('id');
    return (res as List)
        .whereType<Map>()
        .map((e) => _projectFromRow(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<Project?> getProject(int id) async {
    final res = await _client
        .from(_projectsTable)
        .select()
        .eq('id', id)
        .maybeSingle();
    if (res == null) return null;
    return _projectFromRow(Map<String, dynamic>.from(res));
  }

  @override
  Future<Project> saveProject(Project project) async {
    final res = await _client
        .from(_projectsTable)
        .upsert(_projectToRow(project), onConflict: 'id')
        .select()
        .maybeSingle();
    if (res == null) {
      throw Exception('No se pudo guardar el proyecto');
    }
    return _projectFromRow(Map<String, dynamic>.from(res));
  }

  @override
  Future<void> deleteProject(int id) async {
    await _client.from(_projectsTable).delete().eq('id', id);
  }

  @override
  Future<int> getNextProjectId() async {
    final res = await _client
        .from(_projectsTable)
        .select('id')
        .order('id', ascending: false)
        .limit(1)
        .maybeSingle();
    if (res == null) return 1;
    return ((res['id'] as num).toInt()) + 1;
  }

  @override
  Future<List<Task>> getTasks() async {
    final res = await _client.from(_tasksTable).select().order('id');
    return (res as List)
        .whereType<Map>()
        .map((e) => _taskFromRow(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<List<Task>> getTasksByProject(int projectId) async {
    final res = await _client
        .from(_tasksTable)
        .select()
        .eq('project_id', projectId)
        .order('kanban_position');
    return (res as List)
        .whereType<Map>()
        .map((e) => _taskFromRow(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<Task?> getTask(int id) async {
    final res =
        await _client.from(_tasksTable).select().eq('id', id).maybeSingle();
    if (res == null) return null;
    return _taskFromRow(Map<String, dynamic>.from(res));
  }

  @override
  Future<Task> saveTask(Task task) async {
    final res = await _client
        .from(_tasksTable)
        .upsert(_taskToRow(task), onConflict: 'id')
        .select()
        .maybeSingle();
    if (res == null) {
      throw Exception('No se pudo guardar la tarea');
    }
    return _taskFromRow(Map<String, dynamic>.from(res));
  }

  @override
  Future<void> deleteTask(int id) async {
    await _client.from(_tasksTable).delete().eq('id', id);
  }

  @override
  Future<int> getNextTaskId() async {
    final res = await _client
        .from(_tasksTable)
        .select('id')
        .order('id', ascending: false)
        .limit(1)
        .maybeSingle();
    if (res == null) return 1;
    return ((res['id'] as num).toInt()) + 1;
  }
}

