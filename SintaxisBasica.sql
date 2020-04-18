--Establecer la BD que se va a utilizar.-
USE AdventureWorks2012;
GO

--Crear una tabla sobre la BD.-
CREATE TABLE Persona (
    prn_ID INT IDENTITY(1, 1) PRIMARY KEY,
    prn_Nombre VARCHAR(255),
    prn_Apellido VARCHAR(255),
    prn_Direccion VARCHAR(255),
    prn_Ciudad VARCHAR(255),
    prn_Fecha DATETIME NOT NULL
);

--Realizar un Insert sobre la BD.-
-- Inserción Normal
INSERT INTO dbo.Table1 (column_2, column_4) VALUES ('Explicit value', 'Explicit value');
GO

-- Insertar datos en una tabla FÍSICA desde un SELECT
INSERT INTO dbo.Table1 
SELECT T2.column_1, T2.column_2, T2.column_3
FROM dbo.table2 T2

-- Creamos una TABLA TEMPORAL e insertamos datos
SELECT column_1, column_2, column_3 
INTO #Table2 
FROM dbo.table1 
WHERE column_1 <> NULL

--Actualizar datos sobre la BD.-
UPDATE dbo.Table1
SET column_1 = value1, column_2 = 'Explicit value'
WHERE some_column = some_value;
GO

--Borrar datos de la BD.-
-- Borra una serie de filas de la tabla. 
DELETE dbo.ProductCostHistory  
WHERE StandardCost BETWEEN 12.00 AND 14.00  
      AND EndDate IS NULL;  
GO 
 
-- Borra todas las filas de la tabla y resetea el contador de auto incremento. 
TRUNCATE TABLE dbo.Table1; 
GO 
 
-- Elimina la tabla de la BD. 
DROP TABLE dbo.Table1; 
GO  
/*
Notas y referencias
http://www.linuxhispano.net/2012/02/06/diferencia-entre-delete-truncate-y-drop-en-sql/ 
*/

--Saber el Nro. de columnas que tiene una tabla.-
SELECT count(*) 
FROM INFORMATION_SCHEMA.columns 
WHERE table_name = 'nombreTabla'

--Buscar Texto dentro de todos los Procedimientos Almacenados (SP)
SELECT
    so.name,
    sc.text
FROM
    sysobjects so
    INNER JOIN syscomments sc ON so.id = sc.id
WHERE
    so.type = 'P' AND
    UPPER(sc.text) LIKE UPPER('%Texto_A_Buscar%');
/*
Notas y referencias
Lo utilizo para buscar tablas o funciones dentro de SP.
https://o5k4r.wordpress.com/2012/10/30/buscar-texto-en-todos-los-sp-de-sql-server/ 
*/

--Ver registros duplicados en una tabla
SELECT per_cli, count(*)
FROM personas
GROUP BY per_cli
HAVING count(*) > 1;
/*
Notas y referencias
https://support.microsoft.com/es-es/help/139444/how-to-remove-duplicate-rows-from-a-table-in-sql-server 
*/

--Obtener los registros que no están en la otra tabla
SELECT *    
  FROM data_base_ct t1 -- Tabla con más datos
 WHERE NOT EXISTS (SELECT NULL
                     FROM data_inicio_primera_etapa t2 -- Tabla con menos datos
                    WHERE t2.codigo_ct = t1.codct)

SELECT t1.*
  FROM data_base_ct t1 -- Tabla con más datos
  LEFT JOIN data_inicio_primera_etapa t2 -- Tabla con menos datos
    ON t2.codigo_ct = t1.codct
 WHERE t2.codigo_ct IS NULL
/*
Notas y referencias
https://es.stackoverflow.com/questions/122789/obtener-los-registros-que-no-están-en-otra-tabla 
*/

--Hacer un Marge entre tablas

/* Si el SP existe lo borra                 */
IF OBJECT_ID('dbo.add_sgr_garantias_prestamos_insert', 'P') IS NOT NULL 
DROP PROCEDURE dbo.add_sgr_garantias_prestamos_insert; 
GO 
 
/* Crea el SP                               */
CREATE PROCEDURE dbo.add_sgr_garantias_prestamos_insert 
AS 
BEGIN
    SET NOCOUNT ON;
    
    /* Establece la tabla con la que vamos  */
    /* a comparar, la tabla base y lo       */
    /* almacenamos en "target"              */
    MERGE add_sgr_garantias_prestamos AS target 

    /* Recuperamos los datos necesarios y   */
    /* lo almacenamos en "source"           */
    USING (
            select DISTINCT cta_id, irp.* from cuentas cta
            inner join productos pro ON cta.cta_pro = pro.pro_id
            inner join productos_x_grupo pxg on pxg.pxg_pro = pro.pro_id
            inner join grupo_productos grp on grp.grp_id = pxg.pxg_grp
            inner join in_add_sgr_garantias_prestamos irp 
on irp.in_Acct_Nbr = cta.cta_num_oper 
              and irp.in_Party_Id  = cta_cli
          ) AS source (
            cta_id,
            inNro_Doc_cu,
            inRazon,
            inParty_Id,  
            inAcct_Nbr,
            inEstado_Actual_PR_Comun,
            inLoan_Sociedad_Gtia_Desc,  
            inLoan_Branch_cod,
            inLoan_Fecha_Coloc,
            inLoan_Ultimo_Vto,
            inLoan_Monto )

    /* Igualamos los ID de target y Source  */
    ON (target.asg_cta = source.cta_id)

    /* Si los nuevos datos coinciden con la */
    /* tabla "target" Actualizamos          */
    WHEN MATCHED THEN
        UPDATE SET          
            asg_Nro_Doc_cu = source.inNro_Doc_cu,
            asg_Razon = source.inRazon,
            asg_Party_Id = source.inParty_Id,  
            asg_Acct_Nbr = source.inAcct_Nbr,
            asg_Estado_Actual_PR_Comun = source.inEstado_Actual_PR_Comun,
            asg_Loan_Sociedad_Gtia_Desc = source.inLoan_Sociedad_Gtia_Desc,
            asg_Loan_Branch_cod = source.inLoan_Branch_cod,
            asg_Loan_Fecha_Coloc = source.inLoan_Fecha_Coloc,
            asg_Loan_Ultimo_Vto = source.inLoan_Ultimo_Vto,
            asg_Loan_Monto = source.inLoan_Monto

    /* Si los nuevos datos no coinciden la  */
    /* tabla "target" Insertamos            */
    WHEN NOT MATCHED THEN  
        INSERT 
        (
            asg_cta,
            asg_Nro_Doc_cu,
            asg_Razon,
            asg_Party_Id,  
            asg_Acct_Nbr,
            asg_Estado_Actual_PR_Comun,
            asg_Loan_Sociedad_Gtia_Desc,
            asg_Loan_Branch_cod,
            asg_Loan_Fecha_Coloc,
            asg_Loan_Ultimo_Vto,
            asg_Loan_Monto
        )  
        VALUES 
        (
            source.cta_id,
            source.inNro_Doc_cu,
            source.inRazon,
            source.inParty_Id,  
            source.inAcct_Nbr,
            source.inEstado_Actual_PR_Comun,
            source.inLoan_Sociedad_Gtia_Desc,
            source.inLoan_Branch_cod,
            source.inLoan_Fecha_Coloc,
            source.inLoan_Ultimo_Vto,
            source.inLoan_Monto
        );
    
    /* Borramos los datos de la tabla       */
    /* antigua si es necesario              */
    truncate table in_add_sgr_garantias_prestamos;
END
GO
/*
Notas y referencias
https://code.i-harness.com/es/q/b5adca  
*/
