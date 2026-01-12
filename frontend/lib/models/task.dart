import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

/// Modelo que representa una tarea en el sistema de gestión personal.
@JsonSerializable()
class Task {
  final int id;
  @JsonKey(name: 'projectId')
  final int projectId;
  final String title;
  final String description;
  final TaskStatus status;
  @JsonKey(name: 'dueDate')
  final DateTime? dueDate;
  @JsonKey(name: 'kanbanPosition')
  final double kanbanPosition;
  @JsonKey(name: 'estimatedHours')
  final int? estimatedHours;
  final TaskComplexity complexity;
  final List<String> tags;
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.projectId,
    required this.title,
    required this.description,
    required this.status,
    this.dueDate,
    required this.kanbanPosition,
    this.estimatedHours,
    required this.complexity,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  Task copyWith({
    int? id,
    int? projectId,
    String? title,
    String? description,
    TaskStatus? status,
    DateTime? dueDate,
    double? kanbanPosition,
    int? estimatedHours,
    TaskComplexity? complexity,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      dueDate: dueDate ?? this.dueDate,
      kanbanPosition: kanbanPosition ?? this.kanbanPosition,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      complexity: complexity ?? this.complexity,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Crea una nueva tarea con valores por defecto
  factory Task.create({
    required int id,
    required int projectId,
    required String title,
    String description = '',
    TaskStatus status = TaskStatus.pending,
    DateTime? dueDate,
    double kanbanPosition = 1.0,
    int? estimatedHours,
    TaskComplexity complexity = TaskComplexity.simple,
    List<String> tags = const [],
  }) {
    final now = DateTime.now();
    return Task(
      id: id,
      projectId: projectId,
      title: title,
      description: description,
      status: status,
      dueDate: dueDate,
      kanbanPosition: kanbanPosition,
      estimatedHours: estimatedHours,
      complexity: complexity,
      tags: tags,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, status: $status, projectId: $projectId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Estados posibles de una tarea en el flujo de trabajo.
enum TaskStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
}

/// Niveles de complejidad de una tarea.
enum TaskComplexity {
  @JsonValue('simple')
  simple,
  @JsonValue('medium')
  medium,
  @JsonValue('complex')
  complex,
}

extension TaskStatusExtension on TaskStatus {
  bool get isCompleted => this == TaskStatus.completed;
  bool get isInProgress => this == TaskStatus.inProgress;
  bool get isPending => this == TaskStatus.pending;

  String get dbValue {
    switch (this) {
      case TaskStatus.pending:
        return 'pending';
      case TaskStatus.inProgress:
        return 'in_progress';
      case TaskStatus.completed:
        return 'completed';
    }
  }

  String get displayName {
    switch (this) {
      case TaskStatus.pending:
        return 'Pendiente';
      case TaskStatus.inProgress:
        return 'En Progreso';
      case TaskStatus.completed:
        return 'Completada';
    }
  }
}

extension TaskComplexityExtension on TaskComplexity {
  String get dbValue {
    switch (this) {
      case TaskComplexity.simple:
        return 'simple';
      case TaskComplexity.medium:
        return 'medium';
      case TaskComplexity.complex:
        return 'complex';
    }
  }

  String get displayName {
    switch (this) {
      case TaskComplexity.simple:
        return 'Simple';
      case TaskComplexity.medium:
        return 'Media';
      case TaskComplexity.complex:
        return 'Compleja';
    }
  }

  int get estimatedHours {
    switch (this) {
      case TaskComplexity.simple:
        return 2;
      case TaskComplexity.medium:
        return 8;
      case TaskComplexity.complex:
        return 24;
    }
  }
}
