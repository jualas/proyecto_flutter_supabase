import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'blocs/blocs.dart';
import 'services/services.dart';
import 'services/taskboard_data_source.dart';
import 'services/supabase/supabase_data_source.dart';
import 'router/app_router.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar servicios
  final storageService = StorageService();
  await storageService.init();

  final dataSource = await _initDataSource(storageService);
  
  final authService = AuthService(storageService);
  await authService.init();
  
  final projectsService = ProjectsService(dataSource);
  final tasksService = TasksService(dataSource);
  
  runApp(TaskBoardApp(
    storageService: storageService,
    authService: authService,
    projectsService: projectsService,
    tasksService: tasksService,
  ));
}

Future<TaskboardDataSource> _initDataSource(StorageService storageService) async {
  // Prioridad: --dart-define (ideal para deployments) > config.json > fallback local
  const envUrl = String.fromEnvironment('SUPABASE_URL');
  const envAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  String url = envUrl;
  String anonKey = envAnonKey;

  if (url.trim().isEmpty || anonKey.trim().isEmpty) {
    final config = await storageService.getConfig();
    final sb = config.supabase;
    if (sb != null && sb.isEnabled) {
      url = sb.url;
      anonKey = sb.anonKey;
    }
  }

  if (url.trim().isEmpty || anonKey.trim().isEmpty) {
    return storageService; // modo local
  }

  await Supabase.initialize(url: url, anonKey: anonKey);
  return SupabaseDataSource(Supabase.instance.client);
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
