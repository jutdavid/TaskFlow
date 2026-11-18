import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'task.dart';

void main() {
  runApp(const TaskFlowApp());
}

// Paleta de color propia
class AppColors {
  static const Color primary = Color(0xFF3D5AFE);
  static const Color secondary = Color(0xFF00BFA5);
  static const Color background = Color(0xFF0F1226);
  static const Color card = Color(0xFF1B1F3B);
  static const Color textLight = Color(0xFFEDEFFF);
}

// Cinco tareas propias, con ids únicos y usuario de prueba.
const demoTasks = <Task>[
  Task(
    id: 1,
    title: 'Configurar entorno Flutter',
    description:
        'Instalar el SDK de Flutter, Android Studio y configurar un '
        'dispositivo para ejecutar la aplicación.',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 2,
    title: 'Crear pantalla de bienvenida',
    description:
        'Mostrar el nombre de la app, el nombre del estudiante, un '
        'contador de tareas y una paleta de color propia.',
    priority: 'Alta',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 3,
    title: 'Implementar navegación',
    description:
        'Configurar go_router para abrir el detalle de una tarea '
        'usando su id en la ruta.',
    priority: 'Media',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 4,
    title: 'Definir el modelo de datos',
    description:
        'Crear la clase Task con id, título, descripción, prioridad, '
        'estado y usuario, y documentar el alcance en el README.',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 5,
    title: 'Conectar con API REST',
    description:
        'Consumir tareas desde un servicio web y mostrar estados de '
        'carga, vacío y error en la interfaz.',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
];

// Devuelve la tarea con ese id, o null si no existe.
Task? findTask(int? id) {
  for (final task in demoTasks) {
    if (task.id == id) return task;
  }
  return null;
}

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return TaskDetailScreen(task: findTask(id));
      },
    ),
  ],
);

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      ),
      routerConfig: appRouter,
    );
  }
}

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return Card(
            child: ListTile(
              leading: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted ? Colors.green : null,
              ),
              title: Text(task.title),
              subtitle: Text('Prioridad: ${task.priority}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/task/${task.id}'),
            ),
          );
        },
      ),
    );
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task? task;

  Color _priorityColor(String priority) {
    switch (priority) {
      case 'Alta':
        return Colors.redAccent;
      case 'Media':
        return Colors.orangeAccent;
      default:
        return Colors.lightGreenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = task;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: selected == null
            ? const Text('No se encontró esta tarea.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(selected.description),
                  const SizedBox(height: 16),
                  Chip(
                    avatar: Icon(
                      Icons.flag,
                      color: _priorityColor(selected.priority),
                    ),
                    label: Text('Prioridad: ${selected.priority}'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        selected.isCompleted
                            ? Icons.check_circle
                            : Icons.pending_actions,
                        color: selected.isCompleted
                            ? Colors.green
                            : Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selected.isCompleted
                            ? 'Estado: completada'
                            : 'Estado: pendiente',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Usuario: ${selected.userId}'),
                ],
              ),
      ),
    );
  }
}
