--Ejemplo 01
DECLARE @site_value INT;
SET @site_value = 0;

WHILE @site_value <= 10
BEGIN
PRINT 'Inside WHILE LOOP on TechOnTheNet.com';
SET @site_value = @site_value + 1;
END;

PRINT 'Done WHILE LOOP on TechOnTheNet.com';
GO

--Ejemplo 02
DECLARE @NroAgencia VARCHAR(3);
DECLARE @Count INT;

SET @Count = 0;          

WHILE (@Count < 10)
BEGIN
     SET @NroAgencia = '00' + CAST(@Count AS VARCHAR(3));
     
     IF OBJECT_ID('tempdb..#temp01', 'U') IS NOT NULL 
          DROP TABLE #temp02;
                         
     SELECT 
          of_age AS of_age, 
          of_cliente AS of_cliente, 
          '' AS of_priorizador, 
          '' AS of_grupo 
     INTO #temp02 
     FROM OrdenFinal_Clientes_Temp WHERE of_age = @NroAgencia;
     
     SELECT * FROM #temp02;

     SET @Count = @Count + 1;
END 
