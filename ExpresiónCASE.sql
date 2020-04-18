--Estructura de CASE

SELECT ID, Name, Gender, Salary, 
    CASE GENDER 
        WHEN 'M' THEN 'Board 10th Coach'
        WHEN 'F' THEN 'Board 11th Coach' 
    END as CoachInfo
FROM  
(VALUES (1,'Vish', 'M', 100)
       ,(2,'Atul', 'M', 200)
       ,(3,'Vishal','M', 500)
       ,(4,'Kasturi','F',2000)
       ,(5,'Belinda','F',5000))
as Emp(Id, Name, Gender, Salary);

--Ejemplo 2

SELECT ID, Name, Gender, Salary,
CASE WHEN  Name IN ('Atul', 'Belinda') THEN 'Class 1'
     WHEN  Name LIKE 'K%' THEN 'Class 2'
     WHEN  (Name = 'Vish' OR Name = 'Vishal') THEN 'Class 3'
     ELSE  'No Class'
END as ClassInfo
FROM  
(VALUES (1,'Vish', 'M', 100)
       ,(2,'Atul', 'M', 200)
       ,(3,'Vishal','M', 500)
       ,(4,'Kasturi','F',2000)
       ,(5,'Belinda','F',5000)
       ,(5,'Simona','M',5000))
as Emp(Id, Name, Gender, Salary);

--Ejemplo 3

SELECT ID, Name, Gender, Salary,CASE  WHEN Salary >= 500 AND Salary < 2000 THEN 'Economy Class'      WHEN Salary >= 2000 THEN 'Premium Class'      ELSE 'No Travel' END TravelModeFROM  (VALUES (1,'Vish', 'M', 100)        ,(2,'Atul', 'M', 200)        ,(3,'Vishal','M', 500)        ,(4,'Kasturi','F',2000)        ,(5,'Belinda','F',5000))as Emp(Id, Name, Gender, Salary);

/*
https://stackoverflow.com/questions/15766102/i-want-to-use-case-statement-to-update-some-records-in-sql-server-2005 


Notas y referencias:
https://www.tech-recipes.com/rx/72149/how-to-use-searched-case-expression-in-sql-server/  
*/
