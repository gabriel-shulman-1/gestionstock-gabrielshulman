USE gestion_stock;

INSERT INTO ubicacion (id, X, Y, Z, descripcion) VALUES
(1, 10, 5, 2, 'Depósito principal'),
(2, 8, 3, 1, 'Sector A - repuestos pequeños'),
(3, 12, 6, 4, 'Almacén intermedio'),
(4, 15, 2, 1, 'Zona de control de calidad'),
(5, 9, 4, 2, 'Depósito secundario');

INSERT INTO productos (name, qty, ubicacion_pieza) VALUES
('Sensor óptico', 50, 1),
('Módulo de energía', 20, 2),
('Chip de control', 35, 3),
('Brazo articulado', 15, 4),
('Motor servo', 40, 5);

INSERT INTO droide (name, fecha_servicio, en_servicio, falla_descripcion, falla_hora) VALUES
('R2-D2', NOW(), 1, NULL, NULL),
('C-3PO', NOW(), 1, NULL, NULL),
('BB-8', NOW(), 0, 'Falla en sensor giroscópico', NOW()),
('K-2SO', NOW(), 1, NULL, NULL),
('IG-88', NOW(), 0, 'Desincronización en brazo derecho', NOW());

 -- ingresar a lo ultimo ya que se relaciona con el resto.
INSERT INTO pedido (pieza, cantidad, droideAsignado, tipo_movimiento, tiempo) VALUES
(1, 5, 1, 0, NOW()),
(2, 3, 2, 1, NOW()),
(3, 10, 3, 0, NOW()),
(4, 2, 4, 1, NOW()),
(5, 8, 5, 0, NOW());

 -- la tabla log_movimientos se carga con el movimiento de las tablas anteriores(trigger)