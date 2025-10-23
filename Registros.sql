-- modelo_droide
call gestion_stock.agregar_modelo('x1', 'terrestre');
call gestion_stock.agregar_modelo('x2', 'terrestre');
call gestion_stock.agregar_modelo('x3', 'aereo');
call gestion_stock.agregar_modelo('x4', 'terrestre');
call gestion_stock.agregar_modelo('x5', 'aereo');
call gestion_stock.agregar_modelo('x6', 'terrestre');
-- modelo
call gestion_stock.crear_modelo('tv24');
call gestion_stock.crear_modelo('tv28');
call gestion_stock.crear_modelo('tv32');
call gestion_stock.crear_modelo('tv40');
call gestion_stock.crear_modelo('tv50');
-- droide
call gestion_stock.agregar_droide('droide 1', 1, 1);
call gestion_stock.agregar_droide('droide 2', 1, 2);
call gestion_stock.agregar_droide('droide 3', 1, 1);
call gestion_stock.agregar_droide('droide 4', 1, 1);
call gestion_stock.agregar_droide('droide 5', 1, 3);
call gestion_stock.agregar_droide('droide 6', 1, 4);
call gestion_stock.agregar_droide('droide 7', 1, 2);
-- ubicacion
call gestion_stock.crear_ubicacion(1, 7, 2, 0, 'Zona 1');
call gestion_stock.crear_ubicacion(2, 9, 7, 0, 'Zona 2');
call gestion_stock.crear_ubicacion(3, 3, 7, 4, 'Zona 3');
call gestion_stock.crear_ubicacion(4, 1, 5, 1, 'Zona 4');
call gestion_stock.crear_ubicacion(5, 2, 8, 3, 'Zona 5');
call gestion_stock.crear_ubicacion(6, 9, 0, 2, 'Zona 6');
call gestion_stock.crear_ubicacion(7, 6, 5, 0, 'Zona 7');
call gestion_stock.crear_ubicacion(8, 1, 1, 1, 'Zona 8');
call gestion_stock.crear_ubicacion(9, 6, 3, 2, 'Zona 9');
call gestion_stock.crear_ubicacion(10, 8, 3, 0, 'Zona 10');

call gestion_stock.obtener_ubicaciones();
-- producto
call gestion_stock.crear_producto(1, 'placas main', 100, 1);
call gestion_stock.crear_producto(2, 'placas fuente', 100, 1);
call gestion_stock.crear_producto(3, 'placas main', 100, 2);
call gestion_stock.crear_producto(4, 'placas fuente', 100, 2);
call gestion_stock.crear_producto(5, 'placas main', 100, 3);
call gestion_stock.crear_producto(6, 'placas fuente', 100, 3);
call gestion_stock.crear_producto(7, 'placas main', 100, 4);
call gestion_stock.crear_producto(8, 'placas fuente', 100, 4);
call gestion_stock.crear_producto(9, 'placas main', 100, 5);
call gestion_stock.crear_producto(10, 'placas fuente', 100, 5);

