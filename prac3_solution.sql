CREATE OR REPLACE PROCEDURE empty_blocks(p_owner VARCHAR2, p_table VARCHAR2) IS
    reserved_blocks integer := 0;
    filled_blocks integer;
    empty_blocks integer := 0;
    v_str varchar2(2000);
BEGIN
    select blocks into reserved_blocks
        from dba_segments where owner = p_owner and segment_name = p_table;
    v_str := 'select count(distinct DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid))  from ' || p_owner || '.' || p_table;
    EXECUTE IMMEDIATE v_str INTO filled_blocks;
    empty_blocks := reserved_blocks - filled_blocks;
    DBMS_OUTPUT.PUT_LINE(' Empty Blocks: ' || empty_blocks);
END;

--test1
set serveroutput on
execute empty_blocks('NIKOVITS', 'EMPLOYEES');

--test2
set serveroutput on
execute empty_blocks('HDZSFE', 'DEPT');

--PROBLEM--
HDZSFE.EMPTY_BLOCKS ---> calling the program failed.
100 -- ORA-01403: no data found
--when execute check_plsql(...)
EXECUTE check_plsql('empty_blocks(''nikovits'', ''employees'')');
