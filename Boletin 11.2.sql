--Ejercicio 11.2
--La tabla ActualizaTitles contiene una serie de modificaciones que hay que realizar sobre la tabla titles de la base de datos pubs.

--Tienes que ir recorriendo la tabla con un bucle, leer cada fila y realizar la actualización que se indique.

--Si la columna TipoActualiza contiene una "I" hay que insertar una nueva fila en titles con todos los datos leídos de esa fila de ActualizaTitles.

--Si TipoActualiza contiene una "D" hay que eliminar la fila cuyo código (title_id) se incluye.

--Si TipoActualiza es "U" hay que actualizar la fila identificada por title_id con las columnas que no sean Null. Las que sean Null se dejan igual.