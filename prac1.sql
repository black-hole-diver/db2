--Database objects
------------------
--(DBA_OBJECTS)
--
--1.
--Who is the owner of the view DBA_TABLES? Who is the owner of table DUAL? (owner)
SELECT DISTINCT owner FROM all_objects WHERE object_name = 'DBA_TABLES'; --public
SELECT DISTINCT owner FROM all_objects WHERE object_name = 'DUAL'; --public
--2.
--Who is the owner of synonym DBA_TABLES? (or synonym DUAL) (owner)
SELECT DISTINCT owner FROM DBA_SYNONYMS where SYNONYM_NAME = 'DBA_TABLES' ; --public
--3.
--What kind of objects the database user ORAUSER has? (dba_objects.object_type column)
SELECT DISTINCT dba_objects.object_type FROM dba_objects WHERE owner = 'ORAUSER';

--4.
--What are the object types existing in the database? (object_type) 
SELECT DISTINCT object_type FROM dba_objects;
select * from dba_objects;
--5.
--Which users have more than 10 different kind of objects in the database? (owner)
SELECT owner  FROM
(SELECT DISTINCT owner, count(DISTINCT object_type) AS counting FROM dba_objects GROUP BY owner ORDER BY owner DESC)
WHERE counting > 10;

--6.
--Which users have both triggers and views in the database? (owner)
SELECT distinct owner FROM dba_objects WHERE object_type = 'TRIGGER'
INTERSECT
SELECT distinct owner FROM dba_objects WHERE object_type = 'VIEW';

select * from dba_objects;

--7.
--Which users have views but don't have triggers? (owner)
SELECT distinct owner FROM dba_objects
MINUS
SELECT distinct owner FROM dba_objects WHERE object_type = 'TRIGGER';

--8.
--Which users have more than 40 tables, but less than 30 indexes? (owner)

select distinct owner from dba_objects where object_type = 'TABLE'
group by owner
having count(*) > 40
INTERSECT
select distinct owner from dba_objects where object_type = 'INDEX'
group by owner 
having count(*) < 30;

(SELECT distinct owner FROM(
SELECT distinct owner, count(object_name) as counting
FROM dba_objects WHERE object_type = 'TABLE' GROUP BY owner ORDER BY owner)
WHERE counting > 40)
INTERSECT
(SELECT distinct owner FROM(
SELECT distinct owner, count(object_name) as counting
FROM dba_objects WHERE object_type = 'INDEX' GROUP BY owner ORDER BY owner)
WHERE counting < 30);

--9.
--Let's see the difference between a table and a view (dba_objects.data_object_id).
SELECT distinct object_type, data_object_id FROM dba_objects WHERE object_type= 'VIEW' or object_type = 'TABLE' ORDER BY object_type ASC;
-- table has data_object_id, view does not have it

--10.
--Which object types have NULL (or 0) in the column data_object_id? (object_type)
SELECT distinct object_type FROM dba_objects WHERE data_object_id is null or data_object_id = 0 ORDER BY object_type; 

--11.
--Which object types have non NULL (and non 0) in the column data_object_id? (object_type)
(SELECT distinct object_type FROM dba_objects  )
MINUS
(SELECT distinct object_type FROM dba_objects WHERE data_object_id is null or data_object_id = 0 );

--12.
--What is the intersection of the previous 2 queries? (object_type)
(SELECT distinct object_type FROM dba_objects WHERE data_object_id is null or data_object_id = 0)
INTERSECT
(
(SELECT distinct object_type FROM dba_objects  )
MINUS
(SELECT distinct object_type FROM dba_objects WHERE data_object_id is null or data_object_id = 0 )
);
-- null
--
--
--Columns of a table
--------------------
--(DBA_TAB_COLUMNS)
select * from dba_tab_columns;
--
--13.
--How many columns nikovits.emp table has? (num)
select count(column_name) as nikovits_emp_number_columns from dba_tab_columns where owner = 'NIKOVITS' and table_name = 'EMP';
--14.
--What is the data type of the 6th column of the table nikovits.emp? (data_type)
select data_type from dba_tab_columns where owner = 'NIKOVITS' and table_name = 'EMP' and column_id = 6;
--15.
--Give the owner and name of the tables which have column name beginning with letter 'Z'.
select distinct owner, table_name from dba_tab_columns where column_name like 'Z%';
--(owner, table_name)

--16.
--Give the owner and name of the tables which have at least 8 columns with data type DATE.
--(owner, table_name)
select distinct owner, table_name from dba_tab_columns where data_type = 'DATE'
group by owner, table_name
having count(*) >= 8;

--17.
--Give the owner and name of the tables whose 1st and 4th column's datatype is VARCHAR2.
--(owner, table_name)
select owner, table_name from dba_tab_columns where column_id = 1 and data_type = 'VARCHAR2'
INTERSECT
select owner, table_name from dba_tab_columns where column_id = 4 and data_type = 'VARCHAR2' order by owner;
--
--18.
--Write a PL/SQL procedure, which prints out the owners and names of the tables beginning with the 
--parameter character string. 

CREATE OR REPLACE PROCEDURE table_print(p VARCHAR2) IS
    CURSOR cur
    is
        SELECT distinct owner, table_name FROM dba_tab_columns WHERE substr(table_name,1,1) = p ORDER BY owner;
    cur_owner varchar2(128) := null;
    cur_table varchar2(128) := null;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur into cur_owner, cur_table;
        EXIT WHEN cur%notfound;
        DBMS_OUTPUT.PUT_LINE(cur_owner || ' ' || cur_table);
    END LOOP;
    CLOSE cur;
END;

set serveroutput on
execute table_print('F');

set serveroutput on
execute table_print('V');
