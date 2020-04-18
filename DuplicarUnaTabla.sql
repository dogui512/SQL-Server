/*Para duplicar una tabla, podemos hacer varias cosas.
Como por ejemplo copiar sólo la estructura:*/

    SELECT * Into DestinationTableName From SourceTableName Where 1 = 2 

--También se puede hacer un duplicado exacto de la misma ejecutando la siguiente instrucción, con la salvedad de que, no se copiarán las constraints o índices.

    SELECT * INTO MyNewTable FROM MyTable

--Si queremos agregarle una clave principal

CREATE INDEX Nombre_Indice ON MyNewTable (nombre_campo_id);
-- Ejemplo con datos
CREATE INDEX PK_per_id ON MyNewTable (per_id);

--Ejemplo Completo

     USE tandem 
IF OBJECT_ID('personas_copia', 'U') IS NOT NULL -- si existe la nueva tabla
    drop table personas_copia;
GO
SELECT * INTO personas_copia FROM [TANDEMPROD].Tandem.dbo.personas;
CREATE INDEX PK_per_id ON personas_copia (per_id);

/*
Notas y referencias:
https://www.rubenortiz.es/2009/11/16/sql-server-duplicar-una-tabla/ 
*/
