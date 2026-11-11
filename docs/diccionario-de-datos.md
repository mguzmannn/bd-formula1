# Diccionario de datos

Descripción de las tablas del modelo lógico (PostgreSQL). Convenciones: **PK** clave primaria, **FK** clave foránea, **UK** valor único, **NN** no nulo.

## Entidades principales

### `pais`
Ubicación de los circuitos y nacionalidad de pilotos y escuderías.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_pais | CHAR(3) | PK, formato `[A-Z]{3}` | Código ISO de 3 letras |
| nombre | VARCHAR(100) | NN, UK | Nombre oficial |
| continente | VARCHAR(30) | NN | Continente al que pertenece |

### `motor`
Motores que usan las escuderías y su fabricante.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_motor | INTEGER | PK (identity) | Identificador único |
| marca_fabricante | VARCHAR(50) | NN, UK (con modelo) | Marca que lo fabrica |
| modelo | VARCHAR(50) | NN, UK (con marca) | Modelo específico |

### `escuderia`
Equipos constructores que participan en el campeonato.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_escuderia | INTEGER | PK (identity) | Identificador único |
| nombre | VARCHAR(100) | NN, UK | Nombre oficial |
| anio_fundacion | SMALLINT | NN, ≥ 1900 | Año de fundación |
| nombre_dir_deportivo | VARCHAR(100) | NN | Director deportivo |
| campeonatos_constructores | SMALLINT | NN, ≥ 0, default 0 | Títulos de constructores ganados |
| id_motor | INTEGER | FK → motor, NN | Motor asignado |
| id_pais | CHAR(3) | FK → pais, NN | País de origen |

### `piloto`
Datos personales y palmarés de los corredores.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_piloto | INTEGER | PK (identity) | Identificador único |
| nombre | VARCHAR(100) | NN | Nombre completo |
| fecha_nac | DATE | NN | Fecha de nacimiento |
| fecha_debut | DATE | posterior a fecha_nac | Fecha de debut en F1 |
| campeonatos_ganados | SMALLINT | NN, ≥ 0, default 0 | Títulos de pilotos ganados |
| id_pais | CHAR(3) | FK → pais, NN | Nacionalidad |

### `temporada`
Un año de competición.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| anio | SMALLINT | PK, ≥ 1950 | Año (identificador) |
| fecha_inicio | DATE | NN | Inicio de la temporada |
| fecha_fin | DATE | NN, posterior a fecha_inicio | Fin de la temporada |

### `circuito`
Características físicas de la pista.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_circuito | INTEGER | PK (identity) | Identificador único |
| nombre | VARCHAR(100) | NN, UK | Nombre oficial |
| tipo_circuito | VARCHAR(10) | NN, `permanente` / `callejero` / `mixto` | Clasificación del circuito |
| longitud | NUMERIC(5,3) | NN, > 0 | Longitud en km |
| cant_curvas | SMALLINT | NN, > 0 | Cantidad de curvas |
| tiempo_record | INTERVAL | opcional | Récord de vuelta vigente (mm:ss.mmm) |
| id_piloto_record | INTEGER | FK → piloto | Piloto que ostenta el récord (obligatorio si hay récord) |
| id_pais | CHAR(3) | FK → pais, NN | País donde se ubica |

### `gran_premio`
Fin de semana de competición dentro de una temporada.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_gp | INTEGER | PK (identity) | Identificador único |
| nombre_oficial | VARCHAR(150) | NN, UK (con anio) | Nombre oficial del evento |
| fecha | DATE | NN | Fecha de realización |
| nro_ronda | SMALLINT | NN, > 0, UK (con anio) | Orden dentro de la temporada |
| id_circuito | INTEGER | FK → circuito, NN | Circuito donde se realiza |
| anio | SMALLINT | FK → temporada, NN | Temporada a la que pertenece |

## Sesiones (especialización)

