USE [GD1C2021]
GO

IF EXISTS(SELECT SCHEMA_ID FROM sys.schemas WHERE [name] = 'CFJV_TEAM')
BEGIN
	PRINT('ELIMINANDO ESQUEMA EXISTENTE');

	IF OBJECT_ID('[CFJV_TEAM].[FacturaPC]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].FacturaPC

	IF OBJECT_ID('[CFJV_TEAM].[FacturaAccesorio]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].FacturaAccesorio

	IF OBJECT_ID('[CFJV_TEAM].[Factura]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].Factura

	IF OBJECT_ID('[CFJV_TEAM].[CompraPC]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].CompraPC

	IF OBJECT_ID('[CFJV_TEAM].[CompraAccesorio]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].CompraAccesorio

	IF OBJECT_ID('[CFJV_TEAM].[Compra]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].Compra

	IF OBJECT_ID('[CFJV_TEAM].[Cliente]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].Cliente

	IF OBJECT_ID('[CFJV_TEAM].[Sucursal]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].Sucursal

	IF OBJECT_ID('[CFJV_TEAM].[PC]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].PC

	IF OBJECT_ID('[CFJV_TEAM].[DiscoRigido]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].DiscoRigido

	IF OBJECT_ID('[CFJV_TEAM].[MemoriaRAM]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].MemoriaRAM

	IF OBJECT_ID('[CFJV_TEAM].[PlacaVideo]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].PlacaVideo

	IF OBJECT_ID('[CFJV_TEAM].[MicroProcesador]') IS NOT NULL
	DROP TABLE [CFJV_TEAM].MicroProcesador

	IF OBJECT_ID('[CFJV_TEAM].[Gabinete]', 'U') IS NOT NULL
	DROP TABLE [CFJV_TEAM].Gabinete

	IF OBJECT_ID('[CFJV_TEAM].[Accesorio]', 'U') IS NOT NULL
	DROP TABLE [CFJV_TEAM].Accesorio

	IF OBJECT_ID('[CFJV_TEAM].[Fabricante]', 'U') IS NOT NULL
	DROP TABLE [CFJV_TEAM].Fabricante

	DROP SCHEMA CFJV_TEAM
END

EXEC('CREATE SCHEMA CFJV_TEAM authorization dbo');

CREATE TABLE CFJV_TEAM.Fabricante(
	fabricante_id INT PRIMARY KEY IDENTITY(1, 1),
	nombre NVARCHAR(255) NULL,
);
GO

CREATE TABLE CFJV_TEAM.Accesorio(
	accesorio_codigo INT PRIMARY KEY,
	accesorio_descripcion NVARCHAR(255) NOT NULL,
	accesorio_precio DECIMAL(18, 2) NULL,
	fabricante_id INT NULL REFERENCES CFJV_TEAM.Fabricante
);

CREATE TABLE CFJV_TEAM.Gabinete(
	gabinete_codigo INT PRIMARY KEY IDENTITY(1, 1),
	gabinete_modelo NVARCHAR(255) NULL,
	gabinete_alto DECIMAL(18, 2) NOT NULL,
	gabinete_ancho DECIMAL(18, 2) NOT NULL,
	gabinete_profundidad DECIMAL(18, 2) NOT NULL,
	gabinete_fabricante_id INT NULL REFERENCES CFJV_TEAM.Fabricante
);

CREATE TABLE CFJV_TEAM.MicroProcesador(
	microprocesador_codigo NVARCHAR(255) PRIMARY KEY,
	microprocesador_cache NVARCHAR(255) NOT NULL,
	microprocesador_cant_hilos INT NOT NULL,
	microprocesador_velocidad NVARCHAR(255) NOT NULL,
	microprocesador_fabricante_id INT NOT NULL REFERENCES CFJV_TEAM.Fabricante
);

CREATE TABLE CFJV_TEAM.PlacaVideo(
	placa_video_codigo INT PRIMARY KEY IDENTITY(1, 1),
	placa_video_chipset NVARCHAR(255) NOT NULL,
	placa_video_modelo NVARCHAR(255) NOT NULL,
	placa_video_velocidad NVARCHAR(255) NOT NULL,
	placa_video_capacidad NVARCHAR(255) NOT NULL,
	placa_video_fabricante_id INT NOT NULL REFERENCES CFJV_TEAM.Fabricante
);

CREATE TABLE CFJV_TEAM.MemoriaRAM(
	memoria_ram_codigo NVARCHAR(255) PRIMARY KEY,
	memoria_ram_capacidad NVARCHAR(255) NOT NULL,
	memoria_ram_velocidad NVARCHAR(255) NOT NULL,
	memoria_ram_tipo NVARCHAR(255) NOT NULL,
	memoria_ram_fabricante_id INT NOT NULL REFERENCES CFJV_TEAM.Fabricante
);

CREATE TABLE CFJV_TEAM.DiscoRigido(
	disco_rigido_codigo NVARCHAR(255) PRIMARY KEY,
	disco_rigido_capacidad NVARCHAR(255) NOT NULL,
	disco_rigido_velocidad NVARCHAR(255) NOT NULL,
	disco_rigido_tipo NVARCHAR(255) NOT NULL,
	disco_rigido_fabricante_id INT NOT NULL REFERENCES CFJV_TEAM.Fabricante
);

CREATE TABLE CFJV_TEAM.PC(
	PC_codigo NVARCHAR(255) PRIMARY KEY,
	PC_numero_serie NVARCHAR(255) NULL,
	PC_precio DECIMAL(18,2) NULL,
	PC_motherboard NVARCHAR(255) NULL,
	PC_gabinete_codigo INT NOT NULL REFERENCES CFJV_TEAM.Gabinete,
	PC_microprocesador_codigo NVARCHAR(255) NOT NULL REFERENCES CFJV_TEAM.MicroProcesador,
	PC_placa_video_codigo INT NOT NULL REFERENCES CFJV_TEAM.PlacaVideo,
	PC_memoria_ram_codigo NVARCHAR(255) NOT NULL REFERENCES CFJV_TEAM.MemoriaRAM,
	PC_disco_rigido_codigo NVARCHAR(255) NOT NULL REFERENCES CFJV_TEAM.DiscoRigido
);

CREATE TABLE CFJV_TEAM.Sucursal(
	sucursal_id INT PRIMARY KEY IDENTITY(1, 1),
	sucursal_direccion NVARCHAR(255) NOT NULL,
	sucursal_ciudad NVARCHAR(255) NOT NULL,
	sucursal_mail NVARCHAR(255) NOT NULL,
	sucursal_telefono DECIMAL(18, 0) NOT NULL
);

CREATE TABLE CFJV_TEAM.Cliente(
	cliente_id INT PRIMARY KEY IDENTITY(1, 1),
	cliente_dni DECIMAL(18, 0) NOT NULL,
	cliente_apellido NVARCHAR(255) NOT NULL,
	cliente_nombre NVARCHAR(255) NOT NULL,
	cliente_fecha_nacimiento DATETIME NOT NULL,
	cliente_sexo CHAR(1) NULL,
	cliente_direccion NVARCHAR(255) NOT NULL,
	cliente_telefono DECIMAL(18, 0) NOT NULL,
	cliente_mail NVARCHAR(255) NOT NULL
);

CREATE TABLE CFJV_TEAM.Compra(
	compra_numero INT PRIMARY KEY,
	compra_fecha DATETIME NOT NULL,
	sucursal_id INT NOT NULL REFERENCES CFJV_TEAM.Sucursal
);

CREATE TABLE CFJV_TEAM.CompraAccesorio(
	compra_accesorio_id INT PRIMARY KEY IDENTITY(1, 1),
	compra_accesorio_precio DECIMAL(18,2) NOT NULL,
	compra_accesorio_cantidad INT NOT NULL,
	accesorio_codigo INT NOT NULL REFERENCES CFJV_TEAM.Accesorio,
	compra_numero INT NOT NULL REFERENCES CFJV_TEAM.Compra
);

CREATE TABLE CFJV_TEAM.CompraPC(
	compra_numero INT PRIMARY KEY REFERENCES CFJV_TEAM.Compra,
	compra_PC_cantidad INT NOT NULL,
	compra_PC_precio DECIMAL(18, 2) NOT NULL,
	compra_PC_codigo NVARCHAR(255) NOT NULL REFERENCES CFJV_TEAM.PC
);

CREATE TABLE CFJV_TEAM.Factura(
	factura_numero DECIMAL(18, 0) PRIMARY KEY,
	factura_fecha DATETIME NOT NULL,
	sucursal_id INT NOT NULL REFERENCES CFJV_TEAM.Sucursal,
	cliente_id INT NOT NULL REFERENCES CFJV_TEAM.Cliente
);

CREATE TABLE CFJV_TEAM.FacturaAccesorio(
	factura_numero DECIMAL(18, 0) NOT NULL REFERENCES CFJV_TEAM.Factura,
	accesorio_codigo INT NOT NULL REFERENCES CFJV_TEAM.Accesorio,
	factura_accesorio_cantidad INT NOT NULL,
	factura_accesorio_precio DECIMAL(18, 2) NOT NULL,
	CONSTRAINT PK_FacturaAccesorio PRIMARY KEY (factura_numero, accesorio_codigo)
);

CREATE TABLE CFJV_TEAM.FacturaPC(
	factura_numero DECIMAL(18, 0) NOT NULL REFERENCES CFJV_TEAM.Factura,
	PC_codigo NVARCHAR(255) NOT NULL REFERENCES CFJV_TEAM.PC,
	CONSTRAINT PK_FacturaPC PRIMARY KEY (factura_numero, PC_codigo)
);


INSERT INTO CFJV_TEAM.Fabricante (nombre)
   SELECT DISTINCT m.DISCO_RIGIDO_FABRICANTE
   FROM gd_esquema.Maestra m
   WHERE m.DISCO_RIGIDO_FABRICANTE IS NOT NULL
   UNION
   SELECT DISTINCT m.MEMORIA_RAM_FABRICANTE
   FROM gd_esquema.Maestra m
   WHERE m.MEMORIA_RAM_FABRICANTE IS NOT NULL
   UNION
   SELECT DISTINCT m.MICROPROCESADOR_FABRICANTE
   FROM gd_esquema.Maestra m
   WHERE m.MICROPROCESADOR_FABRICANTE IS NOT NULL
   UNION
   SELECT DISTINCT m.PLACA_VIDEO_FABRICANTE
   FROM gd_esquema.Maestra m
   WHERE m.PLACA_VIDEO_FABRICANTE IS NOT NULL;
GO

INSERT INTO CFJV_TEAM.Accesorio(
	accesorio_codigo,
	accesorio_descripcion,
	accesorio_precio
) SELECT DISTINCT 
	m.ACCESORIO_CODIGO,
	m.AC_DESCRIPCION,
	m.COMPRA_PRECIO
FROM gd_esquema.Maestra m
WHERE m.ACCESORIO_CODIGO IS NOT NULL
AND m.AC_DESCRIPCION IS NOT NULL
AND m.COMPRA_PRECIO IS NOT NULL;
	
INSERT INTO CFJV_TEAM.Gabinete(
	gabinete_alto,
	gabinete_ancho,
	gabinete_profundidad
) SELECT DISTINCT
	m.PC_ALTO,
	m.PC_ANCHO,
	m.PC_PROFUNDIDAD
FROM gd_esquema.Maestra m
WHERE m.PC_ALTO IS NOT NULL
AND m.PC_ANCHO IS NOT NULL
AND m.PC_PROFUNDIDAD IS NOT NULL;

INSERT INTO CFJV_TEAM.MicroProcesador(
	microprocesador_codigo,
	microprocesador_cache,
	microprocesador_cant_hilos,
	microprocesador_velocidad,
	microprocesador_fabricante_id
) SELECT DISTINCT
	m.MICROPROCESADOR_CODIGO,
	m.MICROPROCESADOR_CACHE,
	m.MICROPROCESADOR_CANT_HILOS,
	m.MICROPROCESADOR_VELOCIDAD,
	f.fabricante_id
FROM gd_esquema.Maestra m
JOIN CFJV_TEAM.Fabricante f
	ON f.nombre = m.MICROPROCESADOR_FABRICANTE
WHERE m.MICROPROCESADOR_CODIGO IS NOT NULL
AND m.MICROPROCESADOR_CACHE IS NOT NULL
AND m.MICROPROCESADOR_CANT_HILOS IS NOT NULL
AND m.MICROPROCESADOR_VELOCIDAD IS NOT NULL
AND m.MICROPROCESADOR_FABRICANTE IS NOT NULL;

INSERT INTO CFJV_TEAM.PlacaVideo(
	placa_video_chipset,
	placa_video_modelo,
	placa_video_velocidad,
	placa_video_capacidad,
	placa_video_fabricante_id
) SELECT DISTINCT
	m.PLACA_VIDEO_CHIPSET,
	m.PLACA_VIDEO_MODELO,
	m.PLACA_VIDEO_VELOCIDAD,
	m.PLACA_VIDEO_CAPACIDAD,
	f.fabricante_id
FROM gd_esquema.Maestra m
JOIN CFJV_TEAM.Fabricante f
	ON f.nombre = m.PLACA_VIDEO_FABRICANTE
WHERE m.PLACA_VIDEO_CHIPSET IS NOT NULL
AND m.PLACA_VIDEO_MODELO IS NOT NULL
AND m.PLACA_VIDEO_VELOCIDAD IS NOT NULL
AND m.PLACA_VIDEO_CAPACIDAD IS NOT NULL
AND m.PLACA_VIDEO_FABRICANTE IS NOT NULL;

INSERT INTO CFJV_TEAM.MemoriaRAM (
	memoria_ram_codigo,
	memoria_ram_capacidad,
	memoria_ram_velocidad,
	memoria_ram_tipo,
	memoria_ram_fabricante_id
) SELECT DISTINCT
	m.MEMORIA_RAM_CODIGO,
	m.MEMORIA_RAM_CAPACIDAD,
	m.MEMORIA_RAM_VELOCIDAD,
	m.MEMORIA_RAM_TIPO,
	f.fabricante_id
FROM gd_esquema.Maestra m
JOIN CFJV_TEAM.Fabricante f
	ON f.nombre = m.MEMORIA_RAM_FABRICANTE
WHERE m.MEMORIA_RAM_CODIGO IS NOT NULL
AND m.MEMORIA_RAM_CAPACIDAD IS NOT NULL
AND m.MEMORIA_RAM_VELOCIDAD IS NOT NULL
AND m.MEMORIA_RAM_TIPO IS NOT NULL
AND m.MEMORIA_RAM_FABRICANTE IS NOT NULL;

INSERT INTO CFJV_TEAM.DiscoRigido(
	disco_rigido_codigo,
	disco_rigido_capacidad,
	disco_rigido_velocidad,
	disco_rigido_tipo,
	disco_rigido_fabricante_id
) SELECT DISTINCT
	m.DISCO_RIGIDO_CODIGO,
	m.DISCO_RIGIDO_CAPACIDAD,
	m.DISCO_RIGIDO_VELOCIDAD,
	m.DISCO_RIGIDO_TIPO,
	F.fabricante_id
FROM gd_esquema.Maestra m
JOIN CFJV_TEAM.Fabricante f
	ON f.nombre = m.DISCO_RIGIDO_FABRICANTE
WHERE m.DISCO_RIGIDO_CODIGO IS NOT NULL
AND m.DISCO_RIGIDO_CAPACIDAD IS NOT NULL
AND m.DISCO_RIGIDO_VELOCIDAD IS NOT NULL
AND m.DISCO_RIGIDO_TIPO IS NOT NULL
AND m.DISCO_RIGIDO_FABRICANTE IS NOT NULL;

INSERT INTO CFJV_TEAM.PC(
	PC_codigo,
	PC_gabinete_codigo,
	PC_microprocesador_codigo,
	PC_placa_video_codigo,
	PC_memoria_ram_codigo,
	PC_disco_rigido_codigo
) SELECT DISTINCT
	m.PC_CODIGO,
	g.gabinete_codigo,
	mp.microprocesador_codigo,
	pv.placa_video_codigo,
	mr.memoria_ram_codigo,
	dr.disco_rigido_codigo
FROM gd_esquema.Maestra m
JOIN CFJV_TEAM.Gabinete g
	ON g.gabinete_alto = m.PC_ALTO
	AND g.gabinete_ancho = m.PC_ANCHO 
	AND g.gabinete_profundidad = m.PC_PROFUNDIDAD
JOIN CFJV_TEAM.MicroProcesador mp
	ON mp.microprocesador_codigo = m.MICROPROCESADOR_CODIGO
JOIN CFJV_TEAM.Fabricante f
	ON f.nombre = m.PLACA_VIDEO_FABRICANTE
JOIN CFJV_TEAM.PlacaVideo pv
	ON pv.placa_video_chipset = m.PLACA_VIDEO_CHIPSET
	AND pv.placa_video_modelo = m.PLACA_VIDEO_MODELO
	AND pv.placa_video_velocidad = m.PLACA_VIDEO_VELOCIDAD
	AND pv.placa_video_capacidad = m.PLACA_VIDEO_CAPACIDAD
	AND pv.placa_video_fabricante_id = f.fabricante_id
JOIN CFJV_TEAM.MemoriaRAM mr
	ON mr.memoria_ram_codigo = m.MEMORIA_RAM_CODIGO
JOIN CFJV_TEAM.DiscoRigido dr
	ON dr.disco_rigido_codigo = m.DISCO_RIGIDO_CODIGO
WHERE m.PC_CODIGO IS NOT NULL
AND m.PC_ALTO IS NOT NULL
AND m.PC_ANCHO IS NOT NULL
AND m.PC_PROFUNDIDAD IS NOT NULL
AND m.MICROPROCESADOR_CODIGO IS NOT NULL
AND m.PLACA_VIDEO_FABRICANTE IS NOT NULL
AND m.PLACA_VIDEO_CHIPSET IS NOT NULL
AND m.PLACA_VIDEO_MODELO IS NOT NULL
AND m.PLACA_VIDEO_VELOCIDAD IS NOT NULL
AND m.PLACA_VIDEO_CAPACIDAD IS NOT NULL
AND m.MEMORIA_RAM_CODIGO IS NOT NULL
AND m.DISCO_RIGIDO_CODIGO IS NOT NULL;

INSERT INTO CFJV_TEAM.Sucursal (
	sucursal_direccion,
	sucursal_ciudad,
	sucursal_mail,
	sucursal_telefono
) SELECT DISTINCT
	m.SUCURSAL_DIR,
	m.CIUDAD,
	m.SUCURSAL_MAIL,
	m.SUCURSAL_TEL
FROM gd_esquema.Maestra m
WHERE m.SUCURSAL_DIR IS NOT NULL
AND m.CIUDAD IS NOT NULL
AND m.SUCURSAL_MAIL IS NOT NULL
AND m.SUCURSAL_TEL IS NOT NULL;

INSERT INTO CFJV_TEAM.Cliente (
	cliente_dni,
	cliente_apellido,
	cliente_nombre,
	cliente_fecha_nacimiento,
	cliente_direccion,
	cliente_telefono,
	cliente_mail
) SELECT DISTINCT
	m.CLIENTE_DNI,
	m.CLIENTE_APELLIDO,
	m.CLIENTE_NOMBRE,
	m.CLIENTE_FECHA_NACIMIENTO,
	m.CLIENTE_DIRECCION,
	m.CLIENTE_TELEFONO,
	m.CLIENTE_MAIL
FROM gd_esquema.Maestra m
WHERE m.CLIENTE_DNI IS NOT NULL
AND m.CLIENTE_APELLIDO IS NOT NULL
AND m.CLIENTE_NOMBRE IS NOT NULL
AND m.CLIENTE_FECHA_NACIMIENTO IS NOT NULL
AND m.CLIENTE_DIRECCION IS NOT NULL
AND m.CLIENTE_TELEFONO IS NOT NULL
AND m.CLIENTE_MAIL IS NOT NULL;

INSERT INTO CFJV_TEAM.Compra(
	compra_numero,
	compra_fecha,
	sucursal_id
) SELECT DISTINCT
	m.COMPRA_NUMERO,
	m.COMPRA_FECHA,
	s.sucursal_id
FROM gd_esquema.Maestra m
JOIN CFJV_TEAM.Sucursal s
	ON m.CIUDAD = s.sucursal_ciudad
	AND m.SUCURSAL_DIR = s.sucursal_direccion
	AND m.SUCURSAL_MAIL = s.sucursal_mail
	AND m.SUCURSAL_TEL = s.sucursal_telefono
WHERE m.COMPRA_NUMERO IS NOT NULL
AND m.COMPRA_FECHA IS NOT NULL
AND m.CIUDAD IS NOT NULL
AND m.SUCURSAL_DIR IS NOT NULL
AND m.SUCURSAL_MAIL IS NOT NULL
AND m.SUCURSAL_TEL IS NOT NULL;

INSERT INTO CFJV_TEAM.CompraAccesorio(
	compra_accesorio_precio,
	compra_accesorio_cantidad,
	accesorio_codigo,
	compra_numero
) SELECT DISTINCT
	m.COMPRA_PRECIO,
	m.COMPRA_CANTIDAD,
	m.ACCESORIO_CODIGO,
	m.COMPRA_NUMERO
FROM gd_esquema.Maestra m
WHERE m.COMPRA_PRECIO IS NOT NULL
AND m.COMPRA_CANTIDAD IS NOT NULL
AND m.ACCESORIO_CODIGO IS NOT NULL
AND m.COMPRA_NUMERO IS NOT NULL;

INSERT INTO CFJV_TEAM.CompraPC(
	compra_numero,
	compra_PC_cantidad,
	compra_PC_precio,
	compra_PC_codigo
) SELECT DISTINCT
	m.COMPRA_NUMERO,
	m.COMPRA_CANTIDAD,
	m.COMPRA_PRECIO,
	m.PC_CODIGO
FROM gd_esquema.Maestra m
WHERE m.COMPRA_NUMERO IS NOT NULL
AND m.COMPRA_CANTIDAD IS NOT NULL
AND m.COMPRA_PRECIO IS NOT NULL
AND m.PC_CODIGO IS NOT NULL;

INSERT INTO CFJV_TEAM.Factura(
	factura_numero,
	factura_fecha,
	sucursal_id,
	cliente_id
) SELECT DISTINCT
	m.FACTURA_NUMERO,
	m.FACTURA_FECHA,
	s.sucursal_id,
	c.cliente_id
FROM gd_esquema.Maestra m
JOIN CFJV_TEAM.Sucursal s
	ON s.sucursal_ciudad = m.CIUDAD
	AND s.sucursal_direccion = m.SUCURSAL_DIR
	AND s.sucursal_mail = m.SUCURSAL_MAIL
	AND s.sucursal_telefono = m.SUCURSAL_TEL
JOIN CFJV_TEAM.Cliente c
	ON c.cliente_dni = m.CLIENTE_DNI
	AND c.cliente_apellido = m.CLIENTE_APELLIDO
	AND c.cliente_nombre = m.CLIENTE_NOMBRE
	AND c.cliente_fecha_nacimiento = m.CLIENTE_FECHA_NACIMIENTO
	AND c.cliente_direccion = m.CLIENTE_DIRECCION
	AND c.cliente_telefono = m.CLIENTE_TELEFONO
	AND c.cliente_mail = m.CLIENTE_MAIL
WHERE m.FACTURA_NUMERO IS NOT NULL
AND m.FACTURA_FECHA IS NOT NULL
AND m.CIUDAD IS NOT NULL
AND m.SUCURSAL_DIR IS NOT NULL
AND m.SUCURSAL_MAIL IS NOT NULL
AND m.SUCURSAL_TEL IS NOT NULL;
/*
AND m.CLIENTE_DNI IS NOT NULL
AND m.CLIENTE_APELLIDO IS NOT NULL
AND m.CLIENTE_NOMBRE IS NOT NULL
AND m.CLIENTE_FECHA_NACIMIENTO IS NOT NULL
AND m.CLIENTE_DIRECCION IS NOT NULL
AND m.CLIENTE_TELEFONO IS NOT NULL
AND m.CLIENTE_TELEFONO IS NOT NULL
AND m.CLIENTE_MAIL IS NOT NULL;
*/

INSERT INTO CFJV_TEAM.FacturaAccesorio(
	factura_numero,
	accesorio_codigo,
	factura_accesorio_cantidad,
	factura_accesorio_precio
) SELECT
	m.FACTURA_NUMERO,
	a.ACCESORIO_CODIGO,
	COUNT(*),
	SUM(a.accesorio_precio * 1.2)
FROM gd_esquema.Maestra m
JOIN CFJV_TEAM.Accesorio a
	ON a.accesorio_codigo = m.ACCESORIO_CODIGO
WHERE m.FACTURA_NUMERO IS NOT NULL
AND m.ACCESORIO_CODIGO IS NOT NULL
GROUP BY m.FACTURA_NUMERO, a.ACCESORIO_CODIGO;

INSERT INTO CFJV_TEAM.FacturaPC(
	factura_numero,
	pc_codigo
) SELECT DISTINCT
	m.FACTURA_NUMERO,
	m.PC_CODIGO
FROM gd_esquema.Maestra m
WHERE m.FACTURA_NUMERO IS NOT NULL
AND m.PC_CODIGO IS NOT NULL;