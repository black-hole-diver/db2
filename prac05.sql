--#Write a PL/SQL procedure which prints out the storage type (heap organized, partitioned, index organized or clustered) 
--for the parameter table. Output should look like the following:
--   Clustered: NO Partitioned: YES IOT: NO#

CREATE OR REPLACE PROCEDURE print_type(p_owner VARCHAR2, p_table VARCHAR2)
IS
    clustered varchar(20);
    is_partitioned varchar(4);
    iot varchar(20);
    is_clustered varchar(4);
    is_iot varchar(4);
BEGIN
    SELECT cluster_name, partitioned, iot_type INTO clustered, is_partitioned, iot FROM dba_tables WHERE owner = p_owner and table_name = p_table;
    -- for is_clustered
    IF clustered is not null THEN
        is_clustered := 'YES';
    ELSE
        is_clustered := 'NO';
    END IF;
    -- for is_iot
    IF iot is not null THEN
        is_iot := 'YES';
    ELSE
        is_iot := 'NO';
    END IF;
    -- putline
    DBMS_OUTPUT.PUT_LINE('Clustered: ' || is_clustered || ' Partitioned: ' || is_partitioned || ' IOT: ' || is_iot);
END;

--Check your solution with the following procedure:
EXECUTE check_plsql('print_type(''NIKOVITS'',''EMP_CLT'')');

set serveroutput on
execute print_type('NIKOVITS', 'EMP');

set serveroutput on
execute print_type('NIKOVITS', 'EMP');

set serveroutput on
execute print_type('NIKOVITS', 'ELADASOK5');

set serveroutput on
execute print_type('NIKOVITS', 'CIKK_IOT');

set serveroutput on
execute print_type('NIKOVITS', 'EMP_CLT');