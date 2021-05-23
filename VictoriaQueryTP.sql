USE [GD1C2021]
GO

/*Esquema*/
CREATE SCHEMA CFJV_TEAM
GO

/*Tablas*/

--FABRICANTE
DROP TABLE CFJV_TEAM.Fabricante
GO

CREATE TABLE CFJV_TEAM.Fabricante (
fabricante_id INT PRIMARY KEY IDENTITY(1,1),
nombre NVARCHAR(255) NULL
);
GO

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

--SUCURSAL
DROP TABLE CFJV_TEAM.Sucursal
GO

CREATE TABLE CFJV_TEAM.Sucursal (
sucursal_id INT PRIMARY KEY IDENTITY(1,1),
sucursal_direccion NVARCHAR(255) NULL,
sucursal_ciudad NVARCHAR(255) NULL,
sucursal_mail NVARCHAR(255) NULL,
sucursal_telefono DECIMAL(18, 0) NULL
);
GO

INSERT INTO CFJV_TEAM.Sucursal (sucursal_direccion, sucursal_ciudad, sucursal_mail, sucursal_telefono)
	SELECT DISTINCT m.SUCURSAL_DIR, m.CIUDAD, m.SUCURSAL_MAIL, m.SUCURSAL_TEL
	FROM gd_esquema.Maestra m
	WHERE m.SUCURSAL_DIR IS NOT NULL AND m.CIUDAD 
						 IS NOT NULL AND m.SUCURSAL_MAIL 
						 IS NOT NULL AND m.SUCURSAL_TEL IS NOT NULL;
GO

--CLIENTE
DROP TABLE CFJV_TEAM.Cliente
GO

CREATE TABLE CFJV_TEAM.Cliente (
cliente_id INT PRIMARY KEY IDENTITY(1,1),
cliente_dni DECIMAL(18, 0) NULL,
cliente_apellido NVARCHAR(255) NULL,
cliente_nombre NVARCHAR(255) NULL,
cliente_fecha_nacimiento DATETIME2(3) NULL,
cliente_direccion NVARCHAR(255) NULL,
cliente_telefono INT NULL,
cliente_mail NVARCHAR(255) NULL,
);
GO

INSERT INTO CFJV_TEAM.Cliente (cliente_dni, cliente_apellido, cliente_nombre, cliente_fecha_nacimiento, cliente_direccion, cliente_telefono, cliente_mail)
	SELECT DISTINCT m.CLIENTE_DNI, m.CLIENTE_APELLIDO, m.CLIENTE_NOMBRE, m.CLIENTE_FECHA_NACIMIENTO, m.CLIENTE_DIRECCION, m.CLIENTE_TELEFONO, m.CLIENTE_MAIL
	FROM gd_esquema.Maestra m
	WHERE m.CLIENTE_DNI IS NOT NULL AND m.CLIENTE_APELLIDO 
						IS NOT NULL AND m.CLIENTE_NOMBRE 
						IS NOT NULL AND m.CLIENTE_FECHA_NACIMIENTO 
						IS NOT NULL AND m.CLIENTE_DIRECCION 
						IS NOT NULL AND m.CLIENTE_TELEFONO 
						IS NOT NULL AND m.CLIENTE_MAIL IS NOT NULL;
GO

--ACCESORIO
DROP TABLE CFJV_TEAM.Accesorio
GO

CREATE TABLE CFJV_TEAM.Accesorio (
accesorio_codigo DECIMAL(18, 0) PRIMARY KEY,
accesorio_descripcion NVARCHAR(255) NULL,
accesorio_precio DECIMAL(18, 2) NULL,
fabricante_id INT REFERENCES CFJV_TEAM.Fabricante
);
GO

