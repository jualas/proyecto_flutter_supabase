import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/blocs.dart';
import 'services/services.dart';
import 'router/app_router.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar servicios
  final storageService = StorageService();
  await storageService.init();
  
  final authService = AuthService(storageService);
  await authService.init();
  
  final projectsService = ProjectsService(storageService);
  final tasksService = TasksService(storageService);
  
  runApp(TaskBoardApp(
    storageService: storageService,
    authService: authService,
    projectsService: projectsService,
    tasksService: tasksService,
  ));
}

class TaskBoardApp extends StatelessWidget {
  final StorageService storageService;
  final AuthService authService;
  final ProjectsService projectsService;
  final TasksService tasksService;
  
  const TaskBoardApp({
    super.key,
    required this.storageService,
    required this.authService,
    required this.projectsService,
    required this.tasksService,
  });

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter(authService: authService);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(authService: authService)
            ..add(AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) => ProjectsBloc(projectsService: projectsService),
        ),
        BlocProvider(
          create: (_) => TasksBloc(tasksService: tasksService),
        ),
      ],
      child: MaterialApp.router(
        title: 'TaskBoard Personal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: appRouter.router,
      ),
    );
  }
}
