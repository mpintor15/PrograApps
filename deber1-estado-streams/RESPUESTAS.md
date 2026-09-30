# RESPUESTAS — Deber 1

## Parte A

### Pregunta 1 (setState)

En el paso 3 (entrar a Control, incrementar y salir con el gesto del sistema en vez del botón "Volver") el visor se quedó mostrando el valor anterior. Por ejemplo, con el contador en 3, subí a 4 en Control, salí con el gesto y el visor seguía diciendo 3, mientras el disco ya tenía 4 (al cerrar y reabrir la app aparece el 4).

Lo que quedó desactualizado no es el dato guardado, sino **la copia en memoria que tiene `PantallaVisor` en su `State` (`_contador`)**. El valor solo llega de vuelta al visor si alguien lo devuelve con `Navigator.pop(valor)`, y el gesto del sistema hace `pop` sin valor, así que el `setState` del visor nunca se ejecuta.

Para que el contador viajara entre las dos pantallas tuvieron que ponerse de acuerdo **cuatro lugares del código**: 
1) El constructor de `PantallaControl`, que recibe el valor inicial
2) El `setState` de Control, que mantiene su propia copia
3) El botón "Volver", que hace `Navigator.pop(_contador)` para devolver el valor
4) El `await Navigator.push` del visor, que recibe ese valor y hace su propio `setState`. Si cualquiera falla o se omite (como pasa con el gesto), las dos pantallas divergen.

### Pregunta 2 (Riverpod)

Porque ninguna de las dos pantallas es dueña del contador. Vive en un `NotifierProvider` (`ContadorNotifier`), fuera del árbol de widgets, dentro del `ProviderScope` que envuelve toda la app. Tanto el visor como el control lo observan, así que al incrementar en Control el visor se reconstruye solo. No importa cómo se cierre Control (botón "Volver" o gesto del sistema): el estado no depende de un valor de retorno, y nadie tiene que "avisar" al visor.

### Pregunta 3 (BlocObserver)

El `BlocObserver` imprime en consola **cada cambio de estado de cualquier Cubit, con el valor anterior y el nuevo**, en orden y desde un solo lugar registrado en `main.dart`: `ContadorCubit: 0 -> 1`, `1 -> 2`, `2 -> 1`... En las versiones con `setState` y con Riverpod no tenía ese registro: solo veía el resultado final en pantalla, no la secuencia de cómo se llegó a él. Como el estado del Cubit es inmutable (cada cambio es un valor nuevo), la historia completa queda rastreable sin modificar las pantallas ni el Cubit.

Sería útil en una situación real como depurar un reporte del tipo "el saldo/contador quedó en un valor raro": con el registro se puede reconstruir qué secuencia de cambios lo produjo. También sirve para auditar o para enviar esos eventos a un servicio de logs o analítica sin tocar la lógica de negocio.

### Pregunta 4 (diffs de la arquitectura)

```text
$ git diff deber1/setstate deber1/riverpod -- deber1-estado-streams/parte_a_contador/lib/domain deber1-estado-streams/parte_a_contador/lib/data
(sin salida)

$ git diff deber1/setstate deber1/bloc -- deber1-estado-streams/parte_a_contador/lib/domain deber1-estado-streams/parte_a_contador/lib/data
(sin salida)

$ git diff deber1/setstate deber1/bloc --stat -- deber1-estado-streams/parte_a_contador/lib/presentation
 .../lib/presentation/estado/contador_cubit.dart    | 20 ++++++++
 .../lib/presentation/estado/contador_observer.dart | 12 +++++
 .../presentation/pantallas/pantalla_control.dart   | 55 +++++++-------------
 .../lib/presentation/pantallas/pantalla_visor.dart | 58 +++++-----------------
 4 files changed, 63 insertions(+), 82 deletions(-)
```

Que los dos primeros salgan vacíos demuestra que cambié de administrador de estado dos veces (de `setState` a Riverpod y a Cubit) **sin modificar ni una línea de `domain/` ni de `data/`**: la lógica del contador (leer, sumar, restar, guardar) y el acceso a `shared_preferences` no saben qué administrador de estado existe. Que el tercero no salga vacío muestra dónde está la frontera: todo lo que cambió está en `presentation/`.

Si mañana tuviera que cambiar Riverpod por otro paquete, tendría que reescribir solo `presentation/estado/` (el provider/notifier), las dos pantallas y la parte de `main.dart` que arma el estado. `domain/` y `data/` quedan intactos.

### Pregunta 5 (elección según el número de pantallas)

Con **una sola pantalla** elegiría `setState`: el estado tiene un solo dueño y no hay nada que compartir, así que no hay razón para agregar un paquete, más archivos y más conceptos. Con **ocho pantallas que comparten cinco datos distintos** elegiría Riverpod (o Cubit si el equipo ya usa BLoC): con `setState` habría que pasar los datos por constructores y devolverlos en cada `pop`, y ya vimos en la pregunta 1 que eso se rompe con el gesto del sistema. Un estado fuera del árbol de widgets, observable por cualquier pantalla, es la solución. Entre Riverpod y Cubit, Cubit aporta más si se necesita trazabilidad (el `BlocObserver`), y Riverpod si se quiere componer estados entre sí con poco código.

