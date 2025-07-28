CREATE OR REPLACE FORCE VIEW VSOURCE
AS
    SELECT a.owner                                               "OWNR",
           a.name                                                "SRC_NM",
           a.TYPE                                                "SRC_TYPE",
           1                                                     "SORT1",
           1                                                     "SRC_LINE",
           'rem * NAME: ' || b.owner || '.' || b.object_name     "TEXTLINE"
      FROM all_source  a
           JOIN all_objects b ON b.owner = a.owner AND b.object_name = a.name
     WHERE b.object_type IN ('PROCEDURE',
                             'FUNCTION',
                             'PACKAGE',
                             'TRIGGER')
    UNION
    SELECT a.owner,
           a.name,
           a.TYPE,
           1,
           2,
           'rem * TYPE: ' || b.object_type
      FROM all_source  a
           JOIN all_objects b ON b.owner = a.owner AND b.object_name = a.name
     WHERE b.object_type IN ('PROCEDURE',
                             'FUNCTION',
                             'PACKAGE',
                             'TRIGGER')
    UNION
    SELECT a.owner,
           a.name,
           a.TYPE,
           1,
           3,
           'rem * CREATED: ' || TO_CHAR (b.created, 'DD-MON-YYYY HH24:MI:SS')
      FROM all_source  a
           JOIN all_objects b ON b.owner = a.owner AND b.object_name = a.name
     WHERE b.object_type IN ('PROCEDURE',
                             'FUNCTION',
                             'PACKAGE',
                             'TRIGGER')
    UNION
    SELECT a.owner,
           a.name,
           a.TYPE,
           1,
           4,
              'rem * LAST DDL: '
           || TO_CHAR (b.last_ddl_time, 'DD-MON-YYYY HH24:MI:SS')
      FROM all_source  a
           JOIN all_objects b ON b.owner = a.owner AND b.object_name = a.name
     WHERE b.object_type IN ('PROCEDURE',
                             'FUNCTION',
                             'PACKAGE',
                             'TRIGGER')
    UNION
    SELECT a.owner,
           a.name,
           a.TYPE,
           1,
           5,
           'CREATE OR REPLACE ' || a.TYPE || ' ' || a.OWNER || '.' || a.NAME
      FROM all_source  a
           JOIN all_objects b ON b.owner = a.owner AND b.object_name = a.name
     WHERE b.object_type IN ('PROCEDURE',
                             'FUNCTION',
                             'PACKAGE',
                             'TRIGGER')
    UNION
    SELECT a.owner,
           a.name,
           a.TYPE,
           2,
           a.line,
           a.text
      FROM all_source  a
           JOIN all_objects b ON b.owner = a.owner AND b.object_name = a.name
     WHERE     b.object_type IN ('PROCEDURE',
                                 'FUNCTION',
                                 'PACKAGE',
                                 'TRIGGER')
           AND a.LINE > 1
    UNION
    SELECT a.owner,
           a.name,
           a.TYPE,
           3,
           1,
           '/'
      FROM all_source  a
           JOIN all_objects b ON b.owner = a.owner AND b.object_name = a.name
     WHERE b.object_type IN ('PROCEDURE',
                             'FUNCTION',
                             'PACKAGE',
                             'TRIGGER')
/
SHOW ERRORS;
