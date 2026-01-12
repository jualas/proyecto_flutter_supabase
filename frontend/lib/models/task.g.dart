// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: (json['id'] as num).toInt(),
      projectId: (json['projectId'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      kanbanPosition: (json['kanbanPosition'] as num).toDouble(),
      estimatedHours: (json['estimatedHours'] as num?)?.toInt(),
      complexity: $enumDecode(_$TaskComplexityEnumMap, json['complexity']),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'title': instance.title,
      'description': instance.description,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'dueDate': instance.dueDate?.toIso8601String(),
      'kanbanPosition': instance.kanbanPosition,
      'estimatedHours': instance.estimatedHours,
      'complexity': _$TaskComplexityEnumMap[instance.complexity]!,
      'tags': instance.tags,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'in_progress',
  TaskStatus.completed: 'completed',
};

const _$TaskComplexityEnumMap = {
  TaskComplexity.simple: 'simple',
  TaskComplexity.medium: 'medium',
  TaskComplexity.complex: 'complex',
};

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () => throw ArgumentError(
      '`$source` is not one of the supported values: '
      '${enumValues.values.join(', ')}',
    ),
  ).key;
}
