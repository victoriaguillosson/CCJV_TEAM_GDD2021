USE [GD1C2021]
GO

/*Dimensiones*/
IF EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE
	object_id = OBJECT_ID (N'CFJV_TEAM.[CALCULAR_EDAD]')
	AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	BEGIN 
	DROP FUNCTION CFJV_TEAM.[CALCULAR_EDAD]
	END

IF EXISTS (SELECT TOP 1 1 FROM sys.objects WHERE
	object_id = OBJECT_ID(N'CFJV_TEAM.[CALCULAR_CATEGORIA_EDAD]')
         AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
	BEGIN
	DROP FUNCTION CFJV_TEAM.[CALCULAR_CATEGORIA_EDAD]
	END

GO

CREATE FUNCTION CFJV_TEAM.[CALCULAR_EDAD]
	(@FECHA_NACIMIENTO DATE)
RETURNS INT
AS BEGIN 
	DECLARE @retorno INT
	SET @retorno = YEAR(GETDATE()) - YEAR(@FECHA_NACIMIENTO)
	RETURN @retorno
END

GO

CREATE FUNCTION CFJV_TEAM.[CALCULAR_CATEGORIA_EDAD]
 (@edad  INT) 
RETURNS nvarchar(20)
AS BEGIN 
    DECLARE @retorno nvarchar(20)

    SET @retorno = case when @edad BETWEEN 18 AND 30 then 'Joven'
                        when @edad BETWEEN 31 AND 50 then 'Adulto'
                          else 'AdultoMayor'
                   end
    RETURN @retorno
END

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

/* Reviso la existencia del procedimiento checkView */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC checkProced @grupo,'checkView'
GO

/* Creo procedimiento checkView, que revisa la existencia de una vista */
CREATE PROCEDURE CFJV_TEAM.checkView(@view VARCHAR(50))
AS
IF EXISTS (SELECT * FROM sys.objects AS so WHERE so.object_id = OBJECT_ID(@view) AND type_desc='VIEW')
	BEGIN
		PRINT 'Eliminando view '+@view;
		EXEC('DROP VIEW '+@view);
	END
ELSE
	PRINT 'view '+@view+' NO EXISTE';
GO

/* Reviso la existencia del procedimiento crearDimensiones */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC checkProced @grupo,'crearDimensiones'
GO

/*Este procedimiento crea las tablas de nuestro modelo BI*/
CREATE PROCEDURE CFJV_TEAM.crearDimensiones
AS
DECLARE @SQL NVARCHAR(MAX);
BEGIN

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_CLIENTE](
				[CLIENTE_ID] INT PRIMARY KEY,
				[CLIENTE_DNI] [decimal](18, 0),
				[CLIENTE_APELLIDO] [nvarchar](255),
				[CLIENTE_NOMBRE] [nvarchar](255),
				[CLIENTE_DIRECCION] [nvarchar](255),		
				[CLIENTE_EDAD] int,
				[CLASIFICACION_EDAD] [nvarchar] (20)
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[TIEMPO](
				[CODIGO_FECHA] int NOT NULL PRIMARY KEY,
				[MES] char(2),
				[ANIO] char(4)
				)';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_SUCURSAL](
				[SUCURSAL_ID] INT IDENTITY(1,1) PRIMARY KEY,
				[SUCURSAL_DIRECCION] [nvarchar](255) NULL,
				[SUCURSAL_MAIL] [nvarchar](255) NULL,
				[SUCURSAL_TELEFONO] [decimal](18, 0) NULL,
				[SUCURSAL_CIUDAD] [nvarchar](255) NULL
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_FABRICANTE](
				[FABRICANTE_ID] INT PRIMARY KEY,
				[FABRICANTE_NOMBRE] [nvarchar](255) 
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_ACCESORIO](
				[ACCESORIO_CODIGO] [decimal](18, 0) PRIMARY KEY,
				[ACCESORIO_DESCRIPCION] [nvarchar](255) ,
				[ACCESORIO_PRECIO] decimal(18,2) NULL,
				[FABRICANTE_ID] INT REFERENCES CFJV_TEAM.[BI_FABRICANTE]
			) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_MOTHERBOARD](
				[MOTHERBOARD_ID] [nvarchar](50) PRIMARY KEY,	
				BI_FABRICANTE_ID int NULL REFERENCES CFJV_TEAM.[BI_FABRICANTE]
				)';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_GABINETE](
				[GABINETE_CODIGO] int PRIMARY KEY,
				BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_PLACA_VIDEO](
				[PLACA_VIDEO_CODIGO] int PRIMARY KEY,
				BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_MICROPROCESADOR](
				[MICROPROCESADOR_CODIGO] [nvarchar](50) PRIMARY KEY,
				BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_DISCO_RIGIDO](
				[DISCO_RIGIDO_CODIGO] [nvarchar](255) PRIMARY KEY,
				BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_MEMORIA_RAM](
				[MEMORIA_RAM_CODIGO] [nvarchar](255) PRIMARY KEY,
				BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_PC](
				[PC_CODIGO] [nvarchar](50) PRIMARY KEY,
				[PC_NUMERO_SERIE] [nvarchar](50) NULL,
				BI_MICROPROCESADOR_CODIGO [nvarchar](50) NULL REFERENCES CFJV_TEAM.[BI_MICROPROCESADOR],
				BI_GABINETE_CODIGO INT REFERENCES CFJV_TEAM.[BI_GABINETE],
				BI_PLACA_VIDEO_CODIGO INT REFERENCES CFJV_TEAM.[BI_PLACA_VIDEO],
				BI_MEMORIA_RAM_CODIGO [nvarchar](255) NULL REFERENCES CFJV_TEAM.[BI_MEMORIA_RAM],
				BI_DISCO_RIGIDO_CODIGO [nvarchar](255) NULL REFERENCES CFJV_TEAM.[BI_DISCO_RIGIDO],
				BI_MOTHERBOARD_ID [nvarchar](50) NULL REFERENCES CFJV_TEAM.[BI_MOTHERBOARD]
				) ON [PRIMARY]';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_COMPRAS](
				[BI_COMPRA_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
				[BI_COMPRA_NRO] [decimal](18, 0),
				[BI_COMPRA_FECHA] datetime2(3),
				[BI_SUCURSAL_CODIGO] INT REFERENCES CFJV_TEAM.[BI_SUCURSAL],
				[BI_COMPRA_TIEMPO_ID] INT NULL REFERENCES CFJV_TEAM.[TIEMPO],
				[BI_COMPRA_PRECIO] [decimal](18, 2),
				[BI_COMPRA_PC_CODIGO] [nvarchar](50) NULL REFERENCES CFJV_TEAM.[BI_PC],
				[BI_COMPRA_ACCESORIO_CODIGO] [decimal](18, 0) NULL REFERENCES CFJV_TEAM.[BI_ACCESORIO],
				[BI_COMPRA_CANTIDAD_ACCESORIOS] INT NULL 
				)';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE TABLE CFJV_TEAM.[BI_VENTAS](
				[VENTA_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
				[BI_FACTURA_NUMERO] [decimal](18, 0),
				[BI_SUCURSAL_CODIGO] INT REFERENCES CFJV_TEAM.[BI_SUCURSAL],
				[BI_VENTA_FECHA] datetime2(3),
				[BI_VENTA_TIEMPO_ID] INT NULL REFERENCES CFJV_TEAM.[TIEMPO],
				[BI_VENTA_CLIENTE_ID] INT REFERENCES CFJV_TEAM.[BI_CLIENTE],
				[BI_VENTA_PRECIO] [decimal](18, 2),
				[BI_VENTA_PC_CODIGO] [nvarchar](50) NULL REFERENCES CFJV_TEAM.[BI_PC],
				[BI_VENTA_ACCESORIO_CODIGO] [decimal](18, 0) NULL REFERENCES CFJV_TEAM.[BI_ACCESORIO],
				[BI_VENTA_CANTIDAD_ACCESORIO] [decimal](18, 0) NULL 
				)';
