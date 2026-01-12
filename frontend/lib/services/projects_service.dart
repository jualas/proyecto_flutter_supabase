import '../models/models.dart';
import 'storage_service.dart';

/// Servicio para la gestión de proyectos.
class ProjectsService {
  final StorageService _storageService;

  ProjectsService(this._storageService);

  /// Obtiene todos los proyectos
  Future<List<Project>> getProjects() async {
    return await _storageService.getProjects();
  }

  /// Obtiene un proyecto por ID
  Future<Project?> getProject(int id) async {
    return await _storageService.getProject(id);
  }

  /// Crea un nuevo proyecto
  Future<Project> createProject({
    required String title,
    String description = '',
    ProjectStatus status = ProjectStatus.planning,
  }) async {
    final id = await _storageService.getNextProjectId();
    final project = Project.create(
      id: id,
      title: title,
      description: description,
      status: status,
    );
    return await _storageService.saveProject(project);
  }

  /// Actualiza un proyecto existente
  Future<Project> updateProject(Project project) async {
    return await _storageService.saveProject(project);
  }

  /// Elimina un proyecto y todas sus tareas
  Future<void> deleteProject(int id) async {
    await _storageService.deleteProject(id);
  }

  /// Cambia el estado de un proyecto
  Future<Project> updateProjectStatus(int id, ProjectStatus status) async {
    final project = await _storageService.getProject(id);
    if (project == null) {
      throw Exception('Proyecto no encontrado');
    }
    
    final updatedProject = project.copyWith(
      status: status,
      updatedAt: DateTime.now(),
    );
    return await _storageService.saveProject(updatedProject);
  }

  /// Obtiene estadísticas de un proyecto
  Future<ProjectStats> getProjectStats(int projectId) async {
    final tasks = await _storageService.getTasksByProject(projectId);
    
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
