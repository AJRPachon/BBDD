-- Club de juegos
CREATE DATABASE ClubJuegosBeta
GO
Use ClubJuegosBeta
GO
-- Personas que están registradas para participar en actividades
CREATE Table CJUsuarias (
	ID int NOT NULL,
	Nombre nvarchar(15) NOT NULL,
	Apellidos nvarchar(25) NOT NULL,
	Nick nchar(12) NOT NULL,
	PassWord nchar(12) NOT NULL,
	FechaNacimiento date NOT NULL,
	Bloqueada Bit CONSTRAINT DFBloqueado DEFAULT 0,
	CONSTRAINT PKUsuarias Primary Key (ID)
)
-- Juegos disponibles en el club
CREATE TABLE CJJuegos(
	ID SmallInt Not NULL,
	Nombre VarChar(50) Not NULL,
	Descripcion VarChar(300) NULL
	CONSTRAINT PKJuegos Primary Key (ID)
)
CREATE TABLE CJSalas(
	ID SmallInt Not NULL,
	Denominacion VarChar (40) Not NULL,
	Capacidad SmallInt Not NULL,
	CONSTRAINT PKSalas Primary Key(ID)
)
GO


CREATE TABLE CJSocias(
	ID int Not NULL,
	FechaAlta Date Not NULL,
	FechaBaja Date NULL,
	Cuota SmallMoney Not NULL CONSTRAINT DFCuotaSocia DEFAULT 20,
	CONSTRAINT PKSocias Primary Key (ID),
	CONSTRAINT FKSociasUsuarias Foreign Key (ID) REFERENCES CJUsuarias (ID)
)
GO
-- Actividades tales como partidas, charlas, etc
CREATE TABLE CJActividades(
	ID Int Not NULL IDENTITY,
	Descripcion VarChar(150),
	IDJuego SmallInt NULL,
	NumMaxAsistentes TinyInt Not NULL,
	NumMinAsistentes TinyInt Not NULL,
	IDOrganizadora Int NULL,
	CONSTRAINT PKActividades Primary Key (ID),
	CONSTRAINT FKActividadesJuegos FOREIGN KEY (IDJuego) REFERENCES CJJuegos (ID),
	CONSTRAINT FKActividadesSocias FOREIGN KEY (IDOrganizadora) REFERENCES CJSocias (ID)
)
-- Préstamos de juegos
CREATE TABLE CJPrestamos(
	ID BigInt Not NULL,
	FechaInicio SmallDateTime Not NULL,
	FechaFinPrevista Date Not NULL,
	FechaFinReal SmallDateTime NULL,
	IDSocia Int Not NULL,
	IDJuego SmallInt Not NULL,
	CONSTRAINT PKPrestamo Primary Key(ID),
	CONSTRAINT FKPrestamosSocias FOREIGN KEY (IDSocia) REFERENCES CJSocias (ID),
	CONSTRAINT FKPrestamosJuegos FOREIGN KEY (IDJuego) REFERENCES CJJuegos (ID),
	CONSTRAINT CKFechaDev CHECK (CAST(FechaInicio AS Date)<FechaFinPrevista)
)
GO
--Lugar de celebracion de las actividades
CREATE TABLE CJActividadesSalas(
	IDActividad Int Not NULL,
	IDSala SmallInt Not NULL,
	CONSTRAINT PKActividadesSalas Primary Key(IDActividad, IDSala),
	CONSTRAINT FKASActividades Foreign Key (IDActividad) REFERENCES CJActividades (ID),
	CONSTRAINT FKASSalas Foreign Key (IDSala) REFERENCES CJSalas (ID)
)
-- Programación de las actividades
CREATE TABLE CJProgramaciones(
	ID UniqueIdentifier Not NULL,
	IDActividad Int Not NULL,
	IDSustituida UniqueIdentifier NULL,
	FechaPrevista SmallDateTime Not NULL,
	CONSTRAINT PKProgramaciones Primary Key(ID),
	CONSTRAINT UQSustitucion UNIQUE (IDSustituida),
	CONSTRAINT FKProgramacionActividad Foreign Key (IDActividad) REFERENCES CJActividades (ID),
	CONSTRAINT FKProgramcionSustituida Foreign Key (IDSustituida) REFERENCES CJProgramaciones (ID)
)
-- Participacion en actividades
CREATE TABLE CJUsuariasActividades (
	IDUsuaria Int Not NULL,
	IDActividad Int Not NULL,
	CONSTRAINT PKUsuariasActividades Primary Key (IDUsuaria, IDActividad),
	CONSTRAINT FKUAUsuarias Foreign Key (IDUsuaria) REFERENCES CJUsuarias (ID),
	CONSTRAINT FKUAActividades Foreign Key (IDActividad) REFERENCES CJActividades (ID)
)
-- Pagos de las cuotas de socia
CREATE TABLE CJPagos (
	ID UniqueIdentifier Not NULL,
	IDSocia Int Not NULL,
	FechaVencimiento DATE Not NULL,
	FechaPago DATE NULL,
	CONSTRAINT PKPagos Primary Key (ID),
	CONSTRAINT FKPagosSocias FOREIGN KEY (IDSocia) REFERENCES CJSocias (ID)
)
GO
USE [ClubJuegosBeta]
GO
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (1, N'Arturo', N'Cantalapiedra', N'acanta      ', N'123         ', CAST(N'1974-06-15' AS Date), 0)
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (2, N'Olga', N'Rabato', N'ogara       ', N'479         ', CAST(N'1990-03-21' AS Date), 0)
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (3, N'Celestina', N'Ja', N'ceja        ', N'608         ', CAST(N'1988-08-11' AS Date), 0)
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (4, N'Conde', N'Mor', N'cmor        ', N'934         ', CAST(N'1960-11-06' AS Date), 0)
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (5, N'Salustio', N'Del Pollo', N'spollo      ', N'407         ', CAST(N'1995-02-28' AS Date), 0)
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (6, N'Bernardo', N'Minguero', N'mingo       ', N'778         ', CAST(N'1986-12-03' AS Date), 0)
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (7, N'Ombligo', N'Pato', N'bankiaman   ', N'666         ', CAST(N'1955-10-13' AS Date), 0)
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (8, N'Paquito', N'ElMecanico', N'Paco        ', N'paquitome   ', CAST(N'1992-06-12' AS Date), 0)
INSERT [dbo].[CJUsuarias] ([ID], [Nombre], [Apellidos], [Nick], [PassWord], [FechaNacimiento], [Bloqueada]) VALUES (9, N'Mercurio', N'CromoVerde', N'Mercu       ', N'elmercuri   ', CAST(N'1993-01-05' AS Date), 0)
INSERT [dbo].[CJSocias] ([ID], [FechaAlta], [FechaBaja], [Cuota]) VALUES (1, CAST(N'1992-06-15' AS Date), NULL, 20.0000)
INSERT [dbo].[CJSocias] ([ID], [FechaAlta], [FechaBaja], [Cuota]) VALUES (2, CAST(N'2008-03-21' AS Date), NULL, 20.0000)
INSERT [dbo].[CJSocias] ([ID], [FechaAlta], [FechaBaja], [Cuota]) VALUES (3, CAST(N'2006-08-11' AS Date), NULL, 20.0000)
INSERT [dbo].[CJSocias] ([ID], [FechaAlta], [FechaBaja], [Cuota]) VALUES (4, CAST(N'1978-11-06' AS Date), NULL, 20.0000)
INSERT [dbo].[CJSocias] ([ID], [FechaAlta], [FechaBaja], [Cuota]) VALUES (5, CAST(N'2013-02-28' AS Date), NULL, 20.0000)
INSERT [dbo].[CJSocias] ([ID], [FechaAlta], [FechaBaja], [Cuota]) VALUES (7, CAST(N'1973-10-13' AS Date), NULL, 20.0000)
INSERT [dbo].[CJSocias] ([ID], [FechaAlta], [FechaBaja], [Cuota]) VALUES (8, CAST(N'2010-06-12' AS Date), NULL, 20.0000)
INSERT [dbo].[CJSocias] ([ID], [FechaAlta], [FechaBaja], [Cuota]) VALUES (9, CAST(N'2011-01-05' AS Date), NULL, 20.0000)