EXEC sp_executesql @SQL;
END
GO

/* Reviso la existencia del procedimiento completarDimensiones */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC checkProced @grupo,'completarDimenciones'
GO

/*Este procedimiento hace inserts masivos para pasar los datos de las tablas del modelo de datos a nuestro modelo BI*/
CREATE PROCEDURE CFJV_TEAM.completarDimenciones
AS
DECLARE @SQL NVARCHAR(MAX);
BEGIN

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_CLIENTE (CLIENTE_ID,CLIENTE_DNI,CLIENTE_APELLIDO,CLIENTE_NOMBRE,CLIENTE_DIRECCION,CLIENTE_EDAD,CLASIFICACION_EDAD)
				SELECT c.CLIENTE_ID,c.CLIENTE_DNI,c.CLIENTE_APELLIDO,c.CLIENTE_NOMBRE, c.CLIENTE_DIRECCION, CFJV_TEAM.CALCULAR_EDAD(c.cliente_fecha_nacimiento),CFJV_TEAM.CALCULAR_CATEGORIA_EDAD(CFJV_TEAM.CALCULAR_EDAD(c.cliente_fecha_nacimiento))
				FROM  CFJV_TEAM.CLIENTE c';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_SUCURSAL(SUCURSAL_DIRECCION,SUCURSAL_MAIL,SUCURSAL_TELEFONO, SUCURSAL_CIUDAD)
				SELECT s.SUCURSAL_DIRECCION,s.SUCURSAL_MAIL,s.SUCURSAL_TELEFONO, s.SUCURSAL_CIUDAD
				FROM CFJV_TEAM.SUCURSAL s';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_FABRICANTE(FABRICANTE_ID,FABRICANTE_NOMBRE)
				SELECT f.fabricante_id, f.nombre
				FROM CFJV_TEAM.FABRICANTE f';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_ACCESORIO(ACCESORIO_CODIGO,ACCESORIO_DESCRIPCION,ACCESORIO_PRECIO)
				SELECT a.accesorio_codigo, a.accesorio_descripcion, a.accesorio_precio
				FROM CFJV_TEAM.Accesorio a';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_GABINETE(GABINETE_CODIGO,BI_FABRICANTE_ID)
				SELECT g.gabinete_codigo, g.fabricante_id
				FROM CFJV_TEAM.Gabinete g';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_PLACA_VIDEO(PLACA_VIDEO_CODIGO, BI_FABRICANTE_ID)
				SELECT pv.placa_video_codigo, pv.fabricante_id
				FROM CFJV_TEAM.PlacaVideo pv';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_MICROPROCESADOR(MICROPROCESADOR_CODIGO,BI_FABRICANTE_ID)
				SELECT m.microprocesador_codigo, m.fabricante_id
				FROM CFJV_TEAM.Microprocesador m';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_DISCO_RIGIDO(DISCO_RIGIDO_CODIGO,BI_FABRICANTE_ID)
				SELECT d.disco_rigido_codigo, d.fabricante_id
				FROM CFJV_TEAM.DiscoRigido d';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_MEMORIA_RAM(MEMORIA_RAM_CODIGO, BI_FABRICANTE_ID)
				SELECT m.memoria_ram_codigo, m.fabricante_id
				FROM CFJV_TEAM.MemoriaRam m';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_PC(PC_CODIGO,PC_NUMERO_SERIE,BI_GABINETE_CODIGO,BI_DISCO_RIGIDO_CODIGO,BI_MEMORIA_RAM_CODIGO,BI_MICROPROCESADOR_CODIGO,BI_MOTHERBOARD_ID,BI_PLACA_VIDEO_CODIGO)
				SELECT p.pc_codigo, p.pc_numero_serie, p.gabinete_codigo, p.disco_rigido_codigo, p.memoria_ram_codigo, p.microprocesador_codigo, p.pc_motherboard, p.placa_video_codigo
				FROM CFJV_TEAM.Pc p';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.BI_COMPRAS(BI_COMPRA_NRO,BI_COMPRA_FECHA, BI_SUCURSAL_CODIGO, BI_COMPRA_PRECIO, BI_COMPRA_PC_CODIGO, BI_COMPRA_ACCESORIO_CODIGO, BI_COMPRA_CANTIDAD_ACCESORIOS)
				SELECT c.compra_numero, c.compra_fecha, c.sucursal_id, c.compra_precio, cp.pc_codigo,ca.accesorio_codigo,ca.compra_accesorio_cantidad
				FROM CFJV_TEAM.Compra c
				LEFT JOIN CFJV_TEAM.CompraPc cp ON (cp.compra_numero=c.compra_numero)
				LEFT JOIN CFJV_TEAM.CompraAccesorio ca ON ca.compra_numero=c.compra_numero';
