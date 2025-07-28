CREATE OR REPLACE FORCE VIEW V_OBJECT_SPACE
AS
      SELECT owner,
             parent_name,
             SUM (bytes)      "BYTES",
             SUM (blocks)     "BLOCKS"
        FROM v_object_parent
    GROUP BY owner, parent_name
/
SHOW ERRORS;
