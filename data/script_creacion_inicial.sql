USE [GD1C2021]
GO

/* Revisa si existe el esquema y sino lo crea  */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
IF NOT EXISTS (SELECT * FROM sys.schemas AS sc WHERE sc.name=@grupo)
BEGIN
	PRINT 'Creando esquema... '+@grupo
	EXEC('CREATE SCHEMA '+@grupo)
	END
ELSE
	PRINT 'esquema '+@grupo+' YA EXISTE'
GO

/* Revisa si existe procedimiento checkProced y lo borra */
IF EXISTS (SELECT * FROM sysobjects AS so WHERE so.id = object_id(N'[dbo].[checkProced]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	PRINT 'Eliminando procedure... checkProced'
	EXEC('DROP PROCEDURE [dbo].[checkProced]')
END
GO

/* Revisa si existe determinado procedimiento en un esquema y lo borra */
CREATE PROCEDURE checkProced(@esquema VARCHAR(50), @proc VARCHAR(50))
AS
IF EXISTS (SELECT * FROM sysobjects AS so where so.id = object_id(@esquema+'.'+@proc) and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	PRINT 'Eliminando procedure... '+@proc
	EXEC('DROP PROCEDURE '+@esquema+'.'+@proc)
END
ELSE
	PRINT 'procedure '+@esquema+'.'+@proc+' NO EXISTE';
GO

/* Reviso la existencia del procedimiento checkTabla */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC checkProced @grupo,'checkTabla'
GO

/* Creo procedimiento checkTabla, que revisa la existencia de una tabla en un esquema */
CREATE PROCEDURE CFJV_TEAM.checkTabla(@esquema VARCHAR(50), @tabla VARCHAR(50))
AS
IF EXISTS (SELECT * FROM sys.objects AS so WHERE so.object_id = OBJECT_ID(@esquema+'.'+@tabla) AND type IN (N'U'))
	BEGIN
		PRINT 'Eliminando tabla '+@esquema+'.'+@tabla;
		EXEC('DROP TABLE '+@esquema+'.'+@tabla);
	END
ELSE
	PRINT 'tabla '+@esquema+'.'+@tabla+' NO EXISTE';
GO

/* Reviso la existencia del procedimiento crearEntidades */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC checkProced @grupo,'crearEntidades'
GO

/*Este procedimiento crea las tablas de nuestro modelo , difiniendo en cada una su PK */

CREATE PROCEDURE CFJV_TEAM.crearEntidades(@sch VARCHAR(50))
AS
BEGIN
DECLARE @tab VARCHAR(50) = 'Fabricante';
DECLARE @SQL NVARCHAR(MAX);
/*1*/
SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
fabricante_id INT PRIMARY KEY IDENTITY(1,1),
nombre nvarchar(255) NULL
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'Sucursal';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
sucursal_id INT PRIMARY KEY IDENTITY(1,1),
sucursal_direccion nvarchar(255) NULL,
sucursal_ciudad nvarchar(255) NULL,
sucursal_mail nvarchar(255) NULL,
sucursal_telefono decimal(18, 0) NULL
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'Cliente';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
cliente_id INT PRIMARY KEY IDENTITY(1,1),
cliente_dni decimal(18, 0) NULL,
cliente_apellido nvarchar(255) NULL,
cliente_nombre nvarchar(255) NULL,
cliente_fecha_nacimiento datetime2(3) NULL,
cliente_direccion nvarchar(255) NULL,
cliente_telefono int NULL,
cliente_mail nvarchar(255) NULL
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

/*2*/
SELECT @tab = 'Accesorio';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
accesorio_codigo decimal(18, 0) PRIMARY KEY,
accesorio_descripcion nvarchar(255) NULL,
accesorio_precio decimal(18, 2) NULL,
fabricante_id INT REFERENCES '+@sch+'.Fabricante
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'Microprocesador';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
microprocesador_codigo nvarchar(50) PRIMARY KEY,
microprocesador_cache nvarchar(50) NULL,
microprocesador_cant_hilos decimal(18, 0) NULL,
microprocesador_velocidad nvarchar(50) NULL,
fabricante_id INT REFERENCES '+@sch+'.Fabricante
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'MemoriaRam';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
memoria_ram_codigo nvarchar(255) PRIMARY KEY,
memoria_ram_capacidad nvarchar(255) NULL,
memoria_ram_velocidad nvarchar(255) NULL,
memoria_ram_tipo nvarchar(255) NULL,
fabricante_id INT REFERENCES '+@sch+'.Fabricante
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'DiscoRigido';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
disco_rigido_codigo nvarchar(255) PRIMARY KEY,
disco_rigido_capacidad nvarchar(255) NULL,
disco_rigido_velocidad nvarchar(255) NULL,
disco_rigido_tipo nvarchar(255) NULL,
fabricante_id INT REFERENCES '+@sch+'.Fabricante
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'PlacaVideo';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
placa_video_codigo INT PRIMARY KEY IDENTITY(1,1),
placa_video_chipset nvarchar(50) NULL,
placa_video_modelo nvarchar(50) NULL,
placa_video_velocidad nvarchar(50) NULL,
placa_video_capacidad nvarchar(50) NULL,
fabricante_id INT REFERENCES '+@sch+'.Fabricante
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'Gabinete';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
gabinete_codigo INT PRIMARY KEY IDENTITY(1,1),
gabinete_modelo nvarchar(50) NULL,
gabinete_alto decimal(18, 2) NULL,
gabinete_ancho decimal(18, 2) NULL,
gabinete_profundidad decimal(18, 2) NULL,
fabricante_id INT REFERENCES '+@sch+'.Fabricante
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'Compra';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
compra_numero decimal(18, 0) PRIMARY KEY,
compra_fecha datetime2(3) NULL,
compra_precio decimal(18, 2) NULL,
sucursal_id INT REFERENCES '+@sch+'.Sucursal	
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

/*3*/
SELECT @tab = 'Pc';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
pc_codigo nvarchar(50) PRIMARY KEY,
pc_numero_serie nvarchar(50) NULL,
pc_precio decimal(18, 2) NULL,
pc_motherboard nvarchar(50) NULL,
gabinete_codigo INT REFERENCES '+@sch+'.Gabinete,
placa_video_codigo INT REFERENCES '+@sch+'.PlacaVideo,
disco_rigido_codigo nvarchar(255) REFERENCES '+@sch+'.DiscoRigido,
memoria_ram_codigo nvarchar(255) REFERENCES '+@sch+'.MemoriaRam,
microprocesador_codigo nvarchar(50) REFERENCES '+@sch+'.Microprocesador
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'CompraAccesorio';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
compra_accesorio_codigo INT PRIMARY KEY IDENTITY(1,1),
compra_accesorio_cantidad decimal(18, 0) NULL,
accesorio_codigo decimal(18, 0) REFERENCES '+@sch+'.Accesorio,
compra_numero decimal(18, 0)  REFERENCES '+@sch+'.Compra
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

/*4*/
SELECT @tab = 'CompraPc';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
compra_numero decimal(18, 0) PRIMARY KEY REFERENCES '+@sch+'.Compra,
compra_pc_precio decimal(18, 2) NULL,
compra_pc_cantidad decimal(18, 0) NULL,
pc_codigo nvarchar(50) REFERENCES '+@sch+'.Pc
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

/*4*/
SELECT @tab = 'Factura';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
factura_numero decimal(18, 0) PRIMARY KEY,
factura_fecha datetime2(3) NULL,
factura_precio decimal(18, 2) NULL,
sucursal_id INT REFERENCES '+@sch+'.Sucursal,
cliente_id INT REFERENCES '+@sch+'.Cliente
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;

/*5*/
SELECT @tab = 'FacturaPc';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
factura_numero decimal(18, 0) PRIMARY KEY REFERENCES '+@sch+'.Factura,
pc_codigo nvarchar(50) REFERENCES '+@sch+'.Pc
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'FacturaAccesorio';

SELECT @SQL = 'CREATE TABLE '+@sch+'.'+@tab+'(
factura_numero decimal(18, 0) REFERENCES '+@sch+'.Factura,
accesorio_codigo decimal(18, 0)  REFERENCES '+@sch+'.Accesorio,
factura_accesorio_cantidad decimal(18, 0) NULL,
factura_accesorio_precio decimal(18, 2) NULL,
CONSTRAINT PK_ID_FACT_ACC PRIMARY KEY ( factura_numero, accesorio_codigo )
);';

PRINT 'Creando tabla '+ @tab;
EXEC sp_executesql @SQL;
END
GO

/* Reviso la existencia del procedimiento completandoEntidades */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC checkProced @grupo,'completandoEntidades'
GO

/*Este procedimiento hace un inserts masivos para pasar los datos de la tabla maestra del modelo anterior a las tablas
 de nuestro modelo */

CREATE PROCEDURE CFJV_TEAM.completandoEntidades(@sch VARCHAR(50))
AS
BEGIN
DECLARE @tab VARCHAR(50) = 'Fabricante';
DECLARE @SQL NVARCHAR(MAX);

/*1*/
SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (nombre)
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
WHERE m.PLACA_VIDEO_FABRICANTE IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'Sucursal';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (sucursal_direccion,sucursal_ciudad,sucursal_mail,sucursal_telefono)
SELECT DISTINCT m.SUCURSAL_DIR, m.CIUDAD, m.SUCURSAL_MAIL, m.SUCURSAL_TEL
FROM gd_esquema.Maestra m
WHERE m.SUCURSAL_DIR IS NOT NULL AND m.CIUDAD IS NOT NULL AND m.SUCURSAL_MAIL IS NOT NULL AND m.SUCURSAL_TEL IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'Cliente';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (cliente_dni,cliente_apellido,cliente_nombre,cliente_fecha_nacimiento,cliente_direccion,cliente_telefono,cliente_mail)
	SELECT DISTINCT m.CLIENTE_DNI, m.CLIENTE_APELLIDO, m.CLIENTE_NOMBRE, m.CLIENTE_FECHA_NACIMIENTO, m.CLIENTE_DIRECCION, m.CLIENTE_TELEFONO, m.CLIENTE_MAIL
	FROM gd_esquema.Maestra m
	WHERE m.CLIENTE_DNI IS NOT NULL AND m.CLIENTE_APELLIDO IS NOT NULL AND m.CLIENTE_NOMBRE IS NOT NULL AND m.CLIENTE_FECHA_NACIMIENTO IS NOT NULL AND m.CLIENTE_DIRECCION IS NOT NULL AND m.CLIENTE_TELEFONO IS NOT NULL AND m.CLIENTE_MAIL IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

/*2*/
SELECT @tab = 'Accesorio';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (accesorio_codigo,accesorio_descripcion,accesorio_precio)
	SELECT DISTINCT m.ACCESORIO_CODIGO, m.AC_DESCRIPCION, m.COMPRA_PRECIO
	FROM gd_esquema.Maestra m
	WHERE m.ACCESORIO_CODIGO IS NOT NULL AND m.AC_DESCRIPCION IS NOT NULL AND m.COMPRA_PRECIO IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'Microprocesador';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (microprocesador_codigo,microprocesador_cache,microprocesador_cant_hilos,microprocesador_velocidad,fabricante_id)
	SELECT DISTINCT m.MICROPROCESADOR_CODIGO, m.MICROPROCESADOR_CACHE, m.MICROPROCESADOR_CANT_HILOS,m.MICROPROCESADOR_VELOCIDAD,f.fabricante_id
	FROM gd_esquema.Maestra m
	LEFT JOIN '+@sch+'.Fabricante f ON f.nombre=m.MICROPROCESADOR_FABRICANTE
	WHERE m.MICROPROCESADOR_CODIGO IS NOT NULL AND m.MICROPROCESADOR_CACHE IS NOT NULL AND m.MICROPROCESADOR_CANT_HILOS IS NOT NULL AND m.MICROPROCESADOR_VELOCIDAD IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'MemoriaRam';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (memoria_ram_codigo,memoria_ram_capacidad,memoria_ram_velocidad,memoria_ram_tipo,fabricante_id)
	SELECT DISTINCT m.MEMORIA_RAM_CODIGO, m.MEMORIA_RAM_CAPACIDAD, m.MEMORIA_RAM_VELOCIDAD,m.MEMORIA_RAM_TIPO,f.fabricante_id
	FROM gd_esquema.Maestra m
	LEFT JOIN '+@sch+'.Fabricante f ON f.nombre=m.MEMORIA_RAM_FABRICANTE
	WHERE m.MEMORIA_RAM_CODIGO IS NOT NULL AND m.MEMORIA_RAM_CAPACIDAD IS NOT NULL AND m.MEMORIA_RAM_VELOCIDAD IS NOT NULL AND m.MEMORIA_RAM_TIPO IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'DiscoRigido';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (disco_rigido_codigo,disco_rigido_capacidad,disco_rigido_velocidad,disco_rigido_tipo,fabricante_id)
	SELECT DISTINCT m.DISCO_RIGIDO_CODIGO, m.DISCO_RIGIDO_CAPACIDAD, m.DISCO_RIGIDO_VELOCIDAD,m.DISCO_RIGIDO_TIPO, f.fabricante_id
	FROM gd_esquema.Maestra m
	LEFT JOIN '+@sch+'.Fabricante f ON f.nombre=m.DISCO_RIGIDO_FABRICANTE
	WHERE m.DISCO_RIGIDO_CODIGO IS NOT NULL AND m.DISCO_RIGIDO_CAPACIDAD IS NOT NULL AND m.DISCO_RIGIDO_VELOCIDAD IS NOT NULL AND m.DISCO_RIGIDO_TIPO IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'PlacaVideo';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (placa_video_chipset,placa_video_modelo,placa_video_velocidad,placa_video_capacidad,fabricante_id)
	SELECT DISTINCT m.PLACA_VIDEO_CHIPSET, m.PLACA_VIDEO_MODELO, m.PLACA_VIDEO_VELOCIDAD,m.PLACA_VIDEO_CAPACIDAD, f.fabricante_id
	FROM gd_esquema.Maestra m
	LEFT JOIN '+@sch+'.Fabricante f ON f.nombre=m.PLACA_VIDEO_FABRICANTE
	WHERE m.PLACA_VIDEO_CHIPSET IS NOT NULL AND m.PLACA_VIDEO_MODELO IS NOT NULL AND m.PLACA_VIDEO_VELOCIDAD IS NOT NULL AND m.PLACA_VIDEO_CAPACIDAD IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'Gabinete';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (gabinete_alto,gabinete_ancho,gabinete_profundidad)
	SELECT DISTINCT m.PC_ALTO, m.PC_ANCHO,m.PC_PROFUNDIDAD
	FROM gd_esquema.Maestra m
	WHERE m.PC_ALTO IS NOT NULL AND m.PC_ANCHO IS NOT NULL AND m.PC_PROFUNDIDAD IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'Compra';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (compra_numero,compra_fecha,sucursal_id)
	SELECT DISTINCT m.COMPRA_NUMERO, m.COMPRA_FECHA, s.sucursal_id
	FROM gd_esquema.Maestra m
	JOIN '+@sch+'.Sucursal s 
	ON s.sucursal_ciudad=m.CIUDAD AND s.sucursal_direccion=m.SUCURSAL_DIR AND s.sucursal_mail=m.SUCURSAL_MAIL AND s.sucursal_telefono=m.SUCURSAL_TEL
	WHERE m.COMPRA_NUMERO IS NOT NULL AND m.COMPRA_FECHA IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

/*3*/
SELECT @tab = 'Pc';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (pc_codigo,pc_precio,gabinete_codigo,placa_video_codigo,disco_rigido_codigo,memoria_ram_codigo,microprocesador_codigo)
	SELECT DISTINCT m.PC_CODIGO, m.COMPRA_PRECIO, g.gabinete_codigo, p.placa_video_codigo, m.DISCO_RIGIDO_CODIGO, m.MEMORIA_RAM_CODIGO, m.MICROPROCESADOR_CODIGO
	FROM gd_esquema.Maestra m
	LEFT JOIN '+@sch+'.Gabinete g 
	ON m.PC_ALTO=g.gabinete_alto AND m.PC_ANCHO=g.gabinete_ancho AND m.PC_PROFUNDIDAD=g.gabinete_profundidad
	LEFT JOIN '+@sch+'.PlacaVideo p 
	ON m.PLACA_VIDEO_MODELO=p.placa_video_modelo AND m.PLACA_VIDEO_CHIPSET=p.placa_video_chipset AND m.PLACA_VIDEO_CAPACIDAD=p.placa_video_capacidad AND m.PLACA_VIDEO_VELOCIDAD=p.placa_video_velocidad
	WHERE m.PC_CODIGO IS NOT NULL AND m.COMPRA_PRECIO IS NOT NULL AND m.DISCO_RIGIDO_CODIGO IS NOT NULL AND m.MEMORIA_RAM_CODIGO IS NOT NULL AND m.MICROPROCESADOR_CODIGO IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

SELECT @tab = 'CompraAccesorio';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (compra_accesorio_cantidad,accesorio_codigo,compra_numero)
	SELECT SUM(m.COMPRA_CANTIDAD),m.ACCESORIO_CODIGO, m.COMPRA_NUMERO
	FROM gd_esquema.Maestra m
	WHERE ACCESORIO_CODIGO IS NOT NULL AND COMPRA_NUMERO IS NOT NULL
	GROUP BY m.ACCESORIO_CODIGO, m.COMPRA_NUMERO;'

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

/*4*/
SELECT @tab = 'CompraPc';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (compra_numero,compra_pc_precio,compra_pc_cantidad,pc_codigo)
	SELECT DISTINCT m.COMPRA_NUMERO, m.COMPRA_PRECIO ,m.COMPRA_CANTIDAD,m.PC_CODIGO
	FROM gd_esquema.Maestra m
	WHERE COMPRA_NUMERO IS NOT NULL AND COMPRA_PRECIO IS NOT NULL AND COMPRA_CANTIDAD IS NOT NULL AND PC_CODIGO IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'Factura';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (factura_numero,factura_fecha,sucursal_id,cliente_id)
	SELECT DISTINCT m.FACTURA_NUMERO, m.FACTURA_FECHA,s.sucursal_id,c.cliente_id
	FROM gd_esquema.Maestra m
	JOIN '+@sch+'.Sucursal s 
	ON s.sucursal_ciudad=m.CIUDAD AND s.sucursal_direccion=m.SUCURSAL_DIR AND s.sucursal_mail=m.SUCURSAL_MAIL AND s.sucursal_telefono=m.SUCURSAL_TEL
	LEFT JOIN '+@sch+'.Cliente c ON m.CLIENTE_DNI=c.cliente_dni AND m.CLIENTE_APELLIDO=c.cliente_apellido AND m.CLIENTE_NOMBRE=c.cliente_nombre AND m.CLIENTE_FECHA_NACIMIENTO=c.cliente_fecha_nacimiento AND m.CLIENTE_DIRECCION=c.cliente_direccion AND m.CLIENTE_TELEFONO=c.cliente_telefono AND m.CLIENTE_MAIL=c.cliente_mail
	WHERE m.FACTURA_NUMERO IS NOT NULL AND m.FACTURA_FECHA IS NOT NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

/*5*/
SELECT @tab = 'FacturaPc';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (factura_numero,pc_codigo)
	SELECT DISTINCT m.FACTURA_NUMERO,m.PC_CODIGO
	FROM gd_esquema.Maestra m
	WHERE FACTURA_NUMERO IS NOT NULL AND PC_CODIGO IS NOT NULL AND m.COMPRA_NUMERO IS NULL;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;


SELECT @tab = 'FacturaAccesorio';

SELECT @SQL = 'INSERT INTO '+@sch+'.'+@tab+' (factura_numero,accesorio_codigo,factura_accesorio_cantidad,factura_accesorio_precio)
	SELECT m.FACTURA_NUMERO,a.accesorio_codigo,COUNT(1),SUM(a.accesorio_precio*1.2)
	FROM gd_esquema.Maestra m
	JOIN '+@sch+'.Accesorio a ON m.ACCESORIO_CODIGO=a.accesorio_codigo
	WHERE m.FACTURA_NUMERO IS NOT NULL AND m.ACCESORIO_CODIGO IS NOT NULL
	GROUP BY m.FACTURA_NUMERO,a.accesorio_codigo;';

PRINT '
Completando... '+ @tab;
EXEC sp_executesql @SQL;

/*update*/

SELECT @tab = 'Factura';

/* con Pc */
SELECT @SQL = 'WITH temporal AS (
	SELECT f.factura_precio, p.pc_precio as precio
	FROM '+@sch+'.'+@tab+' f
	LEFT JOIN '+@sch+'.FacturaPc fp ON f.factura_numero=fp.factura_numero
	LEFT JOIN '+@sch+'.Pc p ON fp.pc_codigo=p.pc_codigo
)
UPDATE temporal SET factura_precio=precio
WHERE factura_precio IS NULL;';

PRINT '
UPDATE... '+@tab+' con Pc';
EXEC sp_executesql @SQL;

/* con Accesorios */
SELECT @SQL = 'WITH temporal AS (
	SELECT ff.factura_precio, a.precio
	FROM '+@sch+'.'+@tab+' ff 
	LEFT JOIN (SELECT f.factura_numero, SUM(fa.factura_accesorio_precio) as precio 
	FROM '+@sch+'.'+@tab+' f
	LEFT JOIN '+@sch+'.FacturaAccesorio fa ON f.factura_numero=fa.factura_numero
	GROUP BY f.factura_numero) a ON ff.factura_numero=a.factura_numero 
)
UPDATE temporal SET factura_precio=precio
WHERE factura_precio IS NULL;';

