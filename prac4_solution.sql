--Write a PL/SQL procedure which prints out the names and sizes (in bytes) of indexes created
--on the parameter table. Indexes should be in alphabetical order, and the format of the 
--output should be like this: (number of spaces doesn't count between the columns)
--CUSTOMERS_YOB_BIX:   196608
--
CREATE OR REPLACE PROCEDURE list_indexes(p_owner VARCHAR2, p_table VARCHAR2) IS
    CURSOR cur
    IS
        SELECT index_name FROM dba_indexes WHERE owner = p_owner and table_name = p_table;
    ind_name varchar2(128);
    ind_size NUMBER;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO ind_name;
        select bytes into ind_size from dba_segments where segment_name = ind_name;
        EXIT WHEN cur%notfound;
        DBMS_OUTPUT.PUT_LINE(ind_name || ': ' || ind_size);
    END LOOP;
    CLOSE cur;
END;

SET SERVEROUTPUT ON
EXECUTE list_indexes('NIKOVITS', 'BARS');

SET SERVEROUTPUT ON
EXECUTE list_indexes('NIKOVITS', 'CUSTOMERS');

set serveroutput on
EXECUTE check_plsql('list_indexes(''NIKOVITS'',''CUSTOMERS'')');
