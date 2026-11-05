import 'package:flutter/material.dart';

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

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
      ),
      home: const TaskListScreen(),
    );
  }
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
    description: 'Instalar SDK, Android Studio y emulador',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 2,
    title: 'Crear pantalla de bienvenida',
    description: 'Mostrar nombre, contador y paleta de color',
    priority: 'Alta',
    isCompleted: true,
  ),
  Task(
    id: 3,
    title: 'Implementar estado con setState',
    description: 'Agregar y completar tareas pendientes',
    priority: 'Media',
    isCompleted: true,
  ),
  Task(
    id: 4,
    title: 'Construir listado de tareas',
    description: 'Usar ListView.builder y TaskCard',
    priority: 'Alta',
    isCompleted: false,
  ),
  Task(
    id: 5,
    title: 'Conectar con API REST',
    description: 'Consumir tareas desde un servicio web',
    priority: 'Media',
    isCompleted: false,
  ),
];

// Representa visualmente UNA tarea.
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),
        title: Text(task.title),
        subtitle: Text('${task.priority} · ${task.description}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Tarea ${task.id}: ${task.title} '
                '(${task.isCompleted ? 'completada' : 'pendiente'})',
              ),
            ),
          );
        },
      ),
    );
  }
}

// Pantalla que construye una TaskCard por cada tarea, bajo demanda.
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
          return TaskCard(task: task);
        },
      ),
    );
  }
}
