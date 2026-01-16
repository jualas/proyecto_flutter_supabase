import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';
import 'taskboard_data_source.dart';

/// Servicio para la gestión del almacenamiento de datos en JSON.
/// 
/// Utiliza SharedPreferences para persistir los datos localmente,
/// con datos iniciales cargados desde assets.
class StorageService implements TaskboardDataSource {
  static const String _dataKey = 'app_data';
  
  SharedPreferences? _prefs;
  AppData? _cachedData;

  /// Inicializa el servicio de almacenamiento
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadInitialData();
  }

  /// Carga los datos iniciales si no existen
  Future<void> _loadInitialData() async {
    // Cargar datos (solo si no existen)
    if (!_prefs!.containsKey(_dataKey)) {
      final dataJson = await rootBundle.loadString('assets/data/data.json');
      await _prefs!.setString(_dataKey, dataJson);
    }
  }

  /// Obtiene la configuración de la aplicación
  /// Siempre lee directamente del archivo (sin caché)
  Future<AppConfig> getConfig() async {
    final configJson = await rootBundle.loadString('assets/data/config.json');
    final json = jsonDecode(configJson) as Map<String, dynamic>;
    return AppConfig.fromJson(json);
  }

  /// Obtiene todos los datos de la aplicación
  Future<AppData> getData() async {
    if (_cachedData != null) return _cachedData!;
    
    final jsonStr = _prefs!.getString(_dataKey);
    if (jsonStr == null) {
      return AppData.empty();
    }
    
    final json = jsonDecode(jsonStr) as Map<String, dynamic>;
    _cachedData = AppData.fromJson(json);
    return _cachedData!;
  }

  /// Guarda los datos de la aplicación
  Future<void> saveData(AppData data) async {
    final jsonStr = jsonEncode(data.toJson());
    await _prefs!.setString(_dataKey, jsonStr);
    _cachedData = data;
  }

  /// Obtiene todos los proyectos
  Future<List<Project>> getProjects() async {
    final data = await getData();
    return data.projects;
  }

  /// Obtiene un proyecto por ID
  Future<Project?> getProject(int id) async {
    final projects = await getProjects();
    try {
      return projects.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Guarda un proyecto (crear o actualizar)
  Future<Project> saveProject(Project project) async {
    final data = await getData();
    final projects = List<Project>.from(data.projects);
    
    final index = projects.indexWhere((p) => p.id == project.id);
    if (index >= 0) {
      // Actualizar
      projects[index] = project.copyWith(updatedAt: DateTime.now());
    } else {
      // Crear nuevo
      projects.add(project);
    }
    
    await saveData(data.copyWithProjects(projects));
    return project;
  }

  /// Elimina un proyecto
  Future<void> deleteProject(int id) async {
    final data = await getData();
    final projects = data.projects.where((p) => p.id != id).toList();
    // También eliminar las tareas del proyecto
    final tasks = data.tasks.where((t) => t.projectId != id).toList();
    
    await saveData(AppData(projects: projects, tasks: tasks));
  }

  /// Obtiene todas las tareas
  Future<List<Task>> getTasks() async {
    final data = await getData();
    return data.tasks;
  }

  /// Obtiene las tareas de un proyecto
  Future<List<Task>> getTasksByProject(int projectId) async {
    final data = await getData();
    return data.getTasksForProject(projectId);
  }

  /// Obtiene una tarea por ID
  Future<Task?> getTask(int id) async {
    final tasks = await getTasks();
    try {
      return tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Guarda una tarea (crear o actualizar)
  Future<Task> saveTask(Task task) async {
    final data = await getData();
    final tasks = List<Task>.from(data.tasks);
    
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      // Actualizar
      tasks[index] = task.copyWith(updatedAt: DateTime.now());
    } else {
      // Crear nuevo
      tasks.add(task);
    }
    
    await saveData(data.copyWithTasks(tasks));
    return task;
  }

  /// Elimina una tarea
  Future<void> deleteTask(int id) async {
    final data = await getData();
    final tasks = data.tasks.where((t) => t.id != id).toList();
    await saveData(data.copyWithTasks(tasks));
  }

  /// Obtiene el siguiente ID para proyectos
  Future<int> getNextProjectId() async {
    final data = await getData();
    return data.nextProjectId;
  }

  /// Obtiene el siguiente ID para tareas
  Future<int> getNextTaskId() async {
    final data = await getData();
    return data.nextTaskId;
  }

  /// Limpia la caché
  void clearCache() {
    _cachedData = null;
  }

  /// Resetea los datos a los valores iniciales
  Future<void> resetData() async {
    await _prefs!.remove(_dataKey);
    clearCache();
    await _loadInitialData();
  }
}
