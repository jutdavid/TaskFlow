import '../domain/task.dart';
import 'task_api_service.dart';
import 'task_repository.dart';

class RemoteTaskRepository implements TaskRepository {
  RemoteTaskRepository(this._apiService);

  // JSONPlaceholder solo tiene tareas con id hasta 200.
  static const int _maxServerId = 200;

  final TaskApiService _apiService;
  List<Task> _tasks = [];

  @override
  Future<List<Task>> getTasks() async {
    _tasks = await _apiService.getTasks();
    return List.unmodifiable(_tasks);
  }

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }

  @override
  Future<Task> createTask(
    String title,
    String description,
    String priority,
  ) async {
    final response = await _apiService.createTask(title);

    // La API simulada siempre responde con el mismo id (201).
    // Si ya existe en la lista, se asigna el siguiente id libre.
    var id = response.id;
    if (_tasks.any((task) => task.id == id)) {
      final maxId = _tasks
          .map((task) => task.id)
          .reduce((a, b) => a > b ? a : b);
      id = maxId + 1;
    }

    final task = Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      isCompleted: false,
      userId: response.userId,
    );
    _tasks = [..._tasks, task];
    return task;
  }

  @override
  Future<void> updateTask(Task task) async {
    // Las tareas creadas aquí no existen en el servidor: no hay PATCH.
    if (task.id <= _maxServerId) {
      await _apiService.updateTask(task);
    }
    save(task);
  }

  @override
  Future<void> deleteTask(int id) async {
    await _apiService.deleteTask(id);
    _tasks = _tasks.where((task) => task.id != id).toList();
  }
}