EXEC sp_executesql @SQL;

SELECT @SQL = 'INSERT INTO CFJV_TEAM.[BI_VENTAS](BI_FACTURA_NUMERO,BI_SUCURSAL_CODIGO,BI_VENTA_FECHA,BI_VENTA_CLIENTE_ID,BI_VENTA_PRECIO,BI_VENTA_PC_CODIGO,BI_VENTA_ACCESORIO_CODIGO,BI_VENTA_CANTIDAD_ACCESORIO)
				SELECT f.factura_numero, f.sucursal_id, f.factura_fecha, f.cliente_id, f.factura_precio, fpc.pc_codigo, fa.accesorio_codigo, fa.factura_accesorio_cantidad
				FROM CFJV_TEAM.Factura f
				LEFT JOIN CFJV_TEAM.FacturaPc fpc ON (fpc.factura_numero = f.factura_numero)
				LEFT JOIN CFJV_TEAM.FacturaAccesorio fa ON (fa.factura_numero = f.factura_numero)';
EXEC sp_executesql @SQL;
END
GO

/* Reviso la existencia del procedimiento crearViews*/
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
EXEC checkProced @grupo,'crearViews'
GO

/*Este procedimiento hace inserts masivos para pasar los datos de las tablas del modelo de datos a nuestro modelo BI*/
CREATE PROCEDURE CFJV_TEAM.crearViews
AS
BEGIN

