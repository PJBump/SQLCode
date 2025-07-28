CREATE OR REPLACE FORCE VIEW CATALOG
AS
      SELECT OBJECT_TYPE                                          "OBJ_TYPE",
             SUBSTR (OBJECT_NAME, 1, 30)                          "OBJ_NAME",
             STATUS,
             TO_CHAR (LAST_DDL_TIME, 'YYYY/MM/DD HH24:MI:SS')     "LAST_DDL"
        FROM USER_OBJECTS
    ORDER BY 2, 1
/
SHOW ERRORS;
