select blocks from dba_segments where owner = 'NIKOVITS' and segment_name = 'CIKK';

--how many data blocks we have
select * from nikovits.cikk;

select DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid) from
NIKOVITS.CIKK;

--How many filled data blocks does the previous table have?
--Filled means that the block is not empty (there is at least one row in it).
--This question is not the same as the previous !!!
--How many empty data blocks does the table have?

select count(distinct DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid)) as FILLED_BLOCK from NIKOVITS.CIKK;

--how many empty data blocks does the table have?

create or replace function calc_empty_blocks return integer
is
    reserved_blocks integer;
    filled_blocks integer;
    empty_blocks integer;
begin
    select blocks into reserved_blocks
    from dba_segments where owner = 'NIKOVITS' and segment_name = 'CIKK';
    select count(distinct DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid)) into filled_blocks from NIKOVITS.CIKK;
    empty_blocks := reserved_blocks - filled_blocks;
    return empty_blocks;
end;

select calc_empty_blocks() from dual;


select dbms_rowid.rowid_block_number(rowid), count(dbms_rowid.rowid_row_number(rowid)) from nikovits.cikk group by dbms_rowid.rowid_block_number(rowid);


--4.
--There is a table NIKOVITS.ELADASOK which has the following row:
--szla_szam = 100 (szla_szam is a column name)
--In which datafile is the given row stored?
--Within the datafile in which data block? (block number) 
--In which data object? (Give the name of the segment.)

select * from nikovits.eladasok where szla_szam = 100;

-- 1) datafile given row stored
select dbms_rowid.rowid_relative_fno(rowid) from nikovits.eladasok where szla_szam = 100;
-- 2) block number and 3) object identifier
select dbms_rowid.rowid_relative_fno(rowid), dbms_rowid.rowid_block_number(rowid), dbms_rowid.rowid_object(rowid) from nikovits.eladasok where szla_szam = 100;

create or replace procedure get_file_and_segment is
    fno integer;
    bno integer;
    ono integer;
    fname varchar(100);
    sname varchar(100);
begin
    select dbms_rowid.rowid_relative_fno(rowid), dbms_rowid.rowid_block_number(rowid), dbms_rowid.rowid_object(rowid) into fno, bno, ono from nikovits.eladasok where szla_szam = 100;
    select file_name into fname from dba_data_files where relative_fno = fno;
    select segment_name into sname from dba_segments where relative_fno = fno and bno between header_block and header_block+blocks;
    
    dbms_output.put_line(fno || ' - ' || bno || ' - ' || ono);
    dbms_output.put_line(fname || ' - ' || sname);
end;

set serveroutput on;
call get_file_and_segment();

--6.
--Write a PL/SQL procedure which counts and prints the number of empty blocks of a table.
--Output format -> Empty Blocks: nnn
--
--CREATE OR REPLACE PROCEDURE empty_blocks(p_owner VARCHAR2, p_table VARCHAR2) IS
--...
--Test:
-------
--set serveroutput on
--EXECUTE empty_blocks('nikovits', 'employees');
--
--Check your solution with the following procedure:
--EXECUTE check_plsql('empty_blocks(''nikovits'', ''employees'')');
--
--Hint: 
--Count the total number of blocks (see the segment), the filled blocks (use ROWID), 
--the difference is the number of empty blocks.
--You have to use dynamic SQL statement in the PL/SQL program, see pl_dynamicSQL.txt

select * from dba_segments;