PRINT '
UPDATE... '+@tab+' con Accesorios';
EXEC sp_executesql @SQL;


SELECT @tab = 'Compra';

/* con Pc */
SELECT @SQL = 'WITH temporal AS (
	SELECT c.compra_precio, cp.compra_pc_precio as precio
	FROM '+@sch+'.'+@tab+' c
	LEFT JOIN '+@sch+'.CompraPc cp ON c.compra_numero=cp.compra_numero
)
UPDATE temporal SET compra_precio=precio
WHERE compra_precio IS NULL;';

PRINT '
UPDATE... '+@tab+' con Pc';
EXEC sp_executesql @SQL;

/* con Accesorios */
SELECT @SQL = 'WITH temporal AS (
	SELECT cc.compra_precio, a.precio
	FROM '+@sch+'.'+@tab+' cc 
	LEFT JOIN (SELECT c.compra_numero, SUM(ca.compra_accesorio_cantidad*ac.accesorio_precio) as precio 
				FROM '+@sch+'.'+@tab+' c
				LEFT JOIN '+@sch+'.CompraAccesorio ca ON c.compra_numero=ca.compra_numero
				LEFT JOIN '+@sch+'.Accesorio ac ON ca.accesorio_codigo = ac.accesorio_codigo
				GROUP BY c.compra_numero) a ON cc.compra_numero=a.compra_numero 
)
UPDATE temporal SET compra_precio=precio
WHERE compra_precio IS NULL;';

