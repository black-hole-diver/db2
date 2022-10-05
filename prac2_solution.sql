CREATE OR REPLACE PROCEDURE newest_table(p_user VARCHAR2) IS 
    t_name VARCHAR2(128);
    t_size NUMBER;
    t_date VARCHAR2(19);
BEGIN
    select object_name, max_timestamp into t_name, t_date from (select object_name, timestamp as max_timestamp from dba_objects where object_type = 'TABLE' and owner = p_user order by timestamp DESC)
    where rownum = 1;
    
    --select TO_CHAR(TO_DATE(csv_stats_gen_time,'yyyy-mm-dd hh:mi'), 'YYYY-MM-DD') 
    
    select bytes into t_size from dba_segments where segment_name = t_name and owner = p_user;
    
    DBMS_OUTPUT.PUT_LINE('Table_name: ' || t_name || 'Size: ' || t_size || ' bytes   Created: ' || t_date);
END;

describe dba_objects;



select * 
from (select object_name, timestamp as max_timestamp from dba_objects where object_type = 'TABLE' and owner = 'NIKOVITS' order by timestamp DESC)
where rownum = 1;
--...
SET SERVEROUTPUT ON
EXECUTE newest_table('NIKOVITS');

EXECUTE check_plsql('newest_table(''NIKOVITS'')');
