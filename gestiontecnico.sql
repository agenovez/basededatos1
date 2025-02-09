CREATE DATABASE servicio_tecnico;

\c servicio_tecnico;

-- Tabla Cliente
CREATE TABLE Cliente (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    direccion TEXT,
    email VARCHAR(100) UNIQUE
);

-- Tabla Equipo
CREATE TABLE Equipo (
    id_equipo SERIAL PRIMARY KEY,
    id_cliente INT NOT NULL,
    marca VARCHAR(50) NOT NULL,
    modelo VARCHAR(50) NOT NULL,
    num_serie VARCHAR(50) UNIQUE NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

-- Tabla Técnico
CREATE TABLE Tecnico (
    id_tecnico SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    telefono VARCHAR(20) NOT NULL
);

-- Tabla Reparación
CREATE TABLE Reparacion (
    id_reparacion SERIAL PRIMARY KEY,
    id_equipo INT NOT NULL,
    id_tecnico INT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE,
    estado VARCHAR(20) CHECK (estado IN ('Pendiente', 'En proceso', 'Finalizado')) DEFAULT 'Pendiente',
    costo DECIMAL(10,2),
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo) ON DELETE CASCADE,
    FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico) ON DELETE SET NULL
);

-- Tabla Servicio
CREATE TABLE Servicio (
    id_servicio SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL
);

-- Tabla Reparacion_Servicio (Entidad asociativa)
CREATE TABLE Reparacion_Servicio (
    id_reparacion INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (id_reparacion, id_servicio),
    FOREIGN KEY (id_reparacion) REFERENCES Reparacion(id_reparacion) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio) ON DELETE CASCADE
);

-- Tabla Factura
CREATE TABLE Factura (
    id_factura SERIAL PRIMARY KEY,
    id_reparacion INT NOT NULL,
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_reparacion) REFERENCES Reparacion(id_reparacion) ON DELETE CASCADE
);

-- Tabla Factura_Servicio (Entidad asociativa)
CREATE TABLE Factura_Servicio (
    id_factura INT NOT NULL,
    id_servicio INT NOT NULL,
    cantidad INT DEFAULT 1,
    PRIMARY KEY (id_factura, id_servicio),
    FOREIGN KEY (id_factura) REFERENCES Factura(id_factura) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio) ON DELETE CASCADE
);
