import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Configurar entorno Flutter',
      description:
          'Instalar el SDK de Flutter, Android Studio y configurar un '
          'dispositivo para ejecutar la aplicación.',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Crear pantalla de bienvenida',
      description:
          'Mostrar el nombre de la app, el nombre del estudiante, un '
          'contador de tareas y una paleta de color propia.',
      priority: 'Alta',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Implementar navegación',
      description:
          'Configurar go_router para abrir el detalle de una tarea '
          'usando su id en la ruta.',
      priority: 'Media',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Definir el modelo de datos',
      description:
          'Crear la clase Task con id, título, descripción, prioridad, '
          'estado y usuario, y documentar el alcance en el README.',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
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

  @override
  List<Task> getTasks() => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