INSERT INTO CFJV_TEAM.Accesorio (accesorio_codigo, accesorio_descripcion, accesorio_precio)
	SELECT DISTINCT m.ACCESORIO_CODIGO, m.AC_DESCRIPCION, m.COMPRA_PRECIO
	FROM gd_esquema.Maestra m
	WHERE m.ACCESORIO_CODIGO IS NOT NULL AND m.AC_DESCRIPCION 
							 IS NOT NULL AND m.COMPRA_PRECIO IS NOT NULL;
GO

--FACTURA ACCESORIO
DROP TABLE CFJV_TEAM.FacturaAccesorio
GO

CREATE TABLE CFJV_TEAM.FacturaAccesorio (
factura_numero NVARCHAR(50) PRIMARY KEY, /*FK*/
factura_accesorio_codigo NVARCHAR(50) NULL, /*FK*/
factura_accesorio_cantidad NVARCHAR(50) NULL,
factura_accesorio_precio DECIMAL(18, 2) NULL
);
GO

INSERT INTO CFJV_TEAM.FacturaAccesorio (factura_numero, factura_accesorio_codigo, factura_accesorio_cantidad, factura_accesorio_precio)
	SELECT DISTINCT m.FACTURA_NUMERO, m.ACCESORIO_CODIGO, m.COMPRA_CANTIDAD, m.COMPRA_PRECIO
	FROM gd_esquema.Maestra m
	WHERE m.FACTURA_NUMERO IS NOT NULL AND m.ACCESORIO_CODIGO 
						   IS NOT NULL AND m.COMPRA_CANTIDAD 
						   IS NOT NULL AND m.COMPRA_PRECIO IS NOT NULL;
GO

--GABINETE
DROP TABLE CFJV_TEAM.Gabinete
GO

CREATE TABLE CFJV_TEAM.Gabinete (
gabinete_codigo INT PRIMARY KEY IDENTITY(1,1),
gabinete_modelo INT NULL,
gabinete_ancho INT NULL,
gabinete_alto INT NULL,
gabinete_profundidad INT NULL,
gabinete_fabricante_id INT REFERENCES CFJV_TEAM.Fabricante
);
GO

INSERT INTO CFJV_TEAM.Gabinete (gabinete_modelo, gabinete_ancho, gabinete_alto, gabinete_profundidad, gabinete_fabricante_id)
	SELECT DISTINCT m.PC_ANCHO, m.PC_ALTO, m.PC_PROFUNDIDAD/*, (SELECT TOP 1 f.fabricante_id FROM CFJV_TEAM.Fabricante f WHERE f.nombre=m.MICROPROCESADOR_FABRICANTE) ; como obtengo el fabricante del gabinete?*/
	FROM gd_esquema.Maestra m
	WHERE m.PC_ALTO IS NOT NULL AND m.PC_ANCHO 
					IS NOT NULL AND m.PC_PROFUNDIDAD IS NOT NULL;
GO

--MICROPROCESADOR
DROP TABLE CFJV_TEAM.Microprocesador
GO

CREATE TABLE CFJV_TEAM.Microprocesador (
microprocesador_codigo NVARCHAR(50) PRIMARY KEY,
microprocesador_cache NVARCHAR(50) NULL,
microprocesador_cant_hilos DECIMAL(18, 0) NULL,
microprocesador_velocidad NVARCHAR(50) NULL,
microprocesador_fabricante_id INT REFERENCES CFJV_TEAM.Fabricante
);
GO

INSERT INTO CFJV_TEAM.Microprocesador (microprocesador_codigo, microprocesador_cache, microprocesador_cant_hilos, microprocesador_velocidad, microprocesador_fabricante_id)
	SELECT DISTINCT m.MICROPROCESADOR_CODIGO, m.MICROPROCESADOR_CACHE, m.MICROPROCESADOR_CANT_HILOS, m.MICROPROCESADOR_VELOCIDAD, (SELECT TOP 1 f.fabricante_id FROM CFJV_TEAM.Fabricante f WHERE f.nombre=m.MICROPROCESADOR_FABRICANTE)
	FROM gd_esquema.Maestra m
	WHERE m.MICROPROCESADOR_CODIGO IS NOT NULL AND m.MICROPROCESADOR_CACHE 
								   IS NOT NULL AND m.MICROPROCESADOR_CANT_HILOS 
								   IS NOT NULL AND m.MICROPROCESADOR_VELOCIDAD IS NOT NULL;
