CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(100),
    telefono VARCHAR(15),
    direccion VARCHAR(255),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Equipo (
    id_equipo INT PRIMARY KEY,
    id_cliente INT,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    num_serie VARCHAR(50) UNIQUE,
    descripcion TEXT,
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente) ON DELETE CASCADE
);

CREATE TABLE Tecnico (
    id_tecnico INT PRIMARY KEY,
    nombre VARCHAR(100),
    especialidad VARCHAR(100),
    telefono VARCHAR(15)
);

CREATE TABLE Reparacion (
    id_reparacion INT PRIMARY KEY,
    id_equipo INT,
    id_tecnico INT,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado VARCHAR(50),
    costo DECIMAL(10,2),
    FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo) ON DELETE CASCADE,
    FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico) ON DELETE SET NULL
);

CREATE TABLE Servicio (
    id_servicio INT PRIMARY KEY,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10,2)
);

CREATE TABLE Reparacion_Servicio (
    id_reparacion INT,
    id_servicio INT,
    cantidad INT,
    PRIMARY KEY (id_reparacion, id_servicio),
    FOREIGN KEY (id_reparacion) REFERENCES Reparacion(id_reparacion) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio) ON DELETE CASCADE
);

CREATE TABLE Factura (
    id_factura INT PRIMARY KEY,
    id_reparacion INT UNIQUE,
    fecha DATE,
    total DECIMAL(10,2),
    FOREIGN KEY (id_reparacion) REFERENCES Reparacion(id_reparacion) ON DELETE CASCADE
);

CREATE TABLE Factura_Servicio (
    id_factura INT,
    id_servicio INT,
    cantidad INT,
    PRIMARY KEY (id_factura, id_servicio),
    FOREIGN KEY (id_factura) REFERENCES Factura(id_factura) ON DELETE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio) ON DELETE CASCADE
);
