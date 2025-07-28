CREATE OR REPLACE FORCE VIEW V_OBJECT_PARENT
AS
      SELECT t.owner,
             t.table_name            "PARENT_NAME",
             t.table_name            "OBJECT_NAME",
             NVL (t.num_rows, 0)     "ROW_COUNT",
             t.tablespace_name,
             SUM (s.bytes)           "BYTES",
             SUM (s.blocks)          "BLOCKS"
        FROM dba_tables "T"
             JOIN dba_segments "S"
                 ON     s.owner = t.owner
                    AND s.segment_name = t.table_name
                    AND s.segment_type = 'TABLE'
    GROUP BY t.owner,
             t.table_name,
             t.table_name,
             NVL (t.num_rows, 0),
             t.tablespace_name
    UNION
      SELECT i.owner,
             i.table_name            "PARENT_NAME",
             i.index_name            "OBJECT_NAME",
             NVL (i.num_rows, 0)     "ROW_COUNT",
             i.tablespace_name,
             SUM (s.bytes)           "BYTES",
             SUM (s.blocks)          "BLOCKS"
        FROM dba_indexes "I"
             JOIN dba_segments "S"
                 ON     s.owner = i.owner
                    AND s.segment_name = i.index_name
                    AND s.segment_type = 'INDEX'
    GROUP BY i.owner,
             i.table_name,
             i.index_name,
             NVL (i.num_rows, 0),
             i.tablespace_name
/
SHOW ERRORS;