GO

--PLACA DE VIDEO
DROP TABLE CFJV_TEAM.PlacaVideo
GO

CREATE TABLE CFJV_TEAM.PlacaVideo (
placa_video_codigo INT PRIMARY KEY IDENTITY(1,1),
placa_video_chipset NVARCHAR(50) NULL,
placa_video_modelo NVARCHAR(50) NULL,
placa_video_velocidad NVARCHAR(50) NULL,
placa_video_capacidad NVARCHAR(50) NULL,
placa_video_fabricante_id INT REFERENCES CFJV_TEAM.Fabricante
);
GO

INSERT INTO CFJV_TEAM.PlacaVideo (placa_video_chipset, placa_video_modelo, placa_video_velocidad, placa_video_capacidad, placa_video_fabricante_id)
	SELECT DISTINCT m.PLACA_VIDEO_CHIPSET, m.PLACA_VIDEO_MODELO, m.PLACA_VIDEO_VELOCIDAD, m.PLACA_VIDEO_CAPACIDAD, (SELECT TOP 1 f.fabricante_id FROM CFJV_TEAM.Fabricante f WHERE f.nombre=m.PLACA_VIDEO_FABRICANTE)
	FROM gd_esquema.Maestra m
	WHERE m.PLACA_VIDEO_CHIPSET IS NOT NULL AND m.PLACA_VIDEO_MODELO 
								IS NOT NULL AND m.PLACA_VIDEO_VELOCIDAD 
								IS NOT NULL AND m.PLACA_VIDEO_CAPACIDAD IS NOT NULL;
GO

--MEMORIA RAM
DROP TABLE CFJV_TEAM.MemoriaRAM
GO

CREATE TABLE CFJV_TEAM.MemoriaRAM (
memoria_ram_codigo NVARCHAR(50) PRIMARY KEY,
memoria_ram_capacidad NVARCHAR(50) NULL,
memoria_ram_velocidad NVARCHAR(50) NULL,
memoria_ram_tipo NVARCHAR(50) NULL,
memoria_ram_fabricante_id INT REFERENCES CFJV_TEAM.Fabricante
);
GO

INSERT INTO CFJV_TEAM.MemoriaRAM (memoria_ram_codigo, memoria_ram_capacidad, memoria_ram_velocidad, memoria_ram_tipo, memoria_ram_fabricante_id)
	SELECT DISTINCT m.MEMORIA_RAM_CODIGO, m.MEMORIA_RAM_CAPACIDAD, m.MEMORIA_RAM_VELOCIDAD, m.MEMORIA_RAM_TIPO, (SELECT TOP 1 f.fabricante_id FROM CFJV_TEAM.Fabricante f WHERE f.nombre=m.MEMORIA_RAM_FABRICANTE)
	FROM gd_esquema.Maestra m
	WHERE m.MEMORIA_RAM_CODIGO IS NOT NULL AND m.MEMORIA_RAM_CAPACIDAD 
							   IS NOT NULL AND m.MEMORIA_RAM_VELOCIDAD 
							   IS NOT NULL AND m.MEMORIA_RAM_TIPO IS NOT NULL;
GO

--DISCO RIGIDO
DROP TABLE CFJV_TEAM.DiscoRigido
GO

CREATE TABLE CFJV_TEAM.DiscoRigido (
disco_rigido_codigo NVARCHAR(50) PRIMARY KEY,
disco_rigido_capacidad NVARCHAR(50) NULL,
disco_rigido_velocidad NVARCHAR(50) NULL,
disco_rigido_tipo NVARCHAR(50) NULL,
disco_rigido_fabricante_id INT REFERENCES CFJV_TEAM.Fabricante
);
GO

