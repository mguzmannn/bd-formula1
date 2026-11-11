-- =====================================================================
-- Consultas de ejemplo sobre el modelo (cambiar 2026 por la temporada deseada)
-- =====================================================================

-- 1) Clasificación parcial de pilotos: posición, puntos y diferencia con el líder
WITH puntos AS (
    SELECT cp.id_piloto,
           COALESCE(SUM(ce.puntos_obtenidos), 0) AS puntos
    FROM compite_para cp
    LEFT JOIN gran_premio gp ON gp.anio = cp.anio
    LEFT JOIN sesion s       ON s.id_gp = gp.id_gp
    LEFT JOIN corre_en ce    ON ce.id_sesion = s.id_sesion
                            AND ce.id_piloto = cp.id_piloto
    WHERE cp.anio = 2026
    GROUP BY cp.id_piloto
)
SELECT RANK() OVER (ORDER BY pt.puntos DESC)  AS posicion,
       pi.nombre                              AS piloto,
       pt.puntos,
       MAX(pt.puntos) OVER () - pt.puntos     AS diferencia_con_lider
FROM puntos pt
JOIN piloto pi ON pi.id_piloto = pt.id_piloto
ORDER BY posicion, piloto;

-- 2) Clasificación parcial de constructores (suma de los dos pilotos de cada escudería)
WITH puntos AS (
    SELECT cp.id_escuderia,
           COALESCE(SUM(ce.puntos_obtenidos), 0) AS puntos
    FROM compite_para cp
    LEFT JOIN gran_premio gp ON gp.anio = cp.anio
    LEFT JOIN sesion s       ON s.id_gp = gp.id_gp
    LEFT JOIN corre_en ce    ON ce.id_sesion = s.id_sesion
                            AND ce.id_piloto = cp.id_piloto
    WHERE cp.anio = 2026
    GROUP BY cp.id_escuderia
)
SELECT RANK() OVER (ORDER BY pt.puntos DESC)  AS posicion,
       e.nombre                               AS escuderia,
       pt.puntos,
       MAX(pt.puntos) OVER () - pt.puntos     AS diferencia_con_lider
FROM puntos pt
JOIN escuderia e ON e.id_escuderia = pt.id_escuderia
ORDER BY posicion, escuderia;

-- 3) Resultado de una carrera, con la escudería con la que compitió cada piloto
SELECT ce.posicion_final,
       pi.nombre              AS piloto,
       e.nombre               AS escuderia,
       ce.estado_finalizacion,
       ce.nro_vueltas_completadas,
       ce.gap_al_ganador,
       ce.puntos_obtenidos
FROM corre_en ce
JOIN sesion s        ON s.id_sesion = ce.id_sesion
JOIN gran_premio gp  ON gp.id_gp = s.id_gp
JOIN piloto pi       ON pi.id_piloto = ce.id_piloto
JOIN compite_para cp ON cp.id_piloto = ce.id_piloto AND cp.anio = gp.anio
JOIN escuderia e     ON e.id_escuderia = cp.id_escuderia
WHERE gp.nombre_oficial = 'Gran Premio de Argentina'
  AND gp.anio = 2026
ORDER BY ce.posicion_final;

-- 4) Historial de escuderías de cada piloto
SELECT pi.nombre AS piloto, cp.anio, e.nombre AS escuderia, cp.nro_piloto
FROM compite_para cp
JOIN piloto pi   ON pi.id_piloto = cp.id_piloto
JOIN escuderia e ON e.id_escuderia = cp.id_escuderia
ORDER BY pi.nombre, cp.anio;

-- 5) Penalizaciones aplicadas por Gran Premio
SELECT gp.nombre_oficial, pi.nombre AS piloto, pe.tipo, pe.cantidad_segundos,
       pe.vuelta_ocurrencia, pe.motivo, pe.comisario
FROM penalizado pd
JOIN penalizacion pe ON pe.id_penalizacion = pd.id_penalizacion
JOIN sesion s        ON s.id_sesion = pd.id_sesion
JOIN gran_premio gp  ON gp.id_gp = s.id_gp
JOIN piloto pi       ON pi.id_piloto = pd.id_piloto
ORDER BY gp.fecha, pe.vuelta_ocurrencia;