### `sesion`
Superclase con los datos comunes a cualquier salida a pista.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_sesion | INTEGER | PK (identity) | Identificador único |
| fecha_inicio | DATE | NN | Fecha de la sesión |
| hora_inicio | TIME | NN | Hora de inicio |
| duracion_estimada | SMALLINT | NN, > 0 | Duración estimada en minutos |
| id_gp | INTEGER | FK → gran_premio, NN | Gran Premio al que pertenece |

### `practica_libre`, `clasificacion`, `carrera_principal`
Subclases de `sesion`: comparten su PK (`id_sesion`, FK → sesion).

| Tabla | Atributos propios | Descripción |
|---|---|---|
| practica_libre | tipo (`FP1` / `FP2` / `FP3`, NN) | Entrenamientos libres |
| clasificacion | — | Sesión que define la parrilla de salida |
| carrera_principal | nro_vueltas (NN, > 0) | Carrera central del fin de semana |

## Relaciones con atributos

### `compite_para`
Historial de escuderías: con qué escudería corrió cada piloto en cada temporada.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_piloto | INTEGER | PK, FK → piloto | Piloto |
| anio | SMALLINT | PK, FK → temporada | Temporada |
| id_escuderia | INTEGER | FK → escuderia, NN | Escudería para la que corre |
| nro_piloto | SMALLINT | NN, 1 a 99, UK (con anio) | Número en la pista, único por temporada |

### `clasificado`
Resultado de cada piloto en una sesión de clasificación.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_sesion | INTEGER | PK, FK → clasificacion | Sesión de clasificación |
| id_piloto | INTEGER | PK, FK → piloto | Piloto |
| posicion_parrilla | SMALLINT | NN, ≥ 1, UK (con id_sesion) | Posición de salida obtenida |
| t_q1, t_q2, t_q3 | INTERVAL | opcionales | Mejor tiempo en cada tramo (Q3 solo si hay Q2, y Q2 solo si hay Q1) |

### `corre_en`
Resultado de cada piloto en la carrera principal.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_sesion | INTEGER | PK, FK → carrera_principal | Carrera |
| id_piloto | INTEGER | PK, FK → piloto | Piloto |
| posicion_final | SMALLINT | NN, ≥ 1, UK (con id_sesion) | Posición final obtenida |
| tiempo_total | INTERVAL | opcional | Tiempo total (nulo si no completó) |
| gap_al_ganador | INTERVAL | opcional | Diferencia de tiempo con el ganador |
| nro_vueltas_completadas | SMALLINT | NN, ≥ 0 | Vueltas completadas |
| estado_finalizacion | VARCHAR(15) | NN, `completo` / `abandono` / `descalificado` / `no_largo` | Estado al terminar |
| puntos_obtenidos | SMALLINT | NN, ≥ 0, default 0 | Puntos sumados en la carrera |

## Penalizaciones

### `penalizacion`
| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_penalizacion | INTEGER | PK (identity) | Identificador único |
| tipo | VARCHAR(20) | NN, `tiempo_agregado` / `drive_through` / `stop_and_go` | Tipo de sanción |
| cantidad_segundos | SMALLINT | > 0; obligatorio si el tipo es `tiempo_agregado` | Magnitud de la sanción |
| motivo | VARCHAR(255) | NN | Motivo detallado |
| vuelta_ocurrencia | SMALLINT | NN, ≥ 1 | Vuelta en la que ocurrió |
| comisario | VARCHAR(100) | NN | Comisario deportivo que la aplicó |

### `penalizado`
Asocia cada penalización con el piloto sancionado en una carrera concreta.

| Columna | Tipo | Restricciones | Descripción |
|---|---|---|---|
| id_penalizacion | INTEGER | PK, FK → penalizacion | Sanción |
| id_sesion, id_piloto | INTEGER | NN, FK compuesta → corre_en | Carrera y piloto sancionado (debe haber corrido esa carrera) |
