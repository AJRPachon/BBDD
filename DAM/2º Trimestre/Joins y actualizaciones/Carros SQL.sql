Create Database Colegas
go
Use Colegas
GO
-- People
Create Table People (
	ID SmallInt Not NULL Constraint PKPeople Primary Key,
	Nombre VarChar(20) Not NULL,
	Apellidos VarChar(20) Not NULL,
	FechaNac Date NULL
)
GO
-- Carros
Create Table Carros (
	ID SmallInt Not NULL Constraint PKCarros Primary Key,
	Marca VarChar(15) Not NULL,
	Modelo VarChar(20) Not NULL,
	Anho SmallInt NULL Constraint CKAnno Check (Anho Between 1900 AND YEAR(Current_Timestamp)),
	Color VarChar(15),
	IDPropietario SmallInt NULL Constraint FKCarroPeople Foreign Key References People (ID) On Update No action On Delete No action
)
-- Libros
Create Table Libros(
	ID Int Not NULL Constraint PKLibros Primary Key,
	Titulo VarChar(30) Not NULL,
	Autors VarChar(30) NULL
)
GO
ALTER TABLE Libros
ALTER COLUMN Titulo varchar(40)

--Lecturas
Create Table Lecturas(
	IDLibro Int Not NULL,
	IDLector SmallInt Not NULL,
	Constraint PKLecturas Primary Key (IDLibro, IDLector),
	Constraint FKLecturasLibros Foreign Key (IDLibro) References Libros (ID) On Update No action On Delete No action,
	Constraint FKLecturasLectores Foreign Key (IDLector) References People (ID) On Update No action On Delete No action,
	AnhoLectura SmallInt NULL
)