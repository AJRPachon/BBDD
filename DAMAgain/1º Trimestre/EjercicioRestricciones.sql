USE Ejemplos


--1. DatosRestrictivos. Columnas:
--a. ID Es un SmallInt autonumérico que se rellenará con números impares. No admite
--nulos. Clave primaria
--b. Nombre: Cadena de tamaño 15. No puede empezar por "N” ni por "X” Añade una
--restiricción UNIQUE. No admite nulos
--c. Numpelos: Int con valores comprendidos entre 0 y 150.000
--d. TipoRopa: Carácter con uno de los siguientes valores: "C”, "F”, "E”, "P”, "B”, ”N”
--e. NumSuerte: TinyInt. Tiene que ser un número entre 10 y 40, divisible por 3.
--f. Minutos: TinyInt Con valores comprendidos entre 20 y 85 o entre 120 y 185.

CREATE TABLE DatosRestrictivos(

	ID SMALLINT NOT NULL IDENTITY (1,2),
	Nombre CHAR(15) NOT NULL,
	Numpelos INT NULL,
	TipoRopa CHAR(1) NULL,
	NumSuerte TINYINT NULL,
	Minutos TINYINT NULL,

	CONSTRAINT PK_DatosRestictivos PRIMARY KEY (ID),
	CONSTRAINT UQ_Nomb_DatosRestrictivos UNIQUE (Nombre),
	CONSTRAINT CK_Nomb_DatosRestrictivos CHECK (Nombre NOT LIKE 'N%''X%'),  --'[NX]%'
	CONSTRAINT CK_NumP_DatosRestrictivos CHECK (Numpelos BETWEEN 0 AND 150000),
	CONSTRAINT CK_TipoRo_DatosRestrictivos CHECK (TipoRopa LIKE 'C''F''E''P''B''N'),
	CONSTRAINT CK_NumSuer_DatosRestrictivos CHECK ((NumSuerte BETWEEN 10 AND 40) AND (NumSuerte %3 = 0)),
	CONSTRAINT CK_Minu_DatosRestrictivos CHECK ((Minutos BETWEEN 20 AND 85) OR (Minutos BETWEEN 120 AND 185))
)
GO

--------------------------------------------------------------------------------------------------------------------------------------------

--2. DatosRelacionados. Columnas:
--a. NombreRelacionado: Cadena de tamaño 15. Define una FK para relacionarla con
--la columna "Nombre” de la tabla DatosRestrictivos.
--¿Deberíamos poner la misma restricción que en la columna correspondiente?
--¿Qué ocurriría si la ponemos?
--¿Y si no la ponemos?

--b. PalabraTabu: Cadena de longitud max 20. No admitirá los valores "MENA”,
--"Gurtel”, "ERE”, "Procés” ni "sobresueldo”. Tampoco admitirá ninguna palabra
--terminada en "eo”

--c. NumRarito: TinyInt menor que 20. No admitirá números primos.

--d. NumMasgrande: SmallInt. Valores comprendidos entre NumRarito y 1000.
--Definirlo como clave primaria.
--¿Puede tener valores menores que 20?


CREATE TABLE DatosRelacionados(

	NombreRelacionado CHAR(15) NOT NULL,
	ID_DatoRestrictivo SMALLINT NOT NULL,
	PalabraTabu VARCHAR(20) NULL,
	NumRarito TINYINT NULL,
	NumMasGrande SMALLINT NOT NULL,

	CONSTRAINT PK_DatosRestrictivos PRIMARY KEY (NumMasGrande),
	CONSTRAINT FK_DatosRestrictivos_DaRelac FOREIGN KEY (ID_DatoRestrictivo) REFERENCES DatosRestrictivos (ID) ON DELETE NO ACTION ON UPDATE CASCADE,
	CONSTRAINT CK_PalabraTabu_DatosRelacionados CHECK ((PalabraTabu != 'MENA''Gurtel''ERE''Procés''sobresueldo') AND (PalabraTabu != '%eo')),
	CONSTRAINT CK_NumRar_DatosRelacionados CHECK (NumRarito < 20 AND NumRarito NOT IN (2,3,5,7,11,13,17,19)),
	CONSTRAINT CK_NumMasGran_DatosRelacionados CHECK ( NumMasGrande BETWEEN NumRarito AND 1000)

)
GO

-----------------------------------------------------------------------------------------------------------------------------------------------

--3. DatosAlMogollon. Columnas:
--a. ID. SmallInt. No admitirá múltiplos de 5. Definirlo como PK

--b. LimiteSuperior. SmallInt comprendido entre 1500 y 2000.

--c. OtroNumero. Será mayor que el ID y Menor que LimiteSuperior. Poner UNIQUE

--d. NumeroQueVinoDelMasAlla: SmallInt FK relacionada con NumMasGrande de la tabla DatosRelacionados

--e. Etiqueta. Cadena de 3 caracteres max. No puede tener los valores "lao”, "leo”, "lio” ni "luo”