DECLARE @SQL NVARCHAR(MAX);

--Vistas para pcs

SELECT @SQL = 'CREATE VIEW PrecioPromedioPCVendidasCompradas
				AS
				SELECT SUM(v.BI_VENTA_PRECIO) / COUNT(v.BI_FACTURA_NUMERO) precioPromedioVendido, AVG(c.BI_COMPRA_PRECIO) precioPromedioComprado, c.BI_COMPRA_PC_CODIGO
				FROM CFJV_TEAM.BI_COMPRAS c
				JOIN CFJV_TEAM.BI_VENTAS v ON (v.BI_VENTA_PC_CODIGO = c.BI_COMPRA_PC_CODIGO)
				GROUP BY c.BI_COMPRA_PC_CODIGO';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE VIEW PCVendidasCompradasPorSucursalMes
				AS
				SELECT COUNT(c.BI_COMPRA_NRO) cantidadCompra,COUNT(v.BI_FACTURA_NUMERO) cantidadVendida,c.BI_SUCURSAL_CODIGO,MONTH(v.BI_VENTA_FECHA) mes,YEAR(v.BI_VENTA_FECHA) anio
				FROM CFJV_TEAM.BI_COMPRAS c
				JOIN CFJV_TEAM.BI_VENTAS v ON (c.BI_COMPRA_PC_CODIGO = v.BI_VENTA_PC_CODIGO)
				GROUP BY c.BI_SUCURSAL_CODIGO,MONTH(v.BI_VENTA_FECHA),YEAR(v.BI_VENTA_FECHA)';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE VIEW GananciasPrecioVentaCompraPorSucursalPorMes
				AS
				SELECT SUM(v.BI_VENTA_PRECIO) - SUM(c.BI_COMPRA_PRECIO) ganancia, c.BI_SUCURSAL_CODIGO, MONTH(v.BI_VENTA_FECHA) mesFactura, YEAR(v.BI_VENTA_FECHA) anioFactura
				FROM CFJV_TEAM.BI_COMPRAS c
				JOIN CFJV_TEAM.BI_VENTAS v ON (c.BI_COMPRA_PC_CODIGO = v.BI_VENTA_PC_CODIGO)
				GROUP BY c.BI_SUCURSAL_CODIGO,MONTH(v.BI_VENTA_FECHA), YEAR(v.BI_VENTA_FECHA)';
EXEC sp_executesql @SQL;

--Vistas para accesorios

