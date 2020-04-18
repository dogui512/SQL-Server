DECLARE @Number as INT = 102;

IF (@Number = 101)
BEGIN
Print 'Number is 101'; --False
END
ELSE IF (@Number = 102)
BEGIN
PRINT 'Number is 102'; --Skipped
END
ELSE
BEGIN
PRINT 'Number is out of scope'; --Skipped
END
GO 
