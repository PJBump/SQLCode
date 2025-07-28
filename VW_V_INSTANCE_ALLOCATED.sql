CREATE OR REPLACE FORCE VIEW V_INSTANCE_ALLOCATED
AS
      SELECT d.tablespace_name,
             d.file_id,
             SUM (d.bytes)                       "BYTES",
             SUM (d.blocks)                      "BLOCKS",
             SUM (f.bytes)                       "FREE_BYTES",
             SUM (f.blocks)                      "FREE_BLOCKS",
             SUM (d.bytes) - SUM (f.bytes)       "USED_BYTES",
             SUM (d.blocks) - SUM (f.blocks)     "USED_BLOCKS"
        FROM dba_data_files "D"
             JOIN dba_free_space "F"
                 ON     f.tablespace_name = d.tablespace_name
                    AND f.file_id = d.file_id
    GROUP BY d.tablespace_name, d.file_id
/
SHOW ERRORS;
