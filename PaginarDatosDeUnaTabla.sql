
--Permite paginar los datos devueltos por una tabla, similar a la paginación de controles de datos como el DataGrid.

DECLARE @NUM_PAGINA INT;
DECLARE @TAM_PAGINA INT;

SET @NUM_PAGINA = 1; -- Permite avanzar por los registro de inicio a fin
SET @TAM_PAGINA = 100; -- Cantidad de registros que se muestran en pantalla

/* Creamos el universo de datos */
WITH DRV_TBL AS 
(
     SELECT 
          ROW_NUMBER() OVER (ORDER BY PAG.id_Registro DESC) AS rownum, PAG.*
     FROM 
dbo.tmp_out_contau_prestamo AS PAG
     WHERE
          tipo_documento <> 'HE'
)

/* Paginamos el resultado de la consulta */
SELECT * 
FROM DRV_TBL   
WHERE 
ROWNUM BETWEEN (@NUM_PAGINA * @TAM_PAGINA) - @TAM_PAGINA + 1 AND (@NUM_PAGINA * @TAM_PAGINA);

/*
Notas y referencias:
http://www.guillesql.es/Articulos/Paginar_SQLServer_ROW_NUMBER_TOP.aspx 
*/