INSERT INTO CFJV_TEAM.DiscoRigido (disco_rigido_codigo, disco_rigido_capacidad, disco_rigido_velocidad, disco_rigido_tipo, disco_rigido_fabricante_id)
	SELECT DISTINCT m.DISCO_RIGIDO_CODIGO, m.DISCO_RIGIDO_CAPACIDAD, m.DISCO_RIGIDO_VELOCIDAD, m.DISCO_RIGIDO_TIPO, (SELECT TOP 1 f.fabricante_id FROM CFJV_TEAM.Fabricante f WHERE f.nombre=m.DISCO_RIGIDO_FABRICANTE)
	FROM gd_esquema.Maestra m
	WHERE m.DISCO_RIGIDO_CODIGO IS NOT NULL AND m.DISCO_RIGIDO_CAPACIDAD 
								IS NOT NULL AND m.DISCO_RIGIDO_VELOCIDAD 
								IS NOT NULL AND m.DISCO_RIGIDO_TIPO IS NOT NULL;
GO

--COMPRA
DROP TABLE CFJV_TEAM.Compra
GO

CREATE TABLE CFJV_TEAM.Compra (
compra_numero NVARCHAR(50) PRIMARY KEY,
compra_fecha DATETIME2(3) NULL,
compra_precio DECIMAL(18, 2) NULL,
compra_sucursal_id INT REFERENCES CFJV_TEAM.Sucursal
);
GO

INSERT INTO CFJV_TEAM.Compra (compra_numero, compra_fecha, compra_precio, compra_sucursal_id)
	SELECT DISTINCT m.COMPRA_NUMERO, m.COMPRA_FECHA, m.COMPRA_PRECIO, s.sucursal_id
	FROM gd_esquema.Maestra m, CFJV_TEAM.Sucursal s
	WHERE m.COMPRA_NUMERO IS NOT NULL AND m.COMPRA_FECHA 
						  IS NOT NULL AND m.COMPRA_PRECIO
						  IS NOT NULL AND s.sucursal_id IS NOT NULL;
GO

--FACTURA
DROP TABLE CFJV_TEAM.Factura
GO

CREATE TABLE CFJV_TEAM.Factura (
factura_numero NVARCHAR(50) PRIMARY KEY,
factura_fecha DATETIME2(3) NULL,
factura_precio DECIMAL(18, 2) NULL,
factura_sucursal_id INT REFERENCES CFJV_TEAM.Sucursal,
factura_cliente_id INT REFERENCES CFJV_TEAM.Cliente
);
GO

INSERT INTO CFJV_TEAM.Factura (factura_numero, factura_fecha, factura_precio, factura_sucursal_id, factura_cliente_id)
	SELECT DISTINCT m.FACTURA_NUMERO, m.FACTURA_FECHA, s.sucursal_id, c.cliente_id
	FROM gd_esquema.Maestra m, CFJV_TEAM.Sucursal s, CFJV_TEAM.Cliente c
	WHERE m.FACTURA_NUMERO IS NOT NULL AND m.FACTURA_FECHA 
						   IS NOT NULL AND s.sucursal_id 
						   IS NOT NULL AND c.cliente_id IS NOT NULL;
GO

--PC
DROP TABLE CFJV_TEAM.PC
GO

CREATE TABLE CFJV_TEAM.PC (
pc_codigo NVARCHAR(50) PRIMARY KEY,
pc_numero_serie INT NULL,
pc_precio DECIMAL(18, 2) NULL,
pc_motherboard NVARCHAR(50) NULL,
pc_gabinete_codigo INT REFERENCES CFJV_TEAM.Gabinete,
pc_disco_rigido_codigo NVARCHAR(50) REFERENCES CFJV_TEAM.DiscoRigido,
pc_memoria_ram_codigo NVARCHAR(50) REFERENCES CFJV_TEAM.MemoriaRAM,
pc_microprocesador_codigo NVARCHAR(50) REFERENCES CFJV_TEAM.Microprocesador,
pc_placa_video_codigo INT REFERENCES CFJV_TEAM.PlacaVideo
);
GO

