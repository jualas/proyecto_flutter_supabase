import '../models/models.dart';

/// Contrato de persistencia para la app (local o remoto).
abstract class TaskboardDataSource {
  Future<List<Project>> getProjects();
  Future<Project?> getProject(int id);
  Future<Project> saveProject(Project project);
  Future<void> deleteProject(int id);
  Future<int> getNextProjectId();

  Future<List<Task>> getTasks();
  Future<List<Task>> getTasksByProject(int projectId);
  Future<Task?> getTask(int id);
  Future<Task> saveTask(Task task);
  Future<void> deleteTask(int id);
  Future<int> getNextTaskId();
}

