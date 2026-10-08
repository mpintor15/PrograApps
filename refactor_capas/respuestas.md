# Respuestas — Refactor en capas

## Parte 1
1. Conviven: acceso a datos (HTTP), parseo JSON, regla de negocio (filtro por vocal), manejo del estado de carga/error y construcción de la interfaz.
2. La URL está dentro de `_PantallaUsuariosState`, en el mismo archivo y clase que dibuja los widgets. Un cambio de acceso a datos obliga a editar y reprobar la UI. Evidencia mala cohesión y alto acoplamiento: la pantalla conoce detalles que no le corresponden.
3. No. El filtro está dentro de `cargar()` de un `State`, entre la llamada HTTP y `setState`. Para probarlo habría que montar el widget y usar la red real o un mock de `http`. Como función independiente sería un test de Dart puro.

## Parte 2
4. En el mismo archivo conviven HTTP, JSON, una regla de negocio y widgets; no comparten propósito ni razón de cambio.
5. Con una base local habría que cambiar el import de `http`, la llamada, el parseo y probablemente el tipo de dato y el filtro, que está pegado a esa estructura. El acoplamiento es alto: la pantalla "sabe" de dónde vienen los datos.

## Parte 3
6. La regla quedó en `domain`, dentro del caso de uso `ObtenerUsuariosConVocal`. Es una regla de negocio: decide qué usuarios son válidos para mostrar, sin importar de dónde vengan (`data`) ni cómo se dibujen (`presentation`). Ahí es Dart puro y se puede probar sin Flutter ni red.
7. Antes, la pantalla dependía de `http`, de `dart:convert`, de la URL concreta de la API, del formato JSON (`Map<String, dynamic>`) y de la regla del filtro. Después del refactor, la presentación no importa `http` ni `dart:convert`, no conoce la URL, no crea `UsuarioApi` y no aplica el filtro: solo conoce el caso de uso `ObtenerUsuariosConVocal` y la entidad `Usuario`.

## Parte 5
8. La IA (en la pantalla original) mostraba en la interfaz el texto crudo de la excepción (`e.toString()`). No lo acepté tal cual: lo cambié por un mensaje fijo, "No se pudieron cargar los usuarios". El texto de una excepción filtra detalles internos (URL, códigos de estado) que no le sirven al usuario y que además pertenecen a la capa de datos. Si mañana `data` pasa de HTTP a una base local, ese mensaje de la presentación sigue siendo válido sin cambios.
