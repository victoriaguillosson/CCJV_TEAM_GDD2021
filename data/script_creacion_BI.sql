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

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_SUCURSAL_CODIGO_COMPRAS')  )
	ALTER TABLE CFJV_TEAM.[COMPRAS] DROP CONSTRAINT FK_SUCURSAL_CODIGO_COMPRAS

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_PC_CODIGO_COMPRAS')  )
	ALTER TABLE CFJV_TEAM.[COMPRAS] DROP CONSTRAINT FK_PC_CODIGO_COMPRAS

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_ACCESORIO_COMPRAS')  )
	ALTER TABLE CFJV_TEAM.[COMPRAS] DROP CONSTRAINT FK_ACCESORIO_COMPRAS

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_SUCURSAL_CODIGO_VENTAS')  )
	ALTER TABLE CFJV_TEAM.[VENTAS] DROP CONSTRAINT FK_SUCURSAL_CODIGO_VENTAS

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_PC_CODIGO_VENTAS')  )
	ALTER TABLE CFJV_TEAM.[VENTAS] DROP CONSTRAINT FK_PC_CODIGO_VENTAS

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_BI_ACCESORIO_CODIGO')  )
	ALTER TABLE CFJV_TEAM.[VENTAS] DROP CONSTRAINT FK_BI_ACCESORIO_CODIGO

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_CLIENTE_CODIGO_VENTAS')  )
	ALTER TABLE CFJV_TEAM.[VENTAS] DROP CONSTRAINT FK_CLIENTE_CODIGO_VENTAS

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_BI_FABRICANTE_CODIGO_ACCESORIO')  )
	ALTER TABLE CFJV_TEAM.[BI_ACCESORIO] DROP CONSTRAINT FK_BI_FABRICANTE_CODIGO_ACCESORIO

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_BI_FABRICANTE_ID')  )
	ALTER TABLE CFJV_TEAM.[BI_MOTHERBOARD] DROP CONSTRAINT FK_BI_FABRICANTE_ID

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_BI_FABRICANTE_ID')  )
	ALTER TABLE CFJV_TEAM.[BI_GABINETE] DROP CONSTRAINT FK_BI_FABRICANTE_ID

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_BI_FABRICANTE_ID')  )
	ALTER TABLE CFJV_TEAM.[BI_MICROPROCESADOR] DROP CONSTRAINT FK_BI_FABRICANTE_ID

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_BI_FABRICANTE_ID')  )
	ALTER TABLE CFJV_TEAM.[BI_PLACA_DE_VIDEO] DROP CONSTRAINT FK_BI_FABRICANTE_ID

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_BI_FABRICANTE_ID')  )
	ALTER TABLE CFJV_TEAM.[BI_MEMORIA_RAM] DROP CONSTRAINT FK_BI_FABRICANTE_ID

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.FK_BI_FABRICANTE_ID')  )
	ALTER TABLE CFJV_TEAM.[BI_DISCO_RIGIDO] DROP CONSTRAINT FK_BI_FABRICANTE_ID

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.BI_MOTHERBOARD_ID')  )
	ALTER TABLE CFJV_TEAM.[BI_PC] DROP CONSTRAINT BI_MOTHERBOARD_ID

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.BI_GABINETE_CODIGO')  )
	ALTER TABLE CFJV_TEAM.[BI_PC] DROP CONSTRAINT BI_GABINETE_CODIGO

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.BI_PROCESADOR_CODIGO')  )
	ALTER TABLE CFJV_TEAM.[BI_PC] DROP CONSTRAINT BI_PROCESADOR_CODIGO

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.BI_PLACA_VIDEO_CODIGO')  )
	ALTER TABLE CFJV_TEAM.[BI_PC] DROP CONSTRAINT BI_PLACA_VIDEO_CODIGO

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.BI_MEMORIA_RAM_CODIGO')  )
	ALTER TABLE CFJV_TEAM.[BI_PC] DROP CONSTRAINT BI_MEMORIA_RAM_CODIGO

	IF EXISTS (  SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'CFJV_TEAM.BI_DISCO_RIGIDO_CODIGO')  )
	ALTER TABLE CFJV_TEAM.[BI_PC] DROP CONSTRAINT BI_DISCO_RIGIDO_CODIGO

	IF OBJECT_ID('CFJV_TEAM.[BI_CLIENTE]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_CLIENTE]

	IF OBJECT_ID('CFJV_TEAM.[TIEMPO]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[TIEMPO]
	
	IF OBJECT_ID('CFJV_TEAM.[BI_SUCURSAL]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_SUCURSAL]

	IF OBJECT_ID('CFJV_TEAM.[BI_PC]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_PC]

	IF OBJECT_ID('CFJV_TEAM.[BI_ACCESORIO]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_ACCESORIO]

	IF OBJECT_ID('CFJV_TEAM.[BI_GABINETE]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_GABINETE]

	IF OBJECT_ID('CFJV_TEAM.[BI_PLACA_VIDEO]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_PLACA_VIDEO]

	IF OBJECT_ID('CFJV_TEAM.[BI_MICROPROCESADOR]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_MICROPROCESADOR]

	IF OBJECT_ID('CFJV_TEAM.[BI_DISCO_RIGIDO]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_DISCO_RIGIDO]

	IF OBJECT_ID('CFJV_TEAM.[BI_MEMORIA_RAM]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_MEMORIA_RAM]

	IF OBJECT_ID('CFJV_TEAM.[BI_MOTHERBOARD]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_MOTHERBOARD]
	
	IF OBJECT_ID('CFJV_TEAM.[BI_COMPRAS]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_COMPRAS]

	IF OBJECT_ID('CFJV_TEAM.[BI_VENTAS]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_VENTAS]

	IF OBJECT_ID('CFJV_TEAM.[BI_FABRICANTE]', 'U') IS NOT NULL 
	DROP TABLE CFJV_TEAM.[BI_FABRICANTE]

	--Pc

	IF EXISTS (SELECT * FROM sys.views WHERE name = 'PromedioTiempoEnStockModeloPC' AND type = 'C')
	DROP VIEW PromedioTiempoEnStockModeloPC

	IF EXISTS (SELECT * FROM sys.views WHERE name = 'PrecioPromedioPCVendidasCompradas' AND type = 'C')
	DROP VIEW PrecioPromedioPCVendidasCompradas

	IF EXISTS (SELECT * FROM sys.views WHERE name = 'PCVendidasCompradasPorSucursalMes' AND type = 'C')
	DROP VIEW PCVendidasCompradasPorSucursalMes

	IF EXISTS (SELECT * FROM sys.views WHERE name = 'GananciasPrecioVentaCompraPorSucursalPorMes' AND type = 'C')
	DROP VIEW GananciasPrecioVentaCompraPorSucursalPorMes

	--Accesorio

	IF EXISTS (SELECT * FROM sys.views WHERE name = 'Promedio_tiempo_en_stock_Accesorios' AND type = 'V')
	DROP VIEW dbo.Promedio_tiempo_en_stock_Accesorios

	IF EXISTS (SELECT * FROM sys.views WHERE name = 'Precio_promedio_Accesorio' AND type = 'V') 
	DROP VIEW dbo.Precio_promedio_Accesorio

	IF EXISTS (SELECT * FROM sys.views WHERE name = 'Ganancias_Accesorios_vendidos' AND type = 'V') 
	DROP VIEW dbo.Ganancias_Accesorios_vendidos

	IF EXISTS (SELECT * FROM sys.views WHERE name = 'Maximo_stock_por_sucursal_Accesorios' AND type = 'V') 
	DROP VIEW dbo.Maximo_stock_por_sucursal_Accesorios
	
GO

CREATE TABLE CFJV_TEAM.[BI_CLIENTE](
	[CLIENTE_ID] INT IDENTITY(1,1) PRIMARY KEY,
	[CLIENTE_DNI] [decimal](18, 0),
	[CLIENTE_APELLIDO] [nvarchar](255),
	[CLIENTE_NOMBRE] [nvarchar](255),
	[CLIENTE_DIRECCION] [nvarchar](255),		
	[CLIENTE_EDAD] int,
	[CLASIFICACION_EDAD] [nvarchar] (20)
) ON [PRIMARY]

INSERT INTO CFJV_TEAM.BI_CLIENTE (CLIENTE_DNI,CLIENTE_APELLIDO,CLIENTE_NOMBRE,CLIENTE_DIRECCION,CLIENTE_EDAD,CLASIFICACION_EDAD)
SELECT c.CLIENTE_DNI,c.CLIENTE_APELLIDO,c.CLIENTE_NOMBRE, c.CLIENTE_DIRECCION, CFJV_TEAM.CALCULAR_EDAD(c.cliente_fecha_nacimiento),CFJV_TEAM.CALCULAR_CATEGORIA_EDAD(CFJV_TEAM.CALCULAR_EDAD(c.cliente_fecha_nacimiento))
FROM  CFJV_TEAM.CLIENTE c

CREATE TABLE CFJV_TEAM.[TIEMPO](
	[CODIGO_FECHA] int NOT NULL PRIMARY KEY,
	[MES] char(2),
	[ANIO] char(4)
)

CREATE TABLE CFJV_TEAM.[BI_SUCURSAL](
	[SUCURSAL_ID] INT IDENTITY(1,1) PRIMARY KEY,
	[SUCURSAL_DIRECCION] [nvarchar](255) NULL,
	[SUCURSAL_MAIL] [nvarchar](255) NULL,
	[SUCURSAL_TELEFONO] [decimal](18, 0) NULL,
	[SUCURSAL_CIUDAD] [nvarchar](255) NULL
) ON [PRIMARY] 

INSERT INTO CFJV_TEAM.BI_SUCURSAL(SUCURSAL_DIRECCION,SUCURSAL_MAIL,SUCURSAL_TELEFONO, SUCURSAL_CIUDAD)
SELECT s.SUCURSAL_DIRECCION,s.SUCURSAL_MAIL,s.SUCURSAL_TELEFONO, s.SUCURSAL_CIUDAD
FROM CFJV_TEAM.SUCURSAL s

CREATE TABLE CFJV_TEAM.[BI_FABRICANTE](
	[FABRICANTE_ID] INT PRIMARY KEY,
	[FABRICANTE_NOMBRE] [nvarchar](255) 
) ON [PRIMARY] 

INSERT INTO CFJV_TEAM.BI_FABRICANTE(FABRICANTE_ID,FABRICANTE_NOMBRE)
SELECT f.fabricante_id, f.nombre
FROM CFJV_TEAM.FABRICANTE f

CREATE TABLE CFJV_TEAM.[BI_ACCESORIO](
	[ACCESORIO_CODIGO] [decimal](18, 0) PRIMARY KEY,
	[ACCESORIO_DESCRIPCION] [nvarchar](255) ,
	[ACCESORIO_PRECIO] decimal(18,2) NULL,
	[FABRICANTE_ID] INT REFERENCES CFJV_TEAM.[BI_FABRICANTE]
) ON [PRIMARY]

INSERT INTO CFJV_TEAM.BI_ACCESORIO(ACCESORIO_CODIGO,ACCESORIO_DESCRIPCION,ACCESORIO_PRECIO)
SELECT a.accesorio_codigo, a.accesorio_descripcion, a.accesorio_precio
FROM CFJV_TEAM.Accesorio a

CREATE TABLE CFJV_TEAM.[BI_MOTHERBOARD](
	[MOTHERBOARD_ID] [nvarchar](50) PRIMARY KEY,	
	BI_FABRICANTE_ID int NULL REFERENCES CFJV_TEAM.[BI_FABRICANTE]
)

/*  No hay datos d sobre motherboard en ningun lado
INSERT INTO CFJV_TEAM.BI_MOTHERBOARD(MOTHERBOARD_ID)
SELECT p.pc_motherboard
FROM CFJV_TEAM.Pc p
*/

CREATE TABLE CFJV_TEAM.[BI_GABINETE](
	[GABINETE_CODIGO] int PRIMARY KEY,
	BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
) ON [PRIMARY]

INSERT INTO CFJV_TEAM.BI_GABINETE(GABINETE_CODIGO,BI_FABRICANTE_ID)
SELECT g.gabinete_codigo, g.fabricante_id
FROM CFJV_TEAM.Gabinete g

CREATE TABLE CFJV_TEAM.[BI_PLACA_VIDEO](
	[PLACA_VIDEO_CODIGO] int PRIMARY KEY,
	BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
) ON [PRIMARY]

INSERT INTO CFJV_TEAM.BI_PLACA_VIDEO(PLACA_VIDEO_CODIGO, BI_FABRICANTE_ID)
SELECT pv.placa_video_codigo, pv.fabricante_id
FROM CFJV_TEAM.PlacaVideo pv

CREATE TABLE CFJV_TEAM.[BI_MICROPROCESADOR](
	[MICROPROCESADOR_CODIGO] [nvarchar](50) PRIMARY KEY,
	BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
) ON [PRIMARY]

INSERT INTO CFJV_TEAM.BI_MICROPROCESADOR(MICROPROCESADOR_CODIGO,BI_FABRICANTE_ID)
SELECT m.microprocesador_codigo, m.fabricante_id
FROM CFJV_TEAM.Microprocesador m

CREATE TABLE CFJV_TEAM.[BI_DISCO_RIGIDO](
	[DISCO_RIGIDO_CODIGO] [nvarchar](255) PRIMARY KEY,
	BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
) ON [PRIMARY]

INSERT INTO CFJV_TEAM.BI_DISCO_RIGIDO(DISCO_RIGIDO_CODIGO,BI_FABRICANTE_ID)
SELECT d.disco_rigido_codigo, d.fabricante_id
FROM CFJV_TEAM.DiscoRigido d

CREATE TABLE CFJV_TEAM.[BI_MEMORIA_RAM](
	[MEMORIA_RAM_CODIGO] [nvarchar](255) PRIMARY KEY,
	BI_FABRICANTE_ID int REFERENCES CFJV_TEAM.[BI_FABRICANTE]
) ON [PRIMARY]

INSERT INTO CFJV_TEAM.BI_MEMORIA_RAM(MEMORIA_RAM_CODIGO, BI_FABRICANTE_ID)
SELECT m.memoria_ram_codigo, m.fabricante_id
FROM CFJV_TEAM.MemoriaRam m

CREATE TABLE CFJV_TEAM.[BI_PC](
	[PC_CODIGO] [nvarchar](50) PRIMARY KEY,
	[PC_NUMERO_SERIE] [nvarchar](50) NULL,
	BI_MICROPROCESADOR_CODIGO [nvarchar](50) NULL REFERENCES CFJV_TEAM.[BI_MICROPROCESADOR],
	BI_GABINETE_CODIGO INT REFERENCES CFJV_TEAM.[BI_GABINETE],
	BI_PLACA_VIDEO_CODIGO INT REFERENCES CFJV_TEAM.[BI_PLACA_VIDEO],
	BI_MEMORIA_RAM_CODIGO [nvarchar](255) NULL REFERENCES CFJV_TEAM.[BI_MEMORIA_RAM],
	BI_DISCO_RIGIDO_CODIGO [nvarchar](255) NULL REFERENCES CFJV_TEAM.[BI_DISCO_RIGIDO],
	BI_MOTHERBOARD_ID [nvarchar](50) NULL REFERENCES CFJV_TEAM.[BI_MOTHERBOARD]
) ON [PRIMARY]

INSERT INTO CFJV_TEAM.BI_PC(PC_CODIGO,PC_NUMERO_SERIE,BI_GABINETE_CODIGO,BI_DISCO_RIGIDO_CODIGO,BI_MEMORIA_RAM_CODIGO,BI_MICROPROCESADOR_CODIGO,BI_MOTHERBOARD_ID,BI_PLACA_VIDEO_CODIGO)
SELECT p.pc_codigo, p.pc_numero_serie, p.gabinete_codigo, p.disco_rigido_codigo, p.memoria_ram_codigo, p.microprocesador_codigo, p.pc_motherboard, p.placa_video_codigo
FROM CFJV_TEAM.Pc p

CREATE TABLE CFJV_TEAM.[BI_COMPRAS](
	[BI_COMPRA_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[BI_COMPRA_NRO] [decimal](18, 0),
	[BI_COMPRA_FECHA] datetime2(3),
	[BI_SUCURSAL_CODIGO] INT REFERENCES CFJV_TEAM.[BI_SUCURSAL],
	[BI_COMPRA_TIEMPO_ID] INT NULL REFERENCES CFJV_TEAM.[TIEMPO],
	[BI_COMPRA_PRECIO] [decimal](18, 2),
	[BI_COMPRA_PC_CODIGO] [nvarchar](50) NULL REFERENCES CFJV_TEAM.[BI_PC],
	[BI_COMPRA_ACCESORIO_CODIGO] [decimal](18, 0) NULL REFERENCES CFJV_TEAM.[BI_ACCESORIO],
	[BI_COMPRA_CANTIDAD_ACCESORIOS] INT NULL 
)

INSERT INTO CFJV_TEAM.BI_COMPRAS(BI_COMPRA_NRO,BI_COMPRA_FECHA, BI_SUCURSAL_CODIGO, BI_COMPRA_PRECIO, BI_COMPRA_PC_CODIGO, BI_COMPRA_ACCESORIO_CODIGO, BI_COMPRA_CANTIDAD_ACCESORIOS)
SELECT c.compra_numero, c.compra_fecha, c.sucursal_id, c.compra_precio, cp.pc_codigo,ca.accesorio_codigo,ca.compra_accesorio_cantidad
FROM CFJV_TEAM.Compra c
LEFT JOIN CFJV_TEAM.CompraPc cp ON (cp.compra_numero=c.compra_numero)
LEFT JOIN CFJV_TEAM.CompraAccesorio ca ON ca.compra_numero=c.compra_numero

CREATE TABLE CFJV_TEAM.[BI_VENTAS](
	[VENTA_CODIGO] BIGINT IDENTITY(1,1) PRIMARY KEY,
	[BI_FACTURA_NUMERO] [decimal](18, 0),
	[BI_SUCURSAL_CODIGO] INT REFERENCES CFJV_TEAM.[BI_SUCURSAL],
	[BI_VENTA_FECHA] datetime2(3),
	[BI_VENTA_TIEMPO_ID] INT NULL REFERENCES CFJV_TEAM.[TIEMPO],
	[BI_VENTA_CLIENTE_ID] INT NULL REFERENCES CFJV_TEAM.[BI_CLIENTE],
	[BI_VENTA_PRECIO] [decimal](18, 2),
	[BI_VENTA_PC_CODIGO] [nvarchar](50) NULL REFERENCES CFJV_TEAM.[BI_PC],
	[BI_VENTA_ACCESORIO_CODIGO] [decimal](18, 0) NULL REFERENCES CFJV_TEAM.[BI_ACCESORIO],
	[BI_VENTA_CANTIDAD_ACCESORIO] [decimal](18, 0) NULL 
)

INSERT INTO CFJV_TEAM.[BI_VENTAS](BI_FACTURA_NUMERO,BI_SUCURSAL_CODIGO,BI_VENTA_FECHA,BI_VENTA_CLIENTE_ID,BI_VENTA_PRECIO,BI_VENTA_PC_CODIGO,BI_VENTA_ACCESORIO_CODIGO,BI_VENTA_CANTIDAD_ACCESORIO)
SELECT f.factura_numero, f.sucursal_id, f.factura_fecha, f.cliente_id, f.factura_precio, fpc.pc_codigo, fa.accesorio_codigo, fa.factura_accesorio_cantidad
FROM CFJV_TEAM.Factura f
LEFT JOIN CFJV_TEAM.FacturaPc fpc ON (fpc.factura_numero = f.factura_numero)
LEFT JOIN CFJV_TEAM.FacturaAccesorio fa ON (fa.factura_numero = f.factura_numero)
GO

--Vistas para pcs

/*CREATE VIEW PromedioTiempoEnStockModeloPC
AS
SELECT AVG()
FROM CFJV_TEAM.BI_VENTAS v
JOIN CFJV_TEAM.TIEMPO t ON ()
GROUP BY MONTH(v.VENTA_FECHA)=t.MES, YEAR(v.VENTA_FECHA)=t.ANIO
GO*/

CREATE VIEW PrecioPromedioPCVendidasCompradas
AS
SELECT SUM(v.BI_VENTA_PRECIO) / COUNT(v.BI_FACTURA_NUMERO) precioPromedioVendido, AVG(c.BI_COMPRA_PRECIO) precioPromedioComprado, c.BI_COMPRA_PC_CODIGO
FROM CFJV_TEAM.BI_COMPRAS c
JOIN CFJV_TEAM.BI_VENTAS v ON (v.BI_VENTA_PC_CODIGO = c.BI_COMPRA_PC_CODIGO)
GROUP BY c.BI_COMPRA_PC_CODIGO
GO

CREATE VIEW PCVendidasCompradasPorSucursalMes
AS
SELECT COUNT(c.BI_COMPRA_NRO) cantidadCompra,COUNT(v.BI_FACTURA_NUMERO) cantidadVendida,c.BI_SUCURSAL_CODIGO,MONTH(v.BI_VENTA_FECHA) mes,YEAR(v.BI_VENTA_FECHA) anio
FROM CFJV_TEAM.BI_COMPRAS c
JOIN CFJV_TEAM.BI_VENTAS v ON (c.BI_COMPRA_PC_CODIGO = v.BI_VENTA_PC_CODIGO)
GROUP BY c.BI_SUCURSAL_CODIGO,MONTH(v.BI_VENTA_FECHA),YEAR(v.BI_VENTA_FECHA)
GO

CREATE VIEW GananciasPrecioVentaCompraPorSucursalPorMes
AS
SELECT SUM(v.BI_VENTA_PRECIO) - SUM(c.BI_COMPRA_PRECIO) ganancia, c.BI_SUCURSAL_CODIGO, MONTH(v.BI_VENTA_FECHA) mesFactura, YEAR(v.BI_VENTA_FECHA) anioFactura
FROM CFJV_TEAM.BI_COMPRAS c
JOIN CFJV_TEAM.BI_VENTAS v ON (c.BI_COMPRA_PC_CODIGO = v.BI_VENTA_PC_CODIGO)
GROUP BY c.BI_SUCURSAL_CODIGO,MONTH(v.BI_VENTA_FECHA), YEAR(v.BI_VENTA_FECHA)
GO

--Vistas para accesorios

/*CREATE VIEW Promedio_tiempo_en_stock_Accesorios
AS
SELECT () Tiempo_Stock_Promedio, c.BI_COMPRA_ACCESORIO_CODIGO
FROM (SELECT c.BI_COMPRA_FECHA, v.BI_VENTA_FECHA, c.BI_COMPRA_ACCESORIO_CODIGO FROM CFJV_TEAM.BI_COMPRAS c
	FULL JOIN CFJV_TEAM.BI_VENTAS v ON (v.BI_VENTA_ACCESORIO_CODIGO = c.BI_COMPRA_ACCESORIO_CODIGO)
	GROUP BY)
GO*/

CREATE VIEW Precio_promedio_Accesorio
AS
SELECT c.BI_COMPRA_ACCESORIO_CODIGO, SUM(v.BI_VENTA_PRECIO) / COUNT(v.BI_FACTURA_NUMERO) precioPromedioVendido,AVG(c.BI_COMPRA_PRECIO) precioPromedioComprado 
FROM CFJV_TEAM.BI_COMPRAS c
JOIN CFJV_TEAM.BI_VENTAS v ON (v.BI_VENTA_ACCESORIO_CODIGO = c.BI_COMPRA_ACCESORIO_CODIGO)
WHERE c.BI_COMPRA_ACCESORIO_CODIGO is not null and v.BI_VENTA_ACCESORIO_CODIGO is not null
GROUP BY c.BI_COMPRA_ACCESORIO_CODIGO
GO

CREATE VIEW Ganancias_Accesorios_vendidos
AS
SELECT SUM(v.BI_VENTA_PRECIO) - SUM(c.BI_COMPRA_PRECIO) ganancia, c.BI_SUCURSAL_CODIGO, MONTH(v.BI_VENTA_FECHA) mesFactura, YEAR(v.BI_VENTA_FECHA) anioFactura
FROM CFJV_TEAM.BI_COMPRAS c 
JOIN CFJV_TEAM.BI_VENTAS v ON (v.BI_VENTA_ACCESORIO_CODIGO = c.BI_COMPRA_ACCESORIO_CODIGO)
WHERE c.BI_COMPRA_ACCESORIO_CODIGO is not null and v.BI_VENTA_ACCESORIO_CODIGO is not null
GROUP BY c.BI_SUCURSAL_CODIGO, MONTH(v.BI_VENTA_FECHA), YEAR(v.BI_VENTA_FECHA)
GO

CREATE VIEW Maximo_stock_por_sucursal_Accesorios
AS
SELECT MAX(STOCK_DISPONIBLE) Max_Stock, BI_COMPRA_ACCESORIO_CODIGO, s.SUCURSAL_ID, SUCURSAL_DIRECCION, YEAR(BI_COMPRA_FECHA) anio
FROM (SELECT SUM(BI_COMPRA_CANTIDAD_ACCESORIOS) STOCK_DISPONIBLE,
	BI_SUCURSAL_CODIGO, BI_COMPRA_FECHA, BI_COMPRA_ACCESORIO_CODIGO FROM CFJV_TEAM.BI_COMPRAS c
	GROUP BY BI_SUCURSAL_CODIGO, BI_COMPRA_FECHA, BI_COMPRA_ACCESORIO_CODIGO) subq
JOIN CFJV_TEAM.BI_SUCURSAL s ON (s.SUCURSAL_ID = subq.BI_SUCURSAL_CODIGO)
WHERE subq.BI_COMPRA_ACCESORIO_CODIGO is not null
GROUP BY BI_COMPRA_ACCESORIO_CODIGO, s.SUCURSAL_ID, SUCURSAL_DIRECCION, YEAR(BI_COMPRA_FECHA)
GO
