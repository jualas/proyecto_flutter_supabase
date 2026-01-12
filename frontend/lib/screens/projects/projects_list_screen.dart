import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/blocs.dart';
import '../../models/models.dart';
import '../../themes/app_theme.dart';

class ProjectsListScreen extends StatefulWidget {
  const ProjectsListScreen({super.key});

  @override
  State<ProjectsListScreen> createState() => _ProjectsListScreenState();
}

class _ProjectsListScreenState extends State<ProjectsListScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProjectsBloc>().add(ProjectsLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Proyectos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ProjectsBloc>().add(ProjectsLoadRequested());
            },
            tooltip: 'Actualizar',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            },
            tooltip: 'Cerrar sesión',
          ),
        ],
      ),
      body: BlocConsumer<ProjectsBloc, ProjectsState>(
        listener: (context, state) {
          if (state is ProjectsFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is ProjectOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProjectsLoaded) {
            if (state.projects.isEmpty) {
              return _buildEmptyState();
            }
            return _buildProjectsList(state.projects);
          }

          return _buildEmptyState();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateProjectDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Proyecto'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_open,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No tienes proyectos aún',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Crea tu primer proyecto para comenzar',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showCreateProjectDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Crear Proyecto'),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectsList(List<Project> projects) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          return _buildProjectCard(projects[index]);
        },
      ),
    );
  }

  Widget _buildProjectCard(Project project) {
    final statusColor = _getStatusColor(project.status);
    
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/projects/${project.id}/kanban'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con estado
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                border: Border(
                  bottom: BorderSide(
                    color: statusColor.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      project.status.displayName,
                      style: const TextStyle(
                        color: AppColors.textOnDark,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) => _handleProjectAction(value, project),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'kanban',
                        child: Row(
                          children: [
                            Icon(Icons.view_kanban),
                            SizedBox(width: 8),
                            Text('Ver Kanban'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'list',
                        child: Row(
                          children: [
                            Icon(Icons.list),
                            SizedBox(width: 8),
                            Text('Ver Lista'),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Eliminar', style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Contenido
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        project.description.isEmpty 
                            ? 'Sin descripción'
                            : project.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: project.description.isEmpty 
                              ? AppColors.textSecondary.withValues(alpha: 0.5)
                              : null,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(project.updatedAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.planning:
        return AppColors.warning;
      case ProjectStatus.development:
        return AppColors.accentPrimary;
      case ProjectStatus.completed:
        return AppColors.success;
      case ProjectStatus.archived:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _handleProjectAction(String action, Project project) {
    switch (action) {
      case 'kanban':
        context.go('/projects/${project.id}/kanban');
        break;
      case 'list':
        context.go('/projects/${project.id}/tasks');
        break;
      case 'edit':
        _showEditProjectDialog(project);
        break;
      case 'delete':
        _showDeleteConfirmation(project);
        break;
    }
  }

  void _showCreateProjectDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nuevo Proyecto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Nombre del proyecto',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Descripción opcional',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                context.read<ProjectsBloc>().add(
                  ProjectCreateRequested(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Crear'),
          ),
        ],
      ),
    );
  }

  void _showEditProjectDialog(Project project) {
    final titleController = TextEditingController(text: project.title);
    final descriptionController = TextEditingController(text: project.description);
    ProjectStatus selectedStatus = project.status;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Editar Proyecto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<ProjectStatus>(
                value: selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Estado',
                ),
                items: ProjectStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.displayName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedStatus = value);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isNotEmpty) {
                  context.read<ProjectsBloc>().add(
                    ProjectUpdateRequested(
                      project.copyWith(
                        title: titleController.text.trim(),
                        description: descriptionController.text.trim(),
                        status: selectedStatus,
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Project project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Proyecto'),
        content: Text(
          '¿Estás seguro de que quieres eliminar "${project.title}"?\n\n'
          'Esta acción también eliminará todas las tareas del proyecto.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ProjectsBloc>().add(
                ProjectDeleteRequested(project.id),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
