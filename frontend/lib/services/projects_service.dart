import '../models/models.dart';
import 'taskboard_data_source.dart';

/// Servicio para la gestión de proyectos.
class ProjectsService {
  final TaskboardDataSource _dataSource;

  ProjectsService(this._dataSource);

  /// Obtiene todos los proyectos
  Future<List<Project>> getProjects() async {
    return await _dataSource.getProjects();
  }

  /// Obtiene un proyecto por ID
  Future<Project?> getProject(int id) async {
    return await _dataSource.getProject(id);
  }

  /// Crea un nuevo proyecto
  Future<Project> createProject({
    required String title,
    String description = '',
    ProjectStatus status = ProjectStatus.planning,
  }) async {
    final id = await _dataSource.getNextProjectId();
    final project = Project.create(
      id: id,
      title: title,
      description: description,
      status: status,
    );
    return await _dataSource.saveProject(project);
  }

  /// Actualiza un proyecto existente
  Future<Project> updateProject(Project project) async {
    return await _dataSource.saveProject(project);
  }

  /// Elimina un proyecto y todas sus tareas
  Future<void> deleteProject(int id) async {
    await _dataSource.deleteProject(id);
  }

  /// Cambia el estado de un proyecto
  Future<Project> updateProjectStatus(int id, ProjectStatus status) async {
    final project = await _dataSource.getProject(id);
    if (project == null) {
      throw Exception('Proyecto no encontrado');
    }
    
    final updatedProject = project.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    return await _dataSource.saveProject(updatedProject);
  }

  /// Obtiene estadísticas de un proyecto
  Future<ProjectStats> getProjectStats(int projectId) async {
    final tasks = await _dataSource.getTasksByProject(projectId);
    
    final totalTasks = tasks.length;
    final completedTasks = tasks.where((t) => t.status == TaskStatus.completed).length;
    final inProgressTasks = tasks.where((t) => t.status == TaskStatus.inProgress).length;
    final pendingTasks = tasks.where((t) => t.status == TaskStatus.pending).length;
    
    final totalEstimatedHours = tasks
        .where((t) => t.estimatedHours != null)
        .fold<int>(0, (sum, t) => sum + t.estimatedHours!);
    
    return ProjectStats(
      totalTasks: totalTasks,
      completedTasks: completedTasks,
      inProgressTasks: inProgressTasks,
      pendingTasks: pendingTasks,
      totalEstimatedHours: totalEstimatedHours,
      completionPercentage: totalTasks > 0 
          ? (completedTasks / totalTasks * 100).round() 
          : 0,
    );
  }
}

/// Estadísticas de un proyecto
class ProjectStats {
  final int totalTasks;
  final int completedTasks;
  final int inProgressTasks;
  final int pendingTasks;
  final int totalEstimatedHours;
  final int completionPercentage;

  const ProjectStats({
    required this.totalTasks,
    required this.completedTasks,
    required this.inProgressTasks,
    required this.pendingTasks,
    required this.totalEstimatedHours,
    required this.completionPercentage,
  });
}
