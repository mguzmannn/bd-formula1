-- =====================================================================
-- Datos de ejemplo (ficticios) para probar el modelo y las consultas.
-- Los nombres de pilotos, escuderías, motores y resultados son inventados
-- y NO representan datos reales del campeonato.
-- =====================================================================

INSERT INTO pais (id_pais, nombre, continente) VALUES
    ('ARG', 'Argentina',      'América'),
    ('BRA', 'Brasil',         'América'),
    ('ESP', 'España',         'Europa'),
    ('GBR', 'Reino Unido',    'Europa'),
    ('ITA', 'Italia',         'Europa');

INSERT INTO motor (id_motor, marca_fabricante, modelo) VALUES
    (1, 'Fabricante A', 'FA-26'),
    (2, 'Fabricante B', 'FB-26');

INSERT INTO escuderia (id_escuderia, nombre, anio_fundacion, nombre_dir_deportivo, campeonatos_constructores, id_motor, id_pais) VALUES
    (1, 'Aurora Racing',  1998, 'Director Uno',  2, 1, 'GBR'),
    (2, 'Fuoco Corse',    1950, 'Director Dos',  9, 2, 'ITA'),
    (3, 'Viento Azul',    2008, 'Director Tres', 0, 1, 'ESP');

INSERT INTO piloto (id_piloto, nombre, fecha_nac, fecha_debut, campeonatos_ganados, id_pais) VALUES
    (1, 'Lucas Ferreira',  '1996-03-12', '2016-03-20', 1, 'ARG'),
    (2, 'Oliver Whitmore', '1998-07-01', '2018-03-25', 0, 'GBR'),
    (3, 'Marco Bellini',   '1999-11-23', '2019-03-17', 0, 'ITA'),
    (4, 'Dario Quintana',  '2001-05-09', '2021-03-28', 0, 'ESP'),
    (5, 'Rafael Duarte',   '2002-01-30', '2022-03-20', 0, 'BRA'),
    (6, 'Tomás Herrera',   '2003-09-14', '2024-03-02', 0, 'ARG');

INSERT INTO temporada (anio, fecha_inicio, fecha_fin) VALUES
    (2026, '2026-03-01', '2026-11-30');

INSERT INTO circuito (id_circuito, nombre, tipo_circuito, longitud, cant_curvas, tiempo_record, id_piloto_record, id_pais) VALUES
    (1, 'Autódromo Ejemplo Sur',  'permanente', 4.259, 14, '00:01:25.123', 1,    'ARG'),
    (2, 'Circuito Urbano Costa',  'callejero',  3.337, 19, NULL,           NULL, 'ESP');

INSERT INTO gran_premio (id_gp, nombre_oficial, fecha, nro_ronda, id_circuito, anio) VALUES
    (1, 'Gran Premio de Argentina', '2026-03-15', 1, 1, 2026),
    (2, 'Gran Premio de España',    '2026-03-29', 2, 2, 2026);

INSERT INTO sesion (id_sesion, fecha_inicio, hora_inicio, duracion_estimada, id_gp) VALUES
    (1, '2026-03-13', '11:30', 60,  1),   -- FP1 GP1
    (2, '2026-03-14', '15:00', 60,  1),   -- Clasificación GP1
    (3, '2026-03-15', '15:00', 120, 1),   -- Carrera GP1
    (4, '2026-03-27', '11:30', 60,  2),   -- FP1 GP2
    (5, '2026-03-28', '15:00', 60,  2),   -- Clasificación GP2
    (6, '2026-03-29', '15:00', 120, 2);   -- Carrera GP2

INSERT INTO practica_libre (id_sesion, tipo) VALUES (1, 'FP1'), (4, 'FP1');
INSERT INTO clasificacion  (id_sesion) VALUES (2), (5);
INSERT INTO carrera_principal (id_sesion, nro_vueltas) VALUES (3, 50), (6, 50);

INSERT INTO compite_para (id_piloto, anio, id_escuderia, nro_piloto) VALUES
    (1, 2026, 1, 1),
    (2, 2026, 1, 7),
    (3, 2026, 2, 16),
    (4, 2026, 2, 55),
    (5, 2026, 3, 14),
    (6, 2026, 3, 23);