SELECT @SQL = 'CREATE VIEW Precio_promedio_Accesorio
				AS
				SELECT c.BI_COMPRA_ACCESORIO_CODIGO, SUM(v.BI_VENTA_PRECIO) / COUNT(v.BI_FACTURA_NUMERO) precioPromedioVendido,AVG(c.BI_COMPRA_PRECIO) precioPromedioComprado 
				FROM CFJV_TEAM.BI_COMPRAS c
				JOIN CFJV_TEAM.BI_VENTAS v ON (v.BI_VENTA_ACCESORIO_CODIGO = c.BI_COMPRA_ACCESORIO_CODIGO)
				WHERE c.BI_COMPRA_ACCESORIO_CODIGO is not null and v.BI_VENTA_ACCESORIO_CODIGO is not null
				GROUP BY c.BI_COMPRA_ACCESORIO_CODIGO';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE VIEW Ganancias_Accesorios_vendidos
				AS
				SELECT SUM(v.BI_VENTA_PRECIO) - SUM(c.BI_COMPRA_PRECIO) ganancia, c.BI_SUCURSAL_CODIGO, MONTH(v.BI_VENTA_FECHA) mesFactura, YEAR(v.BI_VENTA_FECHA) anioFactura
				FROM CFJV_TEAM.BI_COMPRAS c 
				JOIN CFJV_TEAM.BI_VENTAS v ON (v.BI_VENTA_ACCESORIO_CODIGO = c.BI_COMPRA_ACCESORIO_CODIGO)
				WHERE c.BI_COMPRA_ACCESORIO_CODIGO is not null and v.BI_VENTA_ACCESORIO_CODIGO is not null
				GROUP BY c.BI_SUCURSAL_CODIGO, MONTH(v.BI_VENTA_FECHA), YEAR(v.BI_VENTA_FECHA)';
EXEC sp_executesql @SQL;

SELECT @SQL = 'CREATE VIEW Maximo_stock_por_sucursal_Accesorios
				AS
				SELECT MAX(STOCK_DISPONIBLE) Max_Stock, BI_COMPRA_ACCESORIO_CODIGO, s.SUCURSAL_ID, SUCURSAL_DIRECCION, YEAR(BI_COMPRA_FECHA) anio
				FROM (SELECT SUM(BI_COMPRA_CANTIDAD_ACCESORIOS) STOCK_DISPONIBLE,
					BI_SUCURSAL_CODIGO, BI_COMPRA_FECHA, BI_COMPRA_ACCESORIO_CODIGO FROM CFJV_TEAM.BI_COMPRAS c
					GROUP BY BI_SUCURSAL_CODIGO, BI_COMPRA_FECHA, BI_COMPRA_ACCESORIO_CODIGO) subq
				JOIN CFJV_TEAM.BI_SUCURSAL s ON (s.SUCURSAL_ID = subq.BI_SUCURSAL_CODIGO)
				WHERE subq.BI_COMPRA_ACCESORIO_CODIGO is not null
				GROUP BY BI_COMPRA_ACCESORIO_CODIGO, s.SUCURSAL_ID, SUCURSAL_DIRECCION, YEAR(BI_COMPRA_FECHA)';
EXEC sp_executesql @SQL;
END
GO

/* Reviso la existencia de cada tabla dentro del esquema */
DECLARE @grupo VARCHAR(50)= 'CFJV_TEAM'
/*4*/
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_COMPRAS'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_VENTAS'
/*3*/
EXEC CFJV_TEAM.checkTabla @grupo,'BI_PC'
EXEC CFJV_TEAM.checkTabla @grupo,'BI_ACCESORIO'
/*2*/
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_MOTHERBOARD'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_MEMORIA_RAM'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_DISCO_RIGIDO'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_PLACA_VIDEO'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_GABINETE'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_MICROPROCESADOR'
/*1*/
EXEC CFJV_TEAM.checkTabla @grupo ,'TIEMPO'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_SUCURSAL'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_CLIENTE'
EXEC CFJV_TEAM.checkTabla @grupo ,'BI_FABRICANTE'
GO

/*Creo las tablas del modelo BI*/
EXEC CFJV_TEAM.crearDimensiones
GO

/*Cargo las tablas del modelo BI*/
EXEC CFJV_TEAM.completarDimenciones
GO

/* Reviso la existencia de Views*/
/*Views para PC*/
EXEC CFJV_TEAM.checkView 'PrecioPromedioPCVendidasCompradas'
EXEC CFJV_TEAM.checkView 'PCVendidasCompradasPorSucursalMes'
EXEC CFJV_TEAM.checkView 'GananciasPrecioVentaCompraPorSucursalPorMes'
--EXEC CFJV_TEAM.checkView 'para el tiempo stock promedio PC'
GO
/*Views para Accesorios*/
EXEC CFJV_TEAM.checkView 'Precio_promedio_Accesorio'
EXEC CFJV_TEAM.checkView 'Ganancias_Accesorios_vendidos'
EXEC CFJV_TEAM.checkView 'Maximo_stock_por_sucursal_Accesorios'
--EXEC CFJV_TEAM.checkView 'para el tiempo stock promedio ACCESORIOS'
GO

/*Creo las views*/
EXEC CFJV_TEAM.crearViews
