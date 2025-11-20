CREATE SCHEMA IF NOT EXISTS `gestion_stock1` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE gestion_stock1;

CREATE TABLE IF NOT EXISTS ubicacion (
  id INT NOT NULL,
  X TINYINT NULL,
  Y TINYINT NULL,
  Z TINYINT NULL,
  descripcion VARCHAR(100) NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS productos (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  qty INT NOT NULL DEFAULT 0,
  ubicacion_pieza INT NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_productos_ubicacion
    FOREIGN KEY (ubicacion_pieza)
    REFERENCES ubicacion (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS modelo (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL UNIQUE,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS producto_modelo (
  id INT AUTO_INCREMENT PRIMARY KEY,
  producto_id INT NOT NULL,
  modelo_id INT NOT NULL,
  UNIQUE (producto_id, modelo_id),
  CONSTRAINT fk_producto_modelo_producto
    FOREIGN KEY (producto_id)
    REFERENCES productos (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_producto_modelo_modelo
    FOREIGN KEY (modelo_id)
    REFERENCES modelo (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS modelo_droide (
  id INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  tipo ENUM('terrestre', 'aereo') NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS droide (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  fecha_servicio TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  en_servicio TINYINT NOT NULL,
  modelo_id INT NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk_droide_modelo
    FOREIGN KEY (modelo_id)
    REFERENCES modelo_droide (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS pedido (
  id INT NOT NULL AUTO_INCREMENT,
  pieza INT NOT NULL,
  cantidad INT NOT NULL,
  droideAsignado INT NULL,
  tipo_movimiento TINYINT NOT NULL,
  tiempo TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  CONSTRAINT pedido_ibfk_1
    FOREIGN KEY (pieza)
    REFERENCES productos (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT pedido_ibfk_2
    FOREIGN KEY (droideAsignado)
    REFERENCES droide (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS log_movimientos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tabla_afectada VARCHAR(100) NOT NULL,
  operacion VARCHAR(50) NOT NULL,
  descripcion TEXT,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS direccion (
  id INT AUTO_INCREMENT PRIMARY KEY,
  calle VARCHAR(100) NOT NULL,
  altura INT NOT NULL
);

CREATE TABLE IF NOT EXISTS persona_pedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  empresa VARCHAR(150),
  dni_cuil VARCHAR(20) NOT NULL,
  pedido_id INT NOT NULL,
  patente VARCHAR(20),
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  direccion_id INT NULL,
  CONSTRAINT fk_persona_pedido
    FOREIGN KEY (pedido_id)
    REFERENCES pedido (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_persona_direccion
    FOREIGN KEY (direccion_id)
    REFERENCES direccion (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS piezas_reparacion_droide (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre_pieza VARCHAR(100) NOT NULL,
  partida_mes TINYINT NOT NULL,
  partida_anio YEAR NOT NULL,
  cantidad INT NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS historial_droides (
  id INT AUTO_INCREMENT PRIMARY KEY,
  droide_id INT NOT NULL,
  nombre_droide VARCHAR(100) NOT NULL,
  fecha_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  descripcion TEXT NOT NULL,
  pieza_usada_id INT NULL,
  pieza_usada_nombre VARCHAR(100),
  en_servicio TINYINT(1) NOT NULL,
  CONSTRAINT fk_historial_droide
    FOREIGN KEY (droide_id)
    REFERENCES droide (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_historial_pieza
    FOREIGN KEY (pieza_usada_id)
    REFERENCES piezas_reparacion_droide (id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS reparacion_droide (
  id INT AUTO_INCREMENT PRIMARY KEY,
  droide_id INT NOT NULL,
  pieza_id INT NOT NULL,
  fecha_reparacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  observacion VARCHAR(255),
  CONSTRAINT fk_reparacion_droide
    FOREIGN KEY (droide_id)
    REFERENCES droide (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_reparacion_pieza
    FOREIGN KEY (pieza_id)
    REFERENCES piezas_reparacion_droide (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS archivo_pedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  persona_pedido_id INT NOT NULL,
  nombre_archivo VARCHAR(255) NOT NULL,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  datos_pedido JSON,
  CONSTRAINT fk_archivo_persona_pedido
    FOREIGN KEY (persona_pedido_id)
    REFERENCES persona_pedido (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS auditor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS auditoria (
  id INT AUTO_INCREMENT PRIMARY KEY,
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  detalles JSON NOT NULL,
  auditor_id INT NOT NULL,
  CONSTRAINT fk_auditoria_auditor
    FOREIGN KEY (auditor_id)
    REFERENCES auditor (id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- Vistas

CREATE OR REPLACE VIEW vw_reporte AS
SELECT * 
FROM log_movimientos;

CREATE OR REPLACE VIEW vw_archivos_pedidos AS
SELECT
    a.id,
    CONCAT('/archivos/pedidos/', a.nombre_archivo) AS ruta_archivo
FROM archivo_pedido a;

CREATE OR REPLACE VIEW vw_stock AS
SELECT
    p.id AS producto_id,
    p.name AS nombre_producto,
    p.qty,
    p.ubicacion_pieza,
    u.id AS ubicacion_id
FROM productos p
LEFT JOIN ubicacion u ON p.ubicacion_pieza = u.id;

CREATE OR REPLACE VIEW vw_persona_pedido_detalle AS
SELECT 
    pp.id AS persona_pedido_id,
    pp.nombre AS nombre_persona,
    pp.apellido AS apellido_persona,
    pp.empresa,
    pp.dni_cuil,
    pp.patente,
    pp.fecha_registro AS fecha_persona_pedido,
    p.id AS pedido_id,
    p.cantidad,
    p.tipo_movimiento,
    p.tiempo AS fecha_pedido,
    prod.id AS producto_id,
    prod.name AS nombre_producto,
    prod.qty AS stock_actual,
    d.id AS droide_id,
    d.name AS nombre_droide,
    d.en_servicio,
    d.fecha_servicio,
    md.id AS modelo_id,
    md.nombre AS nombre_modelo,
    md.tipo AS tipo_modelo
FROM persona_pedido pp
INNER JOIN pedido p 
    ON pp.pedido_id = p.id
INNER JOIN productos prod 
    ON p.pieza = prod.id
LEFT JOIN droide d 
    ON p.droideAsignado = d.id
LEFT JOIN modelo_droide md 
    ON d.modelo_id = md.id;

CREATE OR REPLACE VIEW vw_piezas_modelos_droides_failure AS
SELECT
    rd.id AS reparacion_id,
    rd.droide_id,
    rd.pieza_id,
    prd.id AS pieza_rep_id,
    prd.nombre_pieza,
    prd.partida_mes,
    prd.partida_anio,
    d.id AS droide_n_id,
    d.name AS nombre_droide,
    d.fecha_servicio,
    d.modelo_id,
    md.id AS modelo_n_id,
    md.nombre AS nombre_modelo,
    md.tipo
FROM reparacion_droide rd
INNER JOIN piezas_reparacion_droide prd ON rd.pieza_id = prd.id
INNER JOIN droide d ON rd.droide_id = d.id
INNER JOIN modelo_droide md ON d.modelo_id = md.id;


-- Procedimientos

DELIMITER $$

-- ubicacion y productos

DELIMITER $$

CREATE PROCEDURE pr_crear_ubicacion (
	IN p_id INT,
    IN p_X TINYINT,
    IN p_Y TINYINT,
    IN p_Z TINYINT,
    IN p_descripcion VARCHAR(100)
)
BEGIN
    DECLARE v_mensaje VARCHAR(500);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_mensaje = f_mensaje_personalizado(
            'error',
            'No se pudo crear la ubicación. Verifique los datos.'
        );
        SELECT v_mensaje AS mensaje;
    END;
    INSERT INTO ubicacion (id, X, Y, Z, descripcion)
    VALUES (p_id, p_X, p_Y, p_Z, p_descripcion);
    SET v_mensaje = f_mensaje_personalizado(
        'success',
        CONCAT('Ubicación ', p_X, ',', p_Y, ',', p_Z, ' creada correctamente')
    );
    SELECT v_mensaje AS mensaje;
END$$

CREATE PROCEDURE pr_obtener_ubicaciones ()
BEGIN
    SELECT * FROM ubicacion ORDER BY id ASC;
END$$

CREATE PROCEDURE pr_crear_producto (
    IN p_name VARCHAR(100),
    IN p_qty INT,
    IN p_ubicacion_id INT
)
BEGIN
	DECLARE v_mensaje VARCHAR(500);
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    INSERT INTO productos (name, qty, ubicacion_pieza)
    VALUES (p_name, p_qty, p_ubicacion_id);
    SET v_mensaje = f_mensaje_personalizado(
        'success',
        CONCAT('Producto ', p_name, ' creado correctamente')
		);
    SELECT LAST_INSERT_ID() AS nuevo_producto_id, v_mensaje AS mensaje;
END$$

CREATE PROCEDURE pr_obtener_productos()
BEGIN
    SELECT 
        *
    FROM productos p
    LEFT JOIN ubicacion u ON p.ubicacion_pieza = u.id
    ORDER BY p.id ASC;
END$$

CREATE PROCEDURE pr_editar_producto (
    IN p_id INT,
    IN p_name VARCHAR(100),
    IN p_qty INT,
    IN p_ubicacion_id INT
)
BEGIN
    DECLARE v_mensaje VARCHAR(500);
    UPDATE productos
    SET name = p_name,
        qty = p_qty,
        ubicacion_pieza = p_ubicacion_id
    WHERE id = p_id;
    SET v_mensaje = mensaje_personalizado(
		'success',
		CONCAT('Producto ', p_id, ' actualizado correctamente')
    );
    SELECT v_mensaje AS mensaje;
END$$

CREATE PROCEDURE pr_crear_modelo (
    IN p_nombre VARCHAR(100)
)
BEGIN
    DECLARE v_existente INT;
    SELECT COUNT(*) INTO v_existente
    FROM modelo
    WHERE nombre = p_nombre;
    IF v_existente = 0 THEN
        INSERT INTO modelo (nombre)
        VALUES (p_nombre);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El modelo ya existe.';
    END IF;
END$$

CREATE PROCEDURE pr_vincular_producto_modelo (
    IN p_producto_id INT,
    IN p_modelo_id INT
)
BEGIN
    DECLARE v_existente INT;

    SELECT COUNT(*) INTO v_existente
    FROM producto_modelo
    WHERE producto_id = p_producto_id AND modelo_id = p_modelo_id;

    IF v_existente = 0 THEN
        INSERT INTO producto_modelo (producto_id, modelo_id)
        VALUES (p_producto_id, p_modelo_id);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto ya está vinculado a este modelo.';
    END IF;
END$$

-- pedidos

CREATE PROCEDURE pr_crear_pedido_restar_sumar(
    IN p_pieza INT,
    IN p_cantidad INT,
    IN p_tipo_movimiento TINYINT
)
BEGIN
    DECLARE v_droideAsignado INT;
    DECLARE v_stock_ok BOOLEAN;
    SELECT id INTO v_droideAsignado
    FROM droide
    WHERE en_servicio = 1
    ORDER BY RAND()
    LIMIT 1;
    IF v_droideAsignado IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No hay droides disponibles.';
    END IF;
    IF p_tipo_movimiento = 0 THEN
        IF f_verificar_stock_productos(p_pieza, p_cantidad) = FALSE THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Stock insuficiente.';
		END IF;
    END IF;
    INSERT INTO pedido (pieza, cantidad, droideAsignado, tipo_movimiento, tiempo)
    VALUES (p_pieza, p_cantidad, v_droideAsignado, p_tipo_movimiento, NOW());
    IF p_tipo_movimiento = 0 THEN
        UPDATE productos SET qty = qty - p_cantidad WHERE id = p_pieza;
    ELSE
        UPDATE productos SET qty = qty + p_cantidad WHERE id = p_pieza;
    END IF;
END$$

CREATE PROCEDURE pr_deshacer_pedido_autoasignado(
    IN p_pedido_id INT
)
BEGIN
    DECLARE v_pieza INT;
    DECLARE v_cantidad INT;
    DECLARE v_tipo_movimiento TINYINT;

    SELECT pieza, cantidad, tipo_movimiento
    INTO v_pieza, v_cantidad, v_tipo_movimiento
    FROM pedido
    WHERE id = p_pedido_id;
    IF v_pieza IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido no existe.';
    END IF;
    IF v_tipo_movimiento = 1 THEN
        UPDATE productos SET qty = qty - v_cantidad WHERE id = v_pieza;
    ELSE
        UPDATE productos SET qty = qty + v_cantidad WHERE id = v_pieza;
    END IF;
    DELETE FROM pedido WHERE id = p_pedido_id;
END$$

CREATE PROCEDURE pr_gestionar_direccion (
    IN p_calle VARCHAR(100),
    IN p_altura INT
)
BEGIN
    DECLARE v_existente INT;

    SELECT COUNT(*) INTO v_existente
    FROM direccion
    WHERE calle = p_calle AND altura = p_altura;

    IF v_existente = 0 THEN
        INSERT INTO direccion (calle, altura)
        VALUES (p_calle, p_altura);
    END IF;
    SELECT id FROM direccion WHERE calle = p_calle AND altura = p_altura;
END$$

CREATE PROCEDURE pr_registrar_persona_pedido (
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_empresa VARCHAR(150),
    IN p_dni_cuil VARCHAR(20),
    IN p_pedido_id INT,
    IN p_patente VARCHAR(20),
    IN p_direccion_id INT
)
BEGIN
    DECLARE v_pedido_exist INT;

    SELECT COUNT(*) INTO v_pedido_exist
    FROM pedido
    WHERE id = p_pedido_id;
    IF v_pedido_exist = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El pedido no existe.';
    END IF;
    INSERT INTO persona_pedido (nombre, apellido, empresa, dni_cuil, pedido_id, patente, direccion_id)
    VALUES (p_nombre, p_apellido, p_empresa, p_dni_cuil, p_pedido_id, p_patente, p_direccion_id);
END$$

-- droides

CREATE PROCEDURE pr_agregar_droide(
    IN p_name VARCHAR(100),
    IN p_en_servicio TINYINT,
    IN p_modelo_id INT
)
BEGIN
    INSERT INTO droide (name, en_servicio, modelo_id)
    VALUES (p_name, p_en_servicio, p_modelo_id);
END$$

CREATE PROCEDURE pr_agregar_modelo (
	IN p_nombre_modelo VARCHAR(100),
    IN p_tipo ENUM('terrestre', 'aereo')
)
BEGIN
	INSERT INTO modelo_droide (nombre, tipo)
    VALUES (p_nombre_modelo, p_tipo);
END$$

CREATE PROCEDURE pr_nueva_pieza (
    IN nombre_pieza VARCHAR(100),
    IN partida_mes TINYINT,
    IN partida_anio YEAR,
    IN cantidad INT
)
BEGIN
	INSERT INTO piezas_reparacion_droide (nombre_pieza, partida_mes, partida_anio, cantidad)
	VALUES (nombre_pieza, partida_mes, partida_anio, cantidad);
END$$

CREATE PROCEDURE pr_modificar_droide (
    IN p_id INT,
    IN p_en_servicio TINYINT
)
BEGIN
    UPDATE droide
    SET
        en_servicio = p_en_servicio
    WHERE id = p_id;
END$$

CREATE PROCEDURE pr_agregar_reparacion_droide (
    IN p_droide_id INT,
    IN p_pieza_id INT,
    IN p_observacion VARCHAR(255)
)
BEGIN
    INSERT INTO reparacion_droide (
        droide_id,
        pieza_id,
        observacion
    )
    VALUES (
        p_droide_id,
        p_pieza_id,
        p_observacion
    );
END$$

-- auditores

CREATE PROCEDURE pr_agregar_auditor (
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100)
)
BEGIN
    INSERT INTO auditor (nombre, apellido)
    VALUES (p_nombre, p_apellido);
END$$

CREATE PROCEDURE pr_registrar_auditoria (
    IN p_auditor_id INT,
    IN p_detalles JSON
)
BEGIN
    INSERT INTO auditoria (auditor_id, detalles)
    VALUES (p_auditor_id, p_detalles);
END$$

DELIMITER ;

 -- triggers

DELIMITER $$
 
 -- llenar log_movimientos
 
CREATE TRIGGER trg_droide_insert
AFTER INSERT ON droide
FOR EACH ROW
BEGIN
    INSERT INTO log_movimientos (tabla_afectada, operacion, descripcion)
    VALUES (
        'droide',
        'INSERT',
        CONCAT('Nuevo droide agregado: ID=', NEW.id, ', Nombre=', NEW.name, ', En servicio=', NEW.en_servicio)
    );
END$$

CREATE TRIGGER trg_productos_ingresados
AFTER insert ON productos
for each row
begin
INSERT INTO log_movimientos (tabla_afectada, operacion, descripcion)
    VALUES (
        'productos',
        'INSERT',
        CONCAT('Ingreso de producto: ID=', NEW.id, ', Nombre=', NEW.name, ', Cantidad=', NEW.qty)
    );
end$$
 
CREATE TRIGGER trg_log_cambio_en_servicio
AFTER UPDATE ON droide
FOR EACH ROW
BEGIN
    IF OLD.en_servicio <> NEW.en_servicio THEN
        INSERT INTO log_movimientos (tabla_afectada, operacion, descripcion)
        VALUES (
            'droide',
            'UPDATE',
            CONCAT(
                'Droide con ID ',
                NEW.id,
                ' de ',
                OLD.en_servicio,
                ' a ',
                NEW.en_servicio,
                ' el ',
                NOW()
            )
        );
    END IF;
END$$

-- llenar historial_droides

CREATE TRIGGER trg_droide_estado_update
AFTER UPDATE ON droide
FOR EACH ROW
BEGIN
  IF OLD.en_servicio <> NEW.en_servicio THEN
    INSERT INTO historial_droides (
      droide_id,
      nombre_droide,
      descripcion,
      en_servicio
    )
    VALUES (
      NEW.id,
      NEW.name,
      CONCAT('Cambio de estado del droide. Ahora está ', 
             CASE NEW.en_servicio 
               WHEN 1 THEN 'EN SERVICIO' 
               ELSE 'FUERA DE SERVICIO' 
             END),
      NEW.en_servicio
    );
  END IF;
END$$

CREATE TRIGGER trg_reparacion_droide_insert
AFTER INSERT ON reparacion_droide
FOR EACH ROW
BEGIN
  DECLARE v_nombre_droide VARCHAR(100);
  DECLARE v_nombre_pieza VARCHAR(100);
  SELECT name INTO v_nombre_droide 
  FROM droide 
  WHERE id = NEW.droide_id;
  SELECT nombre_pieza INTO v_nombre_pieza 
  FROM piezas_reparacion_droide 
  WHERE id = NEW.pieza_id;
  INSERT INTO historial_droides (
    droide_id,
    nombre_droide,
    descripcion,
    pieza_usada_id,
    pieza_usada_nombre,
    en_servicio
  )
  VALUES (
    NEW.droide_id,
    v_nombre_droide,
    CONCAT('Reparación realizada. Pieza usada: ', v_nombre_pieza, 
           '. Observación: ', IFNULL(NEW.observacion, 'Sin observación.')),
    NEW.pieza_id,
    v_nombre_pieza,
    1
  );
END$$

CREATE TRIGGER trg_pedido_insert
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
  DECLARE v_nombre_droide VARCHAR(100);
  DECLARE v_nombre_pieza VARCHAR(100);

  IF NEW.droideAsignado IS NOT NULL THEN
    SELECT name INTO v_nombre_droide FROM droide WHERE id = NEW.droideAsignado;
    SELECT name INTO v_nombre_pieza FROM productos WHERE id = NEW.pieza;
INSERT INTO historial_droides (
    droide_id,
    nombre_droide,
    descripcion,
    pieza_usada_nombre,
    en_servicio
)
VALUES (
    NEW.droideAsignado,
    v_nombre_droide,
    CONCAT('Pedido registrado...'),
    v_nombre_pieza,
    1
);
  END IF;
END$$

-- llenar archivo_pedido

CREATE TRIGGER trg_persona_pedido_after_insert
AFTER INSERT ON persona_pedido
FOR EACH ROW
BEGIN
    DECLARE v_nombre_archivo VARCHAR(255);
    DECLARE v_json JSON;
    DECLARE v_pieza INT;
    DECLARE v_cantidad INT;
    DECLARE v_droide INT;
    DECLARE v_tipo_movimiento TINYINT;
    DECLARE v_tiempo TIMESTAMP;
    DECLARE v_calle VARCHAR(100);
    DECLARE v_altura INT;
    SELECT p.pieza, p.cantidad, p.droideAsignado, p.tipo_movimiento, p.tiempo
    INTO v_pieza, v_cantidad, v_droide, v_tipo_movimiento, v_tiempo
    FROM pedido p
    WHERE p.id = NEW.pedido_id;
    IF NEW.direccion_id IS NOT NULL THEN
    SELECT d.calle, d.altura
    INTO v_calle, v_altura
    FROM direccion d
    WHERE d.id = NEW.direccion_id;
ELSE
    SET v_calle = NULL;
    SET v_altura = NULL;
END IF;
    SET v_nombre_archivo = CONCAT(
        NEW.nombre, '_',
        NEW.apellido, '_Pedido_',
        NEW.pedido_id, '.pdf'
    );
    SET v_json = JSON_OBJECT(
        'persona', JSON_OBJECT(
            'nombre', NEW.nombre,
            'apellido', NEW.apellido,
            'empresa', NEW.empresa,
            'dni_cuil', NEW.dni_cuil,
            'patente', NEW.patente,
            'fecha_registro', NEW.fecha_registro
        ),
        'direccion', JSON_OBJECT(
            'calle', v_calle,
            'altura', v_altura
        ),
        'pedido', JSON_OBJECT(
            'id', NEW.pedido_id,
            'pieza', v_pieza,
            'cantidad', v_cantidad,
            'droideAsignado', v_droide,
            'tipo_movimiento', v_tipo_movimiento,
            'tiempo', v_tiempo
        )
    );
    INSERT INTO archivo_pedido (persona_pedido_id, nombre_archivo, datos_pedido)
    VALUES (NEW.id, v_nombre_archivo, v_json);
END$$

CREATE TRIGGER trg_auditoria_after_insert
AFTER INSERT ON auditoria
FOR EACH ROW
BEGIN
    INSERT INTO log_movimientos (tabla_afectada, operacion, descripcion)
    VALUES (
        'auditoria',
        'INSERT',
        CONCAT(
            'Nuevo registro de auditoría ID: ', NEW.id,
            ', Auditor ID: ', NEW.auditor_id,
            ', Fecha: ', NEW.fecha_registro,
            ', Detalles: ', NEW.detalles
        )
    );
END$$

DELIMITER ;

 -- functions
 
DELIMITER $$

CREATE FUNCTION f_mensaje_personalizado(p_tipo VARCHAR(20), p_texto VARCHAR(255))
RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
    DECLARE mensaje_final VARCHAR(500);
    SET mensaje_final = CONCAT(
        '[', DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s'), '] ',
        UPPER(p_tipo), ': ',
        p_texto
    );
    RETURN mensaje_final;
END$$

CREATE FUNCTION f_verificar_stock_productos(
    p_producto_id INT,
    p_cantidad INT
)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE v_stock INT;
    SELECT qty INTO v_stock
    FROM productos
    WHERE id = p_producto_id;
    IF v_stock IS NULL THEN
        RETURN FALSE;
    END IF;
    IF v_stock < p_cantidad THEN
        RETURN FALSE;
    END IF;
    RETURN TRUE;
END$$
