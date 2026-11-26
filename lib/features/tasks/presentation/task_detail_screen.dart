import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tasks_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int? taskId;

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
    final task = context.watch<TasksViewModel>().findTask(taskId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: task == null
          ? const Center(child: Text('No se encontrÃ³ esta tarea.'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(task.description),
                const SizedBox(height: 16),
                Chip(
                  avatar: Icon(
                    Icons.flag,
                    color: _priorityColor(task.priority),
                  ),
                  label: Text('Prioridad: ${task.priority}'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.pending_actions,
                      color: task.isCompleted ? Colors.green : Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      task.isCompleted
                          ? 'Estado: completada'
                          : 'Estado: pendiente',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Usuario: ${task.userId}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<TasksViewModel>().toggleCompleted(task.id);
                  },
                  child: Text(
                    task.isCompleted
                        ? 'Marcar como pendiente'
                        : 'Marcar como completada',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final viewModel = context.read<TasksViewModel>();
                    final controller = TextEditingController(text: task.title);
                    final newTitle = await showDialog<String>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Editar tÃ­tulo'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'TÃ­tulo',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(
                              dialogContext,
                              controller.text.trim(),
                            ),
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    );
                    if (newTitle == null) return;
                    if (newTitle.length < 3) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            'El tÃ­tulo necesita al menos 3 caracteres.',
                          ),
                        ),
                      );
                      return;
                    }
                    try {
                      await viewModel.updateTask(
                        task.copyWith(title: newTitle),
                      );
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Tarea actualizada')),
                      );
                    } catch (_) {
                      messenger.showSnackBar(
                        const SnackBar(content: Text('No se pudo actualizar')),
                      );
                    }
                  },
                  child: const Text('Editar tÃ­tulo'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    final viewModel = context.read<TasksViewModel>();
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Eliminar tarea'),
                        content: Text('Â¿Eliminar ${task.title}?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed != true || !context.mounted) return;
                    try {
                      await viewModel.deleteTask(task.id);
                      if (context.mounted) context.pop();
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Tarea eliminada')),
                      );
                    } catch (_) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('No se pudo eliminar la tarea'),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Eliminar tarea'),
                ),
              ],
            ),
    );
  }
}
