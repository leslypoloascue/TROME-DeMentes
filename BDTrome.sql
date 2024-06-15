IF DB_ID('BDTrome') IS NOT NULL
BEGIN
    DROP DATABASE BDTrome;
END
GO

-- Creamos la base de datos BDTrome
CREATE DATABASE BDTrome;
GO

-- Usamos la base de datos BDTrome
USE BDTrome;
GO

-- Creación de la tabla TUsuario (Usuario y Contraseña encriptada)
IF OBJECT_ID('dbo.TUsuario', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TUsuario (
        CodUsuario VARCHAR(50) PRIMARY KEY,
        Contrasena VARBINARY(8000) NOT NULL
    );
END
GO

-- Creación de la tabla TCliente
IF OBJECT_ID('dbo.TCliente', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TCliente (
        IdCliente INT PRIMARY KEY IDENTITY(1,1),
        Nombre VARCHAR(100) NOT NULL,
        Direccion VARCHAR(200) NOT NULL,
        Telefono VARCHAR(20) NOT NULL,
        CodUsuario VARCHAR(50) NOT NULL,
	    Contrasena	varchar(50)not null
        FOREIGN KEY (CodUsuario) REFERENCES dbo.TUsuario(CodUsuario)
    );
END
GO

-- Creación de la tabla TServicio
IF OBJECT_ID('dbo.TServicio', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TServicio (
        IdServicio INT PRIMARY KEY IDENTITY(1,1),
        Descripcion VARCHAR(200) NOT NULL,
        TarifaBase DECIMAL(10, 2) NOT NULL
    );
END
GO

-- Creación de la tabla TVehiculo
IF OBJECT_ID('dbo.TVehiculo', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TVehiculo (
        IdVehiculo INT PRIMARY KEY IDENTITY(1,1),
        Marca VARCHAR(100) NOT NULL,
        Modelo VARCHAR(100) NOT NULL,
        Placa VARCHAR(20) NOT NULL,
        CapacidadCarga DECIMAL(10, 2) NOT NULL
    );
END
GO

-- Creación de la tabla TEnvio
IF OBJECT_ID('dbo.TEnvio', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TEnvio (
        IdEnvio INT PRIMARY KEY IDENTITY(1,1),
        IdCliente INT NOT NULL,
        IdServicio INT NOT NULL,
        FechaEnvio DATE NOT NULL,
        FechaRecojo DATE NOT NULL,
        Peso DECIMAL(10, 2) NOT NULL,
        Volumen DECIMAL(10, 2) NOT NULL,
        TipoDocumento CHAR(1) CHECK (TipoDocumento IN ('B', 'F')) NOT NULL,
        TarifaBase DECIMAL(10, 2) NOT NULL,
        MontoPago AS (TarifaBase + (Peso * 0.5) + (Volumen * 0.3)) PERSISTED,
        FOREIGN KEY (IdCliente) REFERENCES dbo.TCliente(IdCliente),
        FOREIGN KEY (IdServicio) REFERENCES dbo.TServicio(IdServicio)
    );
END
GO

-- Creación de la tabla TColaborador
IF OBJECT_ID('dbo.TColaborador', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.TColaborador (
        IdColaborador INT PRIMARY KEY IDENTITY(1,1),
        Nombre VARCHAR(100) NOT NULL,
        Cargo VARCHAR(100) NOT NULL,
        Telefono VARCHAR(20) NOT NULL,
        CodUsuario VARCHAR(50) NOT NULL,
		Contrasena	varchar(50)not null,
        IdVehiculo INT,
        FOREIGN KEY (IdVehiculo) REFERENCES dbo.TVehiculo(IdVehiculo),
        FOREIGN KEY (CodUsuario) REFERENCES dbo.TUsuario(CodUsuario)
    );
END
GO

-- Creación de la tabla ColaboradorEnvio (relación muchos a muchos)
IF OBJECT_ID('dbo.ColaboradorEnvio', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.ColaboradorEnvio (
        IdColaborador INT,
        IdEnvio INT,
        PRIMARY KEY (IdColaborador, IdEnvio),
        FOREIGN KEY (IdColaborador) REFERENCES dbo.TColaborador(IdColaborador),
        FOREIGN KEY (IdEnvio) REFERENCES dbo.TEnvio(IdEnvio)
    );
END
GO

---1
-- insercion de usuarios TColaborador
insert into dbo.TUsuario values ('juan.perez@example.com',ENCRYPTBYPASSPHRASE('miFraseDeContraseña', '1234'))
insert into dbo.TUsuario values ('maria.lopez@example.com',ENCRYPTBYPASSPHRASE('miFraseDeContraseña', '1234'))
insert into dbo.TUsuario values ('pedro.ramirez@example.com',ENCRYPTBYPASSPHRASE('miFraseDeContraseña', '1234'))

-- insercion de usuarios TCliente 
insert into dbo.TUsuario values ('cliente1@example.com',ENCRYPTBYPASSPHRASE('miFraseDeContraseña', '1234'))
insert into dbo.TUsuario values ('cliente2@example.com',ENCRYPTBYPASSPHRASE('miFraseDeContraseña', '1234'))
insert into dbo.TUsuario values ('cliente3@example.com',ENCRYPTBYPASSPHRASE('miFraseDeContraseña', '1234'))

---2
-- Inserción de datos de clientes
INSERT INTO dbo.TCliente (Nombre, Direccion, Telefono, CodUsuario,Contrasena)
VALUES 
    ('Cliente 1', 'Direccion Cliente 1', '123456789', 'cliente1@example.com','123'),
    ('Cliente 2', 'Direccion Cliente 2', '987654321', 'cliente2@example.com','123'),
    ('Cliente 3', 'Direccion Cliente 3', '555444333', 'cliente3@example.com','123');
GO
---3
-- Inserción de datos de servicios
INSERT INTO dbo.TServicio (Descripcion, TarifaBase)
VALUES 
    ('Envio estandar', 100.00),
    ('Envio urgente', 150.00),
    ('Envio con seguro', 200.00);
GO
---4
-- Inserción de datos de vehículos
INSERT INTO dbo.TVehiculo (Marca, Modelo, Placa, CapacidadCarga)
VALUES 
    ('Toyota', 'Hilux', 'ABC123', 1500.00),
    ('Ford', 'Transit', 'XYZ789', 2000.00),
    ('Chevrolet', 'N300', 'DEF456', 1000.00);
GO
---5
-- Inserción de datos de envíos
INSERT INTO dbo.TEnvio (IdCliente, IdServicio, FechaEnvio, FechaRecojo, Peso, Volumen, TipoDocumento, TarifaBase)
VALUES 
    (1, 1, '2024-06-17', '2024-06-18', 12.3, 18.5, 'B', 100.00),
    (2, 3, '2024-06-16', '2024-06-17', 7.8, 10.2, 'F', 200.00),
    (3, 2, '2024-06-15', '2024-06-16', 6.5, 9.8, 'B', 150.00);
	go

	--6
-- Inserción de datos en la tabla TColaborador
INSERT INTO dbo.TColaborador (Nombre, Cargo, Telefono, CodUsuario,Contrasena, IdVehiculo)
VALUES 
    ('Juan Perez', 'Gerente de Logistica', '123456789', 'juan.perez@example.com','123', 1),
    ('Maria Lopez', 'Conductor', '987654321', 'maria.lopez@example.com','123', 2),
    ('Pedro Ramirez', 'Almacenista', '555444333', 'pedro.ramirez@example.com','123', 3);
GO

-- Inserción de datos en la tabla ColaboradorEnvio
--7

INSERT INTO dbo.ColaboradorEnvio (IdColaborador, IdEnvio)
VALUES (1, 2);

INSERT INTO dbo.ColaboradorEnvio (IdColaborador, IdEnvio)
VALUES (2, 2);

INSERT INTO dbo.ColaboradorEnvio (IdColaborador, IdEnvio)
VALUES (3, 1);

-- Seleccionamos todos los datos de la tabla TEnvio para verificar
SELECT * FROM dbo.TEnvio;
GO

SELECT * FROM dbo.TVehiculo
GO

SELECT * FROM dbo.TServicio
GO

SELECT * FROM dbo.TCliente
GO

SELECT * FROM dbo.TColaborador
GO

SELECT * FROM dbo.ColaboradorEnvio
GO

SELECT * FROM dbo.TUsuario
GO

