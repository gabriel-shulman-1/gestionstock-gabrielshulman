CREATE SCHEMA IF NOT EXISTS `gestion_stock` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE gestion_stock;

CREATE TABLE IF NOT EXISTS ubicacion (
  `id` INT NOT NULL,
  `X` TINYINT NULL DEFAULT NULL,
  `Y` TINYINT NULL DEFAULT NULL,
  `Z` TINYINT NULL DEFAULT NULL,
  `descripcion` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS productos (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `qty` INT NOT NULL DEFAULT '0',
  `ubicacion_pieza` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `fk_productos_ubicacion`
    FOREIGN KEY (`ubicacion_pieza`)
    REFERENCES ubicacion (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS droide (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `fecha_servicio` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  `en_servicio` TINYINT NOT NULL,
  `falla_descripcion` VARCHAR(255) NULL DEFAULT NULL,
  `falla_hora` TIMESTAMP,
  PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS pedido (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pieza` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `droideAsignado` INT NULL DEFAULT NULL,
  `tipo_movimiento` TINYINT NOT NULL,
  `tiempo` TIMESTAMP,
  PRIMARY KEY (`id`),
  CONSTRAINT `pedido_ibfk_1`
    FOREIGN KEY (`pieza`)
    REFERENCES productos (`id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `pedido_ibfk_2`
    FOREIGN KEY (`droideAsignado`)
    REFERENCES droide (`id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE);

CREATE TABLE IF NOT EXISTS carga (
  `patente` INT NOT NULL,
  `remito` INT NOT NULL,
  `pieza` INT NOT NULL,
  `qty` INT NOT NULL,
  `llegada` TIMESTAMP,
  PRIMARY KEY (`patente`),
  CONSTRAINT `fk_remito`
    FOREIGN KEY (`remito`)
    REFERENCES pedido (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pieza`
    FOREIGN KEY (`pieza`)
    REFERENCES productos (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

CREATE TABLE IF NOT EXISTS log_movimientos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  tabla_afectada VARCHAR(100) NOT NULL,
  operacion VARCHAR(50) NOT NULL, -- (INSERT, UPDATE, DELETE)
  descripcion TEXT,
  fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Vistas

CREATE OR REPLACE VIEW vw_incidente AS
    SELECT 
        d.id AS droide_id,
        d.name AS droide_nombre,
        d.fecha_servicio,
        d.en_servicio,
        d.falla_descripcion,
        d.falla_hora,
        p.id AS pedido_id,
        p.pieza,
        p.cantidad,
        p.tipo_movimiento
    FROM
        droide d
            LEFT JOIN
        pedido p ON d.id = p.droideAsignado
    WHERE
        d.en_servicio = 2;
        
CREATE  OR REPLACE VIEW vw_retiro_stock AS
    SELECT 
        p.id AS remito, p.pieza AS pieza, p.cantidad AS qty
    FROM
        pedido p
    WHERE
        tipo_movimiento = 0;
        
CREATE  OR REPLACE VIEW vw_reposicion_stock AS
    SELECT 
        p.id AS remito, p.pieza AS pieza, p.cantidad AS qty
    FROM
        pedido p
    WHERE
        tipo_movimiento = 1;

CREATE OR REPLACE VIEW vw_consultar_stock AS
    SELECT 
        pr.name AS pieza,
        pr.qty AS cantidad,
        pr.ubicacion_pieza AS ubicacion_id,
        u.x AS x,
        u.y AS y,
        u.z AS z
    FROM
        productos pr
            LEFT JOIN
        ubicacion u ON pr.ubicacion_pieza = u.id;

CREATE OR REPLACE VIEW vw_reposicion_mensual AS
    SELECT 
        p.id AS remito,
        p.pieza AS pieza,
        p.cantidad AS qty,
        c.patente AS patente
    FROM
        pedido p
            LEFT JOIN
        carga c ON p.id = c.remito
    WHERE
        YEAR(p.tiempo) = YEAR(CURDATE())
            AND MONTH(p.tiempo) = MONTH(CURDATE());

-- Procedimientos

DELIMITER $$

CREATE PROCEDURE crear_droide (
    IN p_name VARCHAR(100)
)
BEGIN
	DECLARE v_mensaje VARCHAR(500);
    INSERT INTO droide (name, en_servicio)
    VALUES (p_name, 1);
    SET v_mensaje = mensaje_personalizado('success',CONCAT('Droide ', p_name, ' agregado al sistema.'));
END$$

CREATE PROCEDURE editar_droide_falla (
    IN p_id INT,
    IN p_falla_descripcion VARCHAR(255)
)
BEGIN
	DECLARE v_mensaje VARCHAR(500);
    UPDATE droide
    SET 
        en_servicio = 0,
        falla_descripcion = p_falla_descripcion,
        falla_hora = NOW()
    WHERE id = p_id;
    SET v_mensaje = mensaje_personalizado('alert',CONCAT('Droide ', p_name, ' averiado.'));
END$$

CREATE PROCEDURE crear_ubicacion (
	IN p_id INT,
    IN p_X TINYINT,
    IN p_Y TINYINT,
    IN p_Z TINYINT,
    IN p_descripcion VARCHAR(100)
)
BEGIN
	DECLARE v_mensaje VARCHAR(500);
    INSERT INTO ubicacion (id, X, Y, Z, descripcion)
    VALUES (p_id, p_X, p_Y, p_Z, p_descripcion);
    SET v_mensaje = mensaje_personalizado('success',CONCAT('Ubicación ', p_X, p_Y, p_Z, ' creada correctamente'));
END$$

CREATE PROCEDURE obtener_ubicaciones ()
BEGIN
    SELECT * FROM ubicacion ORDER BY id ASC;
END$$

CREATE PROCEDURE crear_producto (
    IN p_name VARCHAR(100),
    IN p_qty INT,
    IN p_ubicacion_id INT
)
BEGIN
	DECLARE v_mensaje VARCHAR(500);
    INSERT INTO productos (name, qty, ubicacion_pieza)
    VALUES (p_name, p_qty, p_ubicacion_id);
    SET v_mensaje = mensaje_personalizado('success',CONCAT('Producto ', name, ' creada correctamente'));
    SELECT LAST_INSERT_ID() AS nuevo_producto_id;
END$$

CREATE PROCEDURE obtener_productos()
BEGIN
    SELECT 
        *
    FROM productos p
    LEFT JOIN ubicacion u ON p.ubicacion_pieza = u.id
    ORDER BY p.id ASC;
END$$

CREATE PROCEDURE editar_producto (
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
		CONCAT('Producto ', p_id, ' actualizado correctamente.')
    );
END$$

CREATE PROCEDURE obtener_pedido_por_id (
    IN p_pedido_id INT
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pedido WHERE id = p_pedido_id) THEN
        SELECT CONCAT('No existe un pedido con el ID ', p_pedido_id) AS mensaje;
    ELSE
        SELECT 
            p.id,
            p.pieza,
            pr.name AS nombre_pieza,
            p.cantidad,
            p.droideAsignado,
            d.name AS droide_nombre,
            p.tipo_movimiento,
            p.tiempo
        FROM pedido p
        LEFT JOIN productos pr ON p.pieza = pr.id
        LEFT JOIN droide d ON p.droideAsignado = d.id
        WHERE p.id = p_pedido_id;
    END IF;
END$$

CREATE PROCEDURE crear_carga(
    IN p_patente INT,
    IN p_remito INT,
    IN p_pieza INT,
    IN p_qty INT
)
BEGIN
    DECLARE v_exist_pedido INT;
    DECLARE v_mensaje VARCHAR(500);
    SELECT COUNT(*) INTO v_exist_pedido FROM pedido WHERE id = p_remito;
    IF v_exist_pedido = 0 THEN
        SET v_mensaje = mensaje_personalizado('error', CONCAT('El pedido (remito) ', p_remito, ' no existe.'));
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = v_mensaje;
    ELSE
        INSERT INTO carga (patente, remito, pieza, qty, llegada)
        VALUES (p_patente, p_remito, p_pieza, p_qty, NOW());
        SET v_mensaje = mensaje_personalizado('success', CONCAT('Carga registrada para el remito ', p_remito, ' con pieza ', p_pieza, '.'));
        INSERT INTO log_movimientos (tabla_afectada, tipo_accion, descripcion)
        VALUES ('carga', 'INSERT', v_mensaje);
    END IF;
END$$

CREATE PROCEDURE crear_pedido_restar_sumar(
    IN p_pieza INT,
    IN p_cantidad INT,
    IN p_droideAsignado INT,
    IN p_tipo_movimiento TINYINT
)
BEGIN
    DECLARE v_stock_actual INT;
    SELECT qty INTO v_stock_actual FROM productos WHERE id = p_pieza;
    IF v_stock_actual IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El producto no existe';
    END IF;
    IF p_tipo_movimiento = 0 AND v_stock_actual < p_cantidad THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock insuficiente para restar';
    END IF;
    INSERT INTO pedido (pieza, cantidad, droideAsignado, tipo_movimiento, tiempo)
    VALUES (p_pieza, p_cantidad, p_droideAsignado, p_tipo_movimiento, NOW());
    IF p_tipo_movimiento = 0 THEN
        UPDATE productos
        SET qty = qty - p_cantidad
        WHERE id = p_pieza;
    ELSEIF p_tipo_movimiento = 1 THEN
        UPDATE productos
        SET qty = qty + p_cantidad
        WHERE id = p_pieza;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de movimiento inválido (usar 0 o 1)';
    END IF;
END $$

CREATE PROCEDURE eliminar_pedido(
    IN p_id INT
)
BEGIN
	DECLARE v_mensaje VARCHAR(500);
    DECLARE v_pieza INT;
    DECLARE v_cantidad INT;
    DECLARE v_tipo_movimiento TINYINT;
    SELECT pieza, cantidad, tipo_movimiento
    INTO v_pieza, v_cantidad, v_tipo_movimiento
    FROM pedido
    WHERE id = p_id;
    IF v_pieza IS NULL THEN
        SET v_mensaje = mensaje_personalizado('ERROR', 'El pedido no existe.');
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = v_mensaje;
    ELSE
        IF v_tipo_movimiento = 1 THEN
            UPDATE productos
            SET qty = qty - v_cantidad
            WHERE id = v_pieza;
        ELSEIF v_tipo_movimiento = 0 THEN
            UPDATE productos
            SET qty = qty + v_cantidad
            WHERE id = v_pieza;
        END IF;
        DELETE FROM pedido WHERE id = p_id;
        SET v_mensaje = mensaje_personalizado('success', 'pedido eliminado');
	END IF;
END$$

DELIMITER ;

 -- triggers

DELIMITER $$
 
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
 
CREATE TRIGGER trg_droide_en_servicio_update
AFTER UPDATE ON droide
FOR EACH ROW
BEGIN
    IF OLD.en_servicio = 1 AND NEW.en_servicio = 0 THEN
        INSERT INTO log_movimientos (tabla_afectada, operacion, descripcion)
        VALUES (
            'droide',
            'UPDATE',
            CONCAT(
                'Droide fuera de servicio: ID=', NEW.id,
                ', Nombre=', NEW.name,
                ', Descripción de falla=', NEW.falla_descripcion,
                ', Hora de falla=', NEW.falla_hora
            )
        );
    END IF;
END$$
 
CREATE TRIGGER trg_pedido_stock_update
AFTER INSERT ON pedido
FOR EACH ROW
BEGIN
    IF NEW.tipo_movimiento = 1 THEN
        UPDATE productos
        SET qty = qty + NEW.cantidad
        WHERE id = NEW.pieza;

        INSERT INTO log_movimientos (tabla_afectada, operacion, descripcion)
        VALUES (
            'productos',
            'STOCK +',
            CONCAT('Se sumaron ', NEW.cantidad, ' unidades al producto ID=', NEW.pieza, ' por pedido ID=', NEW.id)
        );
    ELSEIF NEW.tipo_movimiento = 0 THEN
        UPDATE productos
        SET qty = qty - NEW.cantidad
        WHERE id = NEW.pieza;
        INSERT INTO log_movimientos (tabla_afectada, operacion, descripcion)
        VALUES (
            'productos',
            'STOCK -',
            CONCAT('Se restaron ', NEW.cantidad, ' unidades al producto ID=', NEW.pieza, ' por pedido ID=', NEW.id)
        );
    END IF;
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
 
DELIMITER ;

 -- functions
 
DELIMITER $$

CREATE FUNCTION mensaje_personalizado(p_tipo VARCHAR(20), p_texto VARCHAR(255))
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
