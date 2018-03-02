drop table producto;
drop table tipo;

CREATE OR REPLACE PACKAGE types
AS
     TYPE ref_cursor IS REF CURSOR;
END;
/
	CREATE TABLE Tipo(
		nombre VARCHAR(50),
		porcentaje int,
		constraint pkTipo primary key (nombre)
	);

    CREATE TABLE Producto(
		codigo VARCHAR(10),
		nombre VARCHAR(50),
		precio int,
		importado number(1),
		--impuesto tambien es calculado.------ 0.Porcentaje * precio = impuesto 
		--precioFinal int, Esto se calcula. precio + impuesto:
		nombreTipo VARCHAR(50),
		constraint pkProducto primary key (codigo),
		constraint fkProducto foreign key (nombreTipo) references Tipo
    );

-----------------Procedimientos-------------------------------------------
--Buscar productos por el nombre
create or replace function listarProductos
RETURN Types.ref_cursor
 	as
     producto_cursor types.ref_cursor;
 	begin
     open producto_cursor for
            select * from Producto;
            return producto_cursor;
     end;
 /

--Buscar productos por el codigo
create or replace function buscarProductoPorCodigo(codigoBuscar varchar)
RETURN Types.ref_cursor
 	as
     producto_cursor types.ref_cursor;
 	begin
     open producto_cursor for
            select * from Producto where codigo = codigoBuscar;
            return producto_cursor;
     end;
 /


--Buscar productos por el nombre
create or replace function buscarProductoPorNombre(nombreBuscar varchar)
RETURN Types.ref_cursor
 	as
     producto_cursor types.ref_cursor;
 	begin
     open producto_cursor for
            select * from Producto where nombre = nombreBuscar;
            return producto_cursor;
     end;
 /

--Buscar productos por el tipo
create or replace function buscarProductoPorTipo(tipoBuscar varchar)
RETURN Types.ref_cursor
 	as
     producto_cursor types.ref_cursor;
 	begin
     open producto_cursor for
            select * from Producto where nombreTipo = tipoBuscar;
            return producto_cursor;
     end;
 /

--Agregar productos
create or replace procedure insertarProducto(codigo varchar,nombre varchar, precio integer, importado number, nombreTipo Varchar)
 	is
 	begin
            insert into Producto values(codigo,nombre,precio,importado,nombreTipo);
     end;
 /


create or replace function listarTipos
RETURN Types.ref_cursor
 	as
     tipo_cursor types.ref_cursor;
 	begin
     open tipo_cursor for
            select * from Tipo;
            return tipo_cursor;
     end;
 /

--Buscar tipos por el nombre
create or replace function buscarTipoPorNombre(nombreBuscar varchar)
RETURN Types.ref_cursor
 	as
     tipo_cursor types.ref_cursor;
 	begin
     open tipo_cursor for
            select * from Tipo where nombre = nombreBuscar;
            return tipo_cursor;
     end;
 /

--PRUEBAS-----------------------
insert into tipo values('animales',5);
exec insertarProducto('111','perro',555,0,'animales');
exec insertarProducto('222','perro',123,1,'animales');
select buscarProductoPorNombre('perro') from dual;
select buscarProductoPorTipo('animales') from dual;
select listarProductos() from dual;