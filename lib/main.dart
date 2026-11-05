import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

// Modelo de datos: solo representa una tarea, no dibuja nada.
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
}

// Backlog local con tareas reales del proyecto.
const demoTasks = [
  Task(
    id: 1,
    title: 'Configurar entorno Flutter',
    description:
        'Instalar el SDK de Flutter, Android Studio y configurar un '
        'dispositivo para ejecutar la aplicación.',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 2,
    title: 'Crear pantalla de bienvenida',
    description:
        'Mostrar el nombre de la app, el nombre del estudiante, un '
        'contador de tareas y una paleta de color propia.',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 3,
    title: 'Implementar estado con setState',
    description:
        'Agregar y completar tareas pendientes usando StatefulWidget '
        'y un objetivo diario de tareas completadas.',
    priority: 'Media',
    isCompleted: true,
  ),
  Task(
    id: 4,
    title: 'Construir listado de tareas',
    description:
        'Modelar la clase Task y mostrar las tareas con TaskCard '
        'dentro de un ListView.builder.',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 5,
    title: 'Conectar con API REST',
    description:
        'Consumir tareas desde un servicio web y mostrar estados de '
        'carga, vacío y error en la interfaz.',
    priority: 'Media',
    isCompleted: false,
  ),
];

// Rutas declarativas: '/' es el listado y '/task/:id' el detalle.
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final taskId = int.parse(state.pathParameters['id']!);
        return TaskDetailScreen(taskId: taskId);
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

// Representa visualmente UNA tarea. La pantalla decide qué pasa al tocarla.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),
        title: Text(task.title),
        subtitle: Text(
          '${task.priority} · ${task.description}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// Listado: cada tarjeta navega al detalle enviando el id en la ruta.
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
          return TaskCard(
            task: task,
            onTap: () => context.push('/task/${task.id}'),
          );
        },
      ),
    );
  }
}

// Detalle: recibe un id, busca la tarea y muestra toda su información.
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

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
    final task = demoTasks.firstWhere((item) => item.id == taskId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(task.description),
            const SizedBox(height: 16),
            Chip(
              avatar: Icon(Icons.flag, color: _priorityColor(task.priority)),
              label: Text('Prioridad: ${task.priority}'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.pending_actions,
                  color: task.isCompleted ? Colors.green : Colors.amber,
                ),
                const SizedBox(width: 8),
                Text(
                  task.isCompleted ? 'Estado: completada' : 'Estado: pendiente',
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Acción contextual según el estado de la tarea.
            if (task.isCompleted)
              const Text(
                '¡Buen trabajo! Esta tarea ya está terminada.',
                style: TextStyle(color: AppColors.secondary),
              )
            else
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tarea "${task.title}" lista para iniciar'),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Empezar esta tarea'),
              ),
            const Spacer(),
            FilledButton.tonalIcon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver al listado'),
            ),
          ],
        ),
      ),
    );
  }
}
