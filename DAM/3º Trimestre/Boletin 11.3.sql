--Boletín 11.3 Procedimientos
--Sobre la base de datos CentroDeportivo.


--Ejercicio 1
--Escribe un procedimiento EliminarUsuario que reciba como parámetro el DNI de un usuario, le coloque un NULL en la columna Sex y borre todas las reservas futuras de ese usuario. Ten en cuenta que si alguna de esas reservas tiene asociado un alquiler de material habrá que borrarlo también.







--Ejercicio 2
--Escribe un procedimiento que reciba como parámetros el código de una instalación y una fecha/hora (SmallDateTime) y devuelva en otro parámetro de salida el ID del usuario que la tenía alquilada si en ese momento la instalación estaba ocupada. Si estaba libre, devolverá un NULL.







--Ejercicio 3
--Escribe un procedimiento que reciba como parámetros el código de una instalación y dos fechas (DATE) y devuelva en otro parámetro de salida el número de horas que esa instalación ha estado alquilada entre esas dos fechas, ambas incluidas. Si se omite la segunda fecha, se tomará la actual con GETDATE().
--Devuelve con return códigos de error si el código de la instalación es erróneo  o si la fecha de inicio es posterior a la de fin.






--Ejercicio 4
--Escribe un procedimiento EfectuarReserva que reciba como parámetro el DNI de un usuario, el código de la instalación, la fecha/hora de inicio
--de la reserva y la fecha/hora final.
--El procedimiento comprobará que los datos de entradas son correctos y grabará la correspondiente reserva. Devolverá el código de
--reserva generado mediante un parámetro de salida. Para obtener el valor generado usar la función @@identity tras el INSERT.
--Devuelve un cero si la operación se realiza con éxito y un código de error según la lista siguiente:
--3: La instalación está ocupada para esa fecha y hora
--4: El código de la instalación es incorrecto
--5: El usuario no existe
--8: La fecha/hora de inicio del alquiler es posterior a la de fin
--11: La fecha de inicio y de fin son diferentes