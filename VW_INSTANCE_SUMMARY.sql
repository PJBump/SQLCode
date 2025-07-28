CREATE OR REPLACE FORCE VIEW V_INSTANCE_SUMMARY
AS
    SELECT SUM (bytes)           "BYTES_ALLOCATED",
           SUM (blocks)          "BLOCKS_ALLOCATED",
           SUM (free_bytes)      "BYTES_FREE",
           SUM (free_blocks)     "BLOCKS_FREE",
           SUM (used_bytes)      "BYTES_USED",
           SUM (used_blocks)     "BLOCKS_USED"
      FROM v_instance_allocated
/
SHOW ERRORS;