`setState` sí es la opción correcta cuando el estado es local a un solo widget y no lo necesita nadie más (un campo de texto, un botón que se expande, una animación). Complicar eso con un administrador de estado es sobreingeniería.

### Tabla comparativa (A.6)

| | setState | Riverpod | Cubit |
|---|---|---|---|
| ¿Dónde vive el contador? | En el `State` de `PantallaVisor` (`_contador`); Control tiene una copia propia | En un `NotifierProvider` (`ContadorNotifier`), fuera del árbol de widgets, dentro del `ProviderScope` | En el `ContadorCubit`, creado por un `BlocProvider` por encima de `MaterialApp` |
| ¿Las pantallas se pasan datos? | Sí: el valor y los casos de uso por constructor, y el valor de vuelta con `Navigator.pop` | No: cada pantalla observa el provider | No: cada pantalla usa `BlocBuilder` / `context.read` |
| Archivos de `presentation/` que tocaste | 2 (`pantalla_visor`, `pantalla_control`), más `main.dart` | 3 (`contador_provider`, las 2 pantallas), más `main.dart` | 4 (`contador_cubit`, `contador_observer`, las 2 pantallas), más `main.dart` |
| ¿Qué pasa con el botón atrás? | Con "Volver" el visor se actualiza; con el gesto/botón del sistema el visor queda desactualizado (el disco sí tiene el valor nuevo) | Funciona con ambos: el visor siempre está al día | Funciona con ambos: el visor siempre está al día |
| ¿Tuviste que tocar `domain/`? | No | No | No |

## Parte B

### Pregunta 6 (Future)

La pantalla siguió mostrando "Wi-Fi" porque un `Future` se resuelve **una sola vez**: al pulsar "Consultar ahora" la app hizo la pregunta, recibió la respuesta "Wi-Fi" y la guardó en el `State`. Después nadie volvió a preguntar, así que nada hizo que la pantalla cambiara cuando el sistema operativo apagó el Wi-Fi.

No era un dato **incorrecto**: en el momento de la consulta la conexión sí era Wi-Fi, y por eso la hora que se muestra al lado es la de esa consulta. Era un **dato correcto de un momento equivocado**: cada segundo que pasaba se volvía más viejo, pero la pantalla lo presentaba como si fuera el estado actual. Solo al pulsar el botón otra vez apareció "Sin conexión".

### Pregunta 7 (cancel() en close())

Sin el `cancel()`, la suscripción al stream de `connectivity_plus` seguiría viva después de que el Cubit se cerró. Cada vez que el usuario entra a "Con Stream" se crea un Cubit nuevo con su propia suscripción, y cada vez que sale, el Cubit se cierra pero su suscripción queda escuchando (y con ella el Cubit, que no se puede recolectar mientras el stream lo referencie). Después de 50 entradas y salidas habría **50 suscripciones activas al mismo stream**, todas procesando cada cambio de conexión.

Consecuencias: fuga de memoria y de trabajo que crece con el uso, y errores. Cuando llegue un cambio de conexión, cada suscripción huérfana intentará hacer `emit()` sobre un Cubit ya cerrado, lo que lanza un `StateError` ("Cannot emit new states after calling close"). Con el `cancel()` dentro de `close()`, al salir de la pantalla la suscripción se cierra y no queda nada escuchando.

### Pregunta 8 (Future = foto, Stream = película)

Con la conexión: en la pestaña "Con Future" pulsé el botón cuando había Wi-Fi y obtuve *una imagen fija* de ese instante. Aunque después el Wi-Fi se apagó, la imagen no cambió: seguía mostrando el pasado. En la pestaña "Con Stream" no pulsé nada: la app quedó abierta y, cada vez que el sistema operativo notificaba un cambio, la pantalla se actualizaba sola. En el video se ve la secuencia Wi-Fi → Sin conexión → Wi-Fi → Datos móviles, con el contador de cambios recibidos subiendo (1, 3, 4, 6). Ese contador también muestra que un stream entrega **todo lo que el sistema va notificando**, incluyendo pasos intermedios, no un solo evento por acción mía. Un `Future` da una foto de cuando se pidió; un `Stream` da la película de lo que sigue pasando mientras la app está abierta.

Datos que pediría con **`Future`** (se consultan una vez, no cambian solos mientras uso la pantalla): (1) el perfil del usuario al abrir la pantalla de cuenta; (2) el detalle de un producto al abrir su página.

Datos que observaría con **`Stream`** (cambian por su cuenta): (1) los mensajes nuevos de un chat; (2) la ubicación del repartidor en un mapa de seguimiento de pedido (o el estado de la conexión, como en este deber).