INSERT INTO CFJV_TEAM.PC (pc_codigo, pc_precio, pc_gabinete_codigo, pc_disco_rigido_codigo, pc_memoria_ram_codigo, 
						  pc_microprocesador_codigo, pc_placa_video_codigo)
	SELECT DISTINCT m.PC_CODIGO, m.COMPRA_PRECIO, g.gabinete_codigo, dr.disco_rigido_codigo, mr.memoria_ram_codigo, 
					mc.microprocesador_codigo, pv.placa_video_codigo
	FROM gd_esquema.Maestra m, CFJV_TEAM.Gabinete g, CFJV_TEAM.DiscoRigido dr, CFJV_TEAM.MemoriaRAM mr, CFJV_TEAM.Microprocesador mc, CFJV_TEAM.PlacaVideo pv
	WHERE m.PC_CODIGO IS NOT NULL AND m.COMPRA_PRECIO 
					  IS NOT NULL AND g.gabinete_codigo 
					  IS NOT NULL AND dr.disco_rigido_codigo
					  IS NOT NULL AND mr.memoria_ram_codigo
					  IS NOT NULL AND mc.microprocesador_codigo
					  IS NOT NULL AND pv.placa_video_codigo IS NOT NULL;
GO

--FACTURA PC
DROP TABLE CFJV_TEAM.FacturaPC
GO

CREATE TABLE CFJV_TEAM.FacturaPC (
factura_numero NVARCHAR(50) PRIMARY KEY, /*FK*/
factura_pc_codigo NVARCHAR(50) NULL
);
GO

INSERT INTO CFJV_TEAM.FacturaPC (factura_numero, factura_pc_codigo)
	SELECT DISTINCT m.FACTURA_NUMERO, m.PC_CODIGO
	FROM gd_esquema.Maestra m
	WHERE m.FACTURA_NUMERO IS NOT NULL AND m.PC_CODIGO IS NOT NULL;
GO

--COMPRA PC
DROP TABLE CFJV_TEAM.CompraPC
GO

CREATE TABLE CFJV_TEAM.CompraPC (
compra_pc_compra_numero NVARCHAR(50) PRIMARY KEY,
compra_pc_cantidad INT NULL,
compra_pc_precio DECIMAL(18, 2) NULL,
compra_pc_codigo NVARCHAR(50) REFERENCES CFJV_TEAM.PC
);
GO

INSERT INTO CFJV_TEAM.CompraPC (compra_pc_compra_numero, compra_pc_precio, compra_pc_codigo)
	SELECT DISTINCT m.COMPRA_NUMERO, pc.pc_codigo, pc.pc_precio
	FROM gd_esquema.Maestra m, CFJV_TEAM.PC pc
	WHERE m.COMPRA_NUMERO IS NOT NULL AND pc.pc_codigo 
						  IS NOT NULL AND pc.pc_precio IS NOT NULL;
GO

--COMPRA ACCESORIO
DROP TABLE CFJV_TEAM.CompraAccesorio
GO

CREATE TABLE CFJV_TEAM.CompraAccesorio (
compra_accesorio_id INT PRIMARY KEY IDENTITY (1, 1),
compra_accesorio_precio DECIMAL(18, 2) NULL,
compra_accesorio_cantidad INT NULL,
accesorio_codigo DECIMAL(18, 0) REFERENCES CFJV_TEAM.Accesorio
);
GO

INSERT INTO CFJV_TEAM.CompraAccesorio (compra_accesorio_precio, accesorio_codigo)
	SELECT DISTINCT ac.accesorio_precio, ac.accesorio_codigo
	FROM  CFJV_TEAM.Accesorio ac
	WHERE ac.accesorio_precio IS NOT NULL AND ac.accesorio_codigo IS NOT NULL;
GO

