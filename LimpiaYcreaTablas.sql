USE [GD1C2021]
GO

/****** Object:  Table [gd_esquema].[Maestra]    Script Date: 14/04/2021 18:28:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [gd_esquema].[Maestra](
	
	[COMPRA_FECHA] [datetime2](3) NULL,
	[COMPRA_NUMERO] [decimal](18, 0) NULL,

	[COMPRA_PRECIO] [decimal](18, 2) NULL,

	[COMPRA_CANTIDAD] [decimal](18, 0) NULL,
	[PC_CODIGO] [nvarchar](50) NULL,

	[PC_ALTO] [decimal](18, 2) NULL,
	[PC_ANCHO] [decimal](18, 2) NULL,
	[PC_PROFUNDIDAD] [decimal](18, 2) NULL,

	[DISCO_RIGIDO_CODIGO] [nvarchar](255) NULL,
	[DISCO_RIGIDO_TIPO] [nvarchar](255) NULL,
	[DISCO_RIGIDO_CAPACIDAD] [nvarchar](255) NULL,
	[DISCO_RIGIDO_VELOCIDAD] [nvarchar](255) NULL,
	
	[MEMORIA_RAM_CODIGO] [nvarchar](255) NULL,
	[MEMORIA_RAM_TIPO] [nvarchar](255) NULL,
	[MEMORIA_RAM_CAPACIDAD] [nvarchar](255) NULL,
	[MEMORIA_RAM_VELOCIDAD] [nvarchar](255) NULL,
	
	[MICROPROCESADOR_CACHE] [nvarchar](50) NULL,
	[MICROPROCESADOR_CANT_HILOS] [decimal](18, 0) NULL,
	[MICROPROCESADOR_CODIGO] [nvarchar](50) NULL,
	[MICROPROCESADOR_VELOCIDAD] [nvarchar](50) NULL,
	
	[PLACA_VIDEO_CHIPSET] [nvarchar](50) NULL,
	[PLACA_VIDEO_MODELO] [nvarchar](50) NULL,
	[PLACA_VIDEO_VELOCIDAD] [nvarchar](50) NULL,
	[PLACA_VIDEO_CAPACIDAD] [nvarchar](255) NULL,

	[FACTURA_FECHA] [datetime2](3) NULL,
	[FACTURA_NUMERO] [decimal](18, 0) NULL

) ON [PRIMARY]

GO

USE [GD1C2021]
GO




/*2*/
DROP TABLE NOM_GRUPO.Accesorio
GO
DROP TABLE NOM_GRUPO.Gabinete
GO
DROP TABLE NOM_GRUPO.Microprocesador
GO
DROP TABLE NOM_GRUPO.PlacaDeVideo
GO
DROP TABLE NOM_GRUPO.MemoriaRAM
GO
DROP TABLE NOM_GRUPO.DiscoRigido
GO

/*1*/
DROP TABLE NOM_GRUPO.Fabricante
GO
DROP TABLE NOM_GRUPO.Sucursal
GO
DROP TABLE NOM_GRUPO.Cliente
GO


CREATE SCHEMA NOM_GRUPO

/****************************/
/************ 1 *************/
/****************************/

/*	Fabricante	*/
CREATE TABLE NOM_GRUPO.Fabricante(
fabricante_id INT PRIMARY KEY IDENTITY(1,1),
nombre nvarchar(255) NULL
);
GO

INSERT INTO NOM_GRUPO.Fabricante (nombre)
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

/*	Sucursal	*/
CREATE TABLE NOM_GRUPO.Sucursal(
sucursal_id INT PRIMARY KEY IDENTITY(1,1),
sucursal_direccion nvarchar(255) NULL,
sucursal_ciudad nvarchar(255) NULL,
sucursal_mail nvarchar(255) NULL,
sucursal_telefono decimal(18, 0) NULL
);
GO

INSERT INTO NOM_GRUPO.Sucursal (sucursal_direccion,sucursal_ciudad,sucursal_mail,sucursal_telefono)
	SELECT DISTINCT m.SUCURSAL_DIR, m.CIUDAD, m.SUCURSAL_MAIL, m.SUCURSAL_TEL
	FROM gd_esquema.Maestra m
	WHERE m.SUCURSAL_DIR IS NOT NULL AND m.CIUDAD IS NOT NULL AND m.SUCURSAL_MAIL IS NOT NULL AND m.SUCURSAL_TEL IS NOT NULL;
GO

/*	Cliente	*/
CREATE TABLE NOM_GRUPO.Cliente(
cliente_id INT PRIMARY KEY IDENTITY(1,1),
cliente_dni decimal(18, 0) NULL,
cliente_apellido nvarchar(255) NULL,
cliente_nombre nvarchar(255) NULL,
cliente_fecha_nacimiento datetime2(3) NULL,
cliente_direccion nvarchar(255) NULL,
cliente_telefono int NULL,
cliente_mail nvarchar(255) NULL,
cliente_sexo nvarchar(1) NULL		/* ? */
);
GO

INSERT INTO NOM_GRUPO.Cliente (cliente_dni,cliente_apellido,cliente_nombre,cliente_fecha_nacimiento,cliente_direccion,cliente_telefono,cliente_mail)
	SELECT DISTINCT m.CLIENTE_DNI, m.CLIENTE_APELLIDO, m.CLIENTE_NOMBRE, m.CLIENTE_FECHA_NACIMIENTO, m.CLIENTE_DIRECCION, m.CLIENTE_TELEFONO, m.CLIENTE_MAIL
	FROM gd_esquema.Maestra m
	WHERE m.CLIENTE_DNI IS NOT NULL AND m.CLIENTE_APELLIDO IS NOT NULL AND m.CLIENTE_NOMBRE IS NOT NULL AND m.CLIENTE_FECHA_NACIMIENTO IS NOT NULL AND m.CLIENTE_DIRECCION IS NOT NULL AND m.CLIENTE_TELEFONO IS NOT NULL AND m.CLIENTE_MAIL IS NOT NULL;
GO

/****************************/
/************ 2 *************/
/****************************/

/*	Accesorio	*/
CREATE TABLE NOM_GRUPO.Accesorio(
accesorio_codigo decimal(18, 0) PRIMARY KEY,
accesorio_descripcion nvarchar(255) NULL,
accesorio_precio decimal(18, 2) NULL,
fabricante_id INT REFERENCES NOM_GRUPO.Fabricante
);
GO

INSERT INTO NOM_GRUPO.Accesorio (accesorio_codigo,accesorio_descripcion,accesorio_precio)
	SELECT DISTINCT m.ACCESORIO_CODIGO, m.AC_DESCRIPCION, m.COMPRA_PRECIO
	FROM gd_esquema.Maestra m
	WHERE m.ACCESORIO_CODIGO IS NOT NULL AND m.AC_DESCRIPCION IS NOT NULL AND m.COMPRA_PRECIO IS NOT NULL;
GO /* no hay fabricantes!!! */




/*
[MICROPROCESADOR_CACHE] [nvarchar](50) NULL,
	[MICROPROCESADOR_CANT_HILOS] [decimal](18, 0) NULL,
	[MICROPROCESADOR_CODIGO] [nvarchar](50) NULL,
	[MICROPROCESADOR_VELOCIDAD] [nvarchar](50) NULL,
*/

