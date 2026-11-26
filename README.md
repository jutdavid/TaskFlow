
## Alcance de TaskFlow

Problema: necesito organizar actividades académicas y saber cuáles faltan.
Usuario objetivo: estudiante que planifica entregas semanales.

### Historias de usuario y criterios de aceptación

1. Como estudiante, quiero listar mis tareas para ver qué debo hacer.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos

Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas

- Lista: tarjetas de tareas y acción para crear.
- Detalle: información completa y futuras acciones de editar o eliminar.
- Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales

- La navegación debe tener textos comprensibles.
- Un id inexistente debe mostrar un mensaje en vez de cerrar la app.

### Contrato de API que necesitaremos

- GET /tasks: listar tareas
- GET /tasks/:id: consultar detalle
- POST /tasks: crear tarea
- PATCH /tasks/:id: actualizar tarea
- DELETE /tasks/:id: eliminar tarea

La API concreta se elegirá después. Estas rutas son requisitos, no
direcciones de un servidor ya conectado.

## API de tareas

TaskFlow lee sus tareas de JSONPlaceholder, una API pública de práctica.

- URL exacta: https://jsonplaceholder.typicode.com/todos?userId=2
- Método: GET
- Parámetro userId: filtra las tareas de un usuario. En TaskFlow la constante `TaskApiService.userId` vale 2.
- Campos que llegan de la API: `userId`, `id`, `title` y `completed`.
- Valores que TaskFlow completa por defecto: `description` ("Sin descripción (API)") y `priority` ("Sin prioridad (API)"), porque la API no los entrega.
- Marcar una tarea como completada es un cambio local: se guarda solo en memoria y se pierde al reiniciar la app, porque JSONPlaceholder no guarda cambios.
- Arquitectura: `TaskApiService` (HTTP con Dio) -> `RemoteTaskRepository` -> `TasksViewModel` -> pantallas.


## Estados de la lista de tareas

La pantalla de tareas distingue cuatro situaciones:

- Carga: se muestra un indicador de progreso mientras la petición está pendiente.
- Éxito: se muestra una tarjeta por cada tarea recibida de la API.
- Vacío: la API responde correctamente pero sin tareas. Se muestra un mensaje y el botón Actualizar.
- Error: la petición falla y se muestra un mensaje con el botón Reintentar.

Cómo provoqué cada estado:

- Éxito: con internet, `userId = 2` devuelve tareas.
- Vacío: cambié temporalmente `TaskApiService.userId` a 9999, un usuario que no existe, y la API devolvió una lista vacía. Luego restauré el valor 2.
- Error: apagué el WiFi y los datos del celular y pulsé actualizar. Al reactivar internet, el botón Reintentar recuperó la lista sin reiniciar la app.

Una lista vacía es una respuesta válida; un error significa que no se sabe qué tareas hay.


## Formulario de tareas

La pantalla "Nueva tarea" (ruta `/new`) permite preparar una tarea con título, descripción, prioridad y una fecha límite opcional.

- Título: obligatorio, mínimo 3 caracteres.
- Descripción: opcional, máximo 200 caracteres.
- Prioridad: Alta, Media o Baja (por defecto Media).
- Fecha límite: opcional, elegida con `showDatePicker`; no es necesaria para guardar.

Guardar devuelve un borrador (`TaskDraft`) a la lista y muestra un mensaje de confirmación. Todavía no envía datos a la API; la creación con POST se implementará en la sesión 10.
