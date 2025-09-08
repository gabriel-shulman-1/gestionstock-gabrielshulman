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
        
CREATE  OR REPLACE VIEW vw_pedido_egreso AS
    SELECT 
        p.id AS guia, p.pieza AS pieza, p.cantidad AS qty
    FROM
        pedido p
    WHERE
        p.tipo_movimiento = 1;
        
CREATE  OR REPLACE VIEW vw_reposicion_stock AS
    SELECT 
        p.id AS remito, p.pieza AS pieza, p.cantidad AS qty
    FROM
        pedido p
    WHERE
        tipo_movimiento = 2;

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