PRINT '
UPDATE... '+@tab+' con Accesorios';
EXEC sp_executesql @SQL;

END
GO

/* Reviso la existencia de cada tabla dentro del esquema */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
/*5*/
EXEC CFJV_TEAM.checkTabla @grupo,'FacturaPc'
EXEC CFJV_TEAM.checkTabla @grupo,'FacturaAccesorio'
/*4*/
EXEC CFJV_TEAM.checkTabla @grupo ,'CompraPc'
EXEC CFJV_TEAM.checkTabla @grupo,'Factura'
/*3*/
EXEC CFJV_TEAM.checkTabla @grupo ,'Pc'
EXEC CFJV_TEAM.checkTabla @grupo,'CompraAccesorio'
/*2*/
EXEC CFJV_TEAM.checkTabla @grupo ,'Accesorio'
EXEC CFJV_TEAM.checkTabla @grupo ,'Microprocesador'
EXEC CFJV_TEAM.checkTabla @grupo,'MemoriaRAM'
EXEC CFJV_TEAM.checkTabla @grupo ,'DiscoRigido'
EXEC CFJV_TEAM.checkTabla @grupo ,'PlacaVideo'
EXEC CFJV_TEAM.checkTabla @grupo ,'Gabinete'
EXEC CFJV_TEAM.checkTabla @grupo ,'Compra'
/*1*/
EXEC CFJV_TEAM.checkTabla @grupo ,'Fabricante'
EXEC CFJV_TEAM.checkTabla @grupo ,'Sucursal'
EXEC CFJV_TEAM.checkTabla @grupo ,'Cliente'
GO

/* Creo las todas las tablas del modelo */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC CFJV_TEAM.crearEntidades @grupo
GO

/* Cargo las tablas con los datos iniciales */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC CFJV_TEAM.completandoEntidades @grupo
GO

/* Elimino todos lo procedimientos creados */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC checkProced @grupo,'checkTabla'
EXEC checkProced @grupo,'crearEntidades'
EXEC checkProced @grupo,'completandoEntidades'
DROP PROCEDURE dbo.checkProced;
PRINT 'Eliminando procedure... checkProced'
GO