call gestion_stock.obtener_productos();
-- producto y modelo
call gestion_stock.vincular_producto_modelo(1, 1);
call gestion_stock.vincular_producto_modelo(2, 1);
call gestion_stock.vincular_producto_modelo(3, 2);
call gestion_stock.vincular_producto_modelo(4, 2);
call gestion_stock.vincular_producto_modelo(5, 3);
call gestion_stock.vincular_producto_modelo(6, 3);
call gestion_stock.vincular_producto_modelo(7, 4);
call gestion_stock.vincular_producto_modelo(8, 4);
call gestion_stock.vincular_producto_modelo(9, 5);
call gestion_stock.vincular_producto_modelo(10, 5);
-- pedido
call gestion_stock.crear_pedido_restar_sumar(1, 2, 1);
call gestion_stock.crear_pedido_restar_sumar(2, 6, 0);
-- funcion verificar_stock en ejecucion(cancela la operacion por pedir mas que lo que existe en stock)
-- call gestion_stock.pr_crear_pedido_restar_sumar(3, 6, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(4, 50, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(5, 8, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(6, 40, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(7, 20, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(8, 15, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(5, 6, 1);
call gestion_stock.pr_crear_pedido_restar_sumar(2, 20, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(3, 6, 1);
call gestion_stock.pr_crear_pedido_restar_sumar(6, 5, 1);
call gestion_stock.pr_crear_pedido_restar_sumar(8, 20, 1);
call gestion_stock.pr_crear_pedido_restar_sumar(10, 30, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(9, 2, 0);

call gestion_stock.pr_crear_pedido_restar_sumar(2, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(2, 2, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(5, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(2, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(2, 3, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(2, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(8, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(1, 2, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(7, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(1, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(1, 4, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(1, 3, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(9, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(1, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(4, 1, 0);
call gestion_stock.pr_crear_pedido_restar_sumar(10, 1, 0);
-- para deshacer un pedido

-- call gestion_stock.deshacer_pedido_autoasignado(12);

-- piezas_reparacion_droide
call gestion_stock.nueva_pieza('motor terrestre', 9, 2015, 50);
call gestion_stock.nueva_pieza('motor aereo', 9, 2018, 50);
call gestion_stock.nueva_pieza('rueda', 9, 2015, 50);
call gestion_stock.nueva_pieza('aspa', 9, 2015, 50);
call gestion_stock.nueva_pieza('motor terrestre', 8, 2021, 21);
call gestion_stock.nueva_pieza('motor aereo', 7, 2021, 10);
call gestion_stock.nueva_pieza('aspa', 5, 2025, 10);
call gestion_stock.nueva_pieza('bateria 1', 5, 2020, 10);
call gestion_stock.nueva_pieza('bateria 2', 5, 2025, 20);

call gestion_stock.modificar_droide(12, 0);
call gestion_stock.agregar_reparacion_droide(10, 1, 'motor descompuesto, reemplazo');
call gestion_stock.modificar_droide(12, 1);

-- auditoria y auditores
call gestion_stock.agregar_auditor('juan', 'perez');
call gestion_stock.agregar_auditor('leonardo', 'rodriguez');
call gestion_stock.agregar_auditor('juana', 'de arco');

CALL registrar_auditoria(1,JSON_OBJECT('resultado_auditoria', 'sin faltantes'));

-- reparacion de drones
call gestion_stock.modificar_droide(8, 0);
call gestion_stock.modificar_droide(9, 0);
call gestion_stock.modificar_droide(11, 0);
call gestion_stock.modificar_droide(14, 0);
call gestion_stock.agregar_reparacion_droide(8, 8, 'bateria agotada, reemplazo');
call gestion_stock.agregar_reparacion_droide(9, 8, 'bateria agotada, reemplazo');
call gestion_stock.agregar_reparacion_droide(10, 8, 'bateria agotada, reemplazo');
call gestion_stock.agregar_reparacion_droide(11, 8, 'bateria agotada, reemplazo');
call gestion_stock.agregar_reparacion_droide(12, 8, 'bateria agotada, reemplazo');
call gestion_stock.agregar_reparacion_droide(14, 8, 'bateria agotada, reemplazo');
call gestion_stock.modificar_droide(8, 1);
call gestion_stock.modificar_droide(9, 1);
call gestion_stock.modificar_droide(10, 1);
call gestion_stock.modificar_droide(11, 1);
call gestion_stock.modificar_droide(12, 1);
call gestion_stock.modificar_droide(14, 1);
call gestion_stock.agregar_droide('droide provicional 1', 1, 15);

-- agregar direcciones
CALL pr_gestionar_direccion('Calle Falsa', 123);
CALL pr_gestionar_direccion('San Martín', 250);
CALL pr_gestionar_direccion('Belgrano', 1080);
CALL pr_gestionar_direccion('Mitre', 456);
CALL pr_gestionar_direccion('Sarmiento', 980);
CALL pr_gestionar_direccion('Rivadavia', 1520);
CALL pr_gestionar_direccion('Urquiza', 875);
CALL pr_gestionar_direccion('Independencia', 642);
CALL pr_gestionar_direccion('Alsina', 233);
CALL pr_gestionar_direccion('25 de Mayo', 300);
CALL pr_gestionar_direccion('9 de Julio', 999);
CALL pr_gestionar_direccion('Lavalle', 120);
CALL pr_gestionar_direccion('Maipú', 1540);
CALL pr_gestionar_direccion('Pueyrredón', 890);
CALL pr_gestionar_direccion('Roca', 340);
CALL pr_gestionar_direccion('Güemes', 785);
CALL pr_gestionar_direccion('Viamonte', 212);
CALL pr_gestionar_direccion('Italia', 1320);
CALL pr_gestionar_direccion('España', 760);
CALL pr_gestionar_direccion('Chile', 430);
CALL pr_gestionar_direccion('Francia', 188);
CALL pr_gestionar_direccion('Brasil', 520);
CALL pr_gestionar_direccion('Bolivia', 220);
CALL pr_gestionar_direccion('México', 980);
CALL pr_gestionar_direccion('Paraguay', 650);
CALL pr_gestionar_direccion('Colombia', 1110);
CALL pr_gestionar_direccion('Perú', 870);
CALL pr_gestionar_direccion('Uruguay', 310);
CALL pr_gestionar_direccion('Venezuela', 1440);
CALL pr_gestionar_direccion('Av. Siempre Viva', 742);

-- pedidos por persona, pedido y direccion

CALL gestion_stock.registrar_persona_pedido('Carlos', 'Ramírez', 'TechNova SA', '20345678901', 1, 'AB123CD',2);
CALL gestion_stock.registrar_persona_pedido('María', 'Gómez', 'TransLog SRL', '27456789012', 2, 'CD456EF',3);
CALL gestion_stock.registrar_persona_pedido('Julián', 'Pérez', 'FutureSoft', '20333444556', 3, 'EF789GH',4);
CALL gestion_stock.registrar_persona_pedido('Lucía', 'Fernández', 'MegaBuild SA', '27322110998', 4, 'GH101IJ',5);
CALL gestion_stock.registrar_persona_pedido('Andrés', 'López', 'ElectroSystems', '20399087654', 5, 'IJ112KL',6);
CALL gestion_stock.registrar_persona_pedido('Sofía', 'Martínez', 'LogiCorp', '27345678976', 6, 'KL223MN',7);
CALL gestion_stock.registrar_persona_pedido('Federico', 'García', 'AutoParts SRL', '20456712309', 7, 'MN334OP',8);
CALL gestion_stock.registrar_persona_pedido('Paula', 'Ruiz', 'SteelWorks', '27322176543', 8, 'OP445QR',9);
CALL gestion_stock.registrar_persona_pedido('Nicolás', 'Torres', 'BuildPro SA', '20433322111', 9, 'QR556ST',10);
CALL gestion_stock.registrar_persona_pedido('Camila', 'Alvarez', 'TechVision', '27312398765', 10, 'ST667UV',11);
call gestion_stock.registrar_persona_pedido('atila', 'el huno', '', '332211', 11, '',12);
call gestion_stock.registrar_persona_pedido('genghis', 'khan', '', '24321105', 12, '',13);
call gestion_stock.registrar_persona_pedido('william', 'wallace', '', '33444555', 13, '',14);
CALL gestion_stock.registrar_persona_pedido('Martina', 'Suárez', 'NextGenTech', '27377788990', 14, 'AB101BC',15);
CALL gestion_stock.registrar_persona_pedido('Matías', 'Santos', 'ProMove SA', '20432176555', 15, 'BC212CD',16);
CALL gestion_stock.registrar_persona_pedido('Florencia', 'Ramos', 'MaxIndustries', '27398712345', 16, 'CD323DE',17);
CALL gestion_stock.registrar_persona_pedido('Juan', 'Navarro', 'RoboParts SRL', '20411223344', 17, 'DE434EF',18);
CALL gestion_stock.registrar_persona_pedido('Agustina', 'Morales', 'InfraWorks', '27344332211', 18, 'EF545FG',19);
CALL gestion_stock.registrar_persona_pedido('Leandro', 'Ponce', 'DataLogic', '20455667788', 19, 'FG656GH',20);
CALL gestion_stock.registrar_persona_pedido('Elena', 'Cabrera', 'AutoMotion', '27333445566', 20, 'GH767HI',21);
CALL gestion_stock.registrar_persona_pedido('Rodrigo', 'Medina', 'SoftTech', '20411224567', 21, 'HI878IJ',22);
CALL gestion_stock.registrar_persona_pedido('Julieta', 'Benítez', 'AI Logistics', '27399887766', 22, 'IJ989KL',1);
CALL gestion_stock.registrar_persona_pedido('Esteba', 'Rios', 'Paladin services', '27394877766', 23, 'RCI145',28);
call gestion_stock.registrar_persona_pedido('atila', 'el huno', '', '332211', 24, '',12);
call gestion_stock.registrar_persona_pedido('genghis', 'khan', '', '24321105', 25, '',13);
call gestion_stock.registrar_persona_pedido('william', 'wallace', '', '33444555', 26, '',14);
CALL gestion_stock.registrar_persona_pedido('Martina', 'Suárez', 'NextGenTech', '27377788990', 27, 'AB101BC',15);
CALL gestion_stock.registrar_persona_pedido('Matías', 'Santos', 'ProMove SA', '20432176555', 28, 'BC212CD',16);
CALL gestion_stock.registrar_persona_pedido('Florencia', 'Ramos', 'MaxIndustries', '27398712345', 29, 'CD323DE',17);
CALL gestion_stock.registrar_persona_pedido('Juan', 'Navarro', 'RoboParts SRL', '20411223344', 30, 'DE434EF',18);
CALL gestion_stock.registrar_persona_pedido('Agustina', 'Morales', 'InfraWorks', '27344332211', 31, 'EF545FG',19);

-- ver detalle de los pedidos
select * from vista_persona_pedido_detalle;
-- ver las piezas y modelos de droides que fallan
select * from vw_piezas_modelos_droides_failure;
-- ver el stock
select * from vw_stock;
-- obtener direccion del remito del pedido
select * from vw_archivos_pedidos;
-- reporte de todos los movimientos
select * from vw_reporte;