-- Clasificación GP1 (Q1 todos, Q2 los 4 mejores, Q3 los 2 mejores)
INSERT INTO clasificado (id_sesion, id_piloto, posicion_parrilla, t_q1, t_q2, t_q3) VALUES
    (2, 2, 1, '00:01:26.100', '00:01:25.400', '00:01:24.900'),
    (2, 1, 2, '00:01:26.200', '00:01:25.500', '00:01:25.100'),
    (2, 3, 3, '00:01:26.500', '00:01:25.900', NULL),
    (2, 4, 4, '00:01:26.700', '00:01:26.000', NULL),
    (2, 5, 5, '00:01:27.000', NULL,           NULL),
    (2, 6, 6, '00:01:27.300', NULL,           NULL);

-- Clasificación GP2
INSERT INTO clasificado (id_sesion, id_piloto, posicion_parrilla, t_q1, t_q2, t_q3) VALUES
    (5, 1, 1, '00:01:30.100', '00:01:29.400', '00:01:28.800'),
    (5, 3, 2, '00:01:30.300', '00:01:29.600', '00:01:29.000'),
    (5, 2, 3, '00:01:30.500', '00:01:29.900', NULL),
    (5, 5, 4, '00:01:30.800', '00:01:30.100', NULL),
    (5, 4, 5, '00:01:31.000', NULL,           NULL),
    (5, 6, 6, '00:01:31.400', NULL,           NULL);

-- Resultados carrera GP1
INSERT INTO corre_en (id_sesion, id_piloto, posicion_final, tiempo_total, gap_al_ganador, nro_vueltas_completadas, estado_finalizacion, puntos_obtenidos) VALUES
    (3, 2, 1, '01:30:00.000', '00:00:00.000', 50, 'completo', 25),
    (3, 1, 2, '01:30:03.500', '00:00:03.500', 50, 'completo', 18),
    (3, 4, 3, '01:30:09.800', '00:00:09.800', 50, 'completo', 15),
    (3, 3, 4, '01:30:15.100', '00:00:15.100', 50, 'completo', 12),
    (3, 5, 5, '01:30:30.000', '00:00:30.000', 50, 'completo', 10),
    (3, 6, 6, NULL,           NULL,           20, 'abandono',  0);

-- Resultados carrera GP2
INSERT INTO corre_en (id_sesion, id_piloto, posicion_final, tiempo_total, gap_al_ganador, nro_vueltas_completadas, estado_finalizacion, puntos_obtenidos) VALUES
    (6, 1, 1, '01:35:20.200', '00:00:00.000', 50, 'completo', 25),
    (6, 3, 2, '01:35:22.300', '00:00:02.100', 50, 'completo', 18),
    (6, 2, 3, '01:35:24.900', '00:00:04.700', 50, 'completo', 15),
    (6, 5, 4, '01:35:31.200', '00:00:11.000', 50, 'completo', 12),
    (6, 4, 5, '01:35:39.600', '00:00:19.400', 50, 'completo', 10),
    (6, 6, 6, '01:36:25.200', '00:01:05.000', 50, 'completo',  8);

-- Una penalización de ejemplo (piloto 3, carrera GP1)
INSERT INTO penalizacion (id_penalizacion, tipo, cantidad_segundos, motivo, vuelta_ocurrencia, comisario) VALUES
    (1, 'tiempo_agregado', 5, 'Exceso de límites de pista', 12, 'Comisario Ejemplo');
INSERT INTO penalizado (id_penalizacion, id_sesion, id_piloto) VALUES (1, 3, 3);

-- Con IDs explícitos, hay que sincronizar las secuencias de las columnas IDENTITY
SELECT setval(pg_get_serial_sequence('motor',        'id_motor'),        (SELECT MAX(id_motor)        FROM motor));
SELECT setval(pg_get_serial_sequence('escuderia',    'id_escuderia'),    (SELECT MAX(id_escuderia)    FROM escuderia));
SELECT setval(pg_get_serial_sequence('piloto',       'id_piloto'),       (SELECT MAX(id_piloto)       FROM piloto));
SELECT setval(pg_get_serial_sequence('circuito',     'id_circuito'),     (SELECT MAX(id_circuito)     FROM circuito));
SELECT setval(pg_get_serial_sequence('gran_premio',  'id_gp'),           (SELECT MAX(id_gp)           FROM gran_premio));
SELECT setval(pg_get_serial_sequence('sesion',       'id_sesion'),       (SELECT MAX(id_sesion)       FROM sesion));
SELECT setval(pg_get_serial_sequence('penalizacion', 'id_penalizacion'), (SELECT MAX(id_penalizacion) FROM penalizacion));
