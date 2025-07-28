CREATE OR REPLACE FORCE VIEW TDEF
AS
    SELECT 0                                  "SORT1",
           owner                              "OWNR",
           table_name                         "TBL_NM",
           NULL                               "IDX_OWNR",
           NULL                               "IDX_NM",
           0                                  "SORT2",
           0                                  "SORT3",
              'drop table '
           || owner
           || '.'
           || table_name
           || ' cascade constraints purge'    "TEXTLINE"
      FROM all_tables
     WHERE (owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 0,
           owner,
           table_name,
           NULL,
           NULL,
           1,
           0,
           '/'
      FROM all_tables
     WHERE (owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    /*                                     */
    /* 1 level is for CREATE TABLE command */
    /*                                     */
    SELECT 1,
           owner,
           table_name,
           NULL,
           NULL,
           0,
           0,
              'create '
           || CASE
                  WHEN temporary = 'Y' THEN 'global temporary '
                  ELSE NULL
              END
           || 'table '
           || owner
           || '.'
           || table_name
      FROM all_tables
     WHERE (owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 1,
           owner,
           table_name,
           NULL,
           NULL,
           1,
           column_id,
           TRIM (
                  DECODE (column_id, 1, '( ', ', ')
               || RPAD (column_name, 31, ' ')
               || DATA_TYPE
               || DECODE (
                      data_type,
                      'DATE', NULL,
                      'LONG', NULL,
                      'RAW', NULL,
                      'LONG RAW', NULL,
                      'CHAR', '(' || data_length || ')',
                      'NCHAR', '(' || data_length || ')',
                      'VARCHAR', '(' || data_length || ')',
                      'NVARCHAR', '(' || data_length || ')',
                      'VARCHAR2', '(' || data_length || ')',
                      'NVARCHAR2', '(' || data_length || ')',
                      CASE
                          WHEN DATA_PRECISION IS NULL
                          THEN
                              NULL
                          ELSE
                                 '('
                              || DATA_PRECISION
                              || CASE
                                     WHEN DATA_SCALE IS NULL THEN NULL
                                     ELSE ',' || DATA_SCALE
                                 END
                              || ')'
                      END)
               || DECODE (nullable, 'N', ' NOT NULL', NULL)
               || CASE
                      WHEN DATA_DFLT (owner, table_name, column_name)
                               IS NOT NULL
                      THEN
                             '  DEFAULT '
                          || DATA_DFLT (owner, table_name, column_name)
                      ELSE
                          NULL
                  END)
      FROM all_tab_columns
     WHERE (owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 1,
           owner,
           table_name,
           NULL,
           NULL,
           2,
           1,
           CASE
               WHEN tablespace_name IS NOT NULL
               THEN
                   ') tablespace ' || tablespace_name
               ELSE
                      ') ON COMMIT '
                   || CASE
                          WHEN DURATION = 'SYS$SESSION'
                          THEN
                              'PRESERVE ROWS'
                          WHEN DURATION = 'SYS$TRANSACTION'
                          THEN
                              'DELETE ROWS'
                          ELSE
                              NULL
                      END
           END
      FROM all_tables
     WHERE (owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 1,
           owner,
           table_name,
           NULL,
           NULL,
           3,
           1,
              'pctfree '
           || pct_free
           || DECODE (pct_used, NULL, NULL, ' pctused ' || pct_used)
      FROM all_tables
     WHERE     tablespace_name IS NOT NULL
           AND (owner, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 1,
           owner,
           table_name,
           NULL,
           NULL,
           3,
           2,
              'storage (initial '
           || initial_extent
           || DECODE (next_extent, NULL, NULL, ' next ' || next_extent)
           || DECODE (pct_increase,
                      NULL, NULL,
                      ' pctincrease ' || pct_increase)
           || ' minextents '
           || min_extents
           || DECODE (
                  max_extents,
                  NULL, NULL,
                     ' maxextents '
                  || DECODE (max_extents,
                             2147483645, 'unlimited',
                             max_extents))
           || ')'
      FROM all_tables
     WHERE     tablespace_name IS NOT NULL
           AND initial_extent IS NOT NULL
           AND (owner, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 1,
           owner,
           table_name,
           NULL,
           NULL,
           4,
           0,
           '/'
      FROM all_tables
     WHERE (owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    /*                                      */
    /* 2 level is for CREATE INDEX commands */
    /*                                      */
    SELECT 2,
           table_owner,
           table_name,
           owner,
           index_name,
           1,
           0,
              'create '
           || DECODE (uniqueness, 'UNIQUE', 'unique ', NULL)
           || DECODE (index_type, 'BITMAP', 'bitmap ', NULL)
           || 'index '
           || owner
           || '.'
           || index_name
           || ' on '
           || table_name
      FROM all_indexes
     WHERE (table_owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 2,
           table_owner,
           table_name,
           index_owner,
           index_name,
           2,
           column_position,
           DECODE (column_position, 1, '( ', ', ') || column_name
      FROM all_ind_columns
     WHERE (table_owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 2,
           table_owner,
           table_name,
           owner,
           index_name,
           3,
           0,
              ')'
           || DECODE (tablespace_name,
                      NULL, NULL,
                      ' tablespace ' || tablespace_name)
      FROM all_indexes
     WHERE (table_owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 2,
           table_owner,
           table_name,
           owner,
           index_name,
           3,
           1,
              'storage (initial '
           || initial_extent
           || DECODE (next_extent, NULL, NULL, ' next ' || next_extent)
           || DECODE (pct_increase,
                      NULL, NULL,
                      ' pctincrease ' || pct_increase)
           || ' minextents '
           || min_extents
           || DECODE (
                  max_extents,
                  NULL, NULL,
                     ' maxextents '
                  || DECODE (max_extents,
                             2147483645, 'unlimited',
                             max_extents))
           || ')'
      FROM all_indexes
     WHERE     tablespace_name IS NOT NULL
           AND initial_extent IS NOT NULL
           AND (owner, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 2,
           table_owner,
           table_name,
           owner,
           index_name,
           4,
           0,
           '/'
      FROM all_indexes
     WHERE (owner, table_name) NOT IN
               (SELECT owner, view_name FROM all_views)
    UNION
    /*                                                       */
    /* 3 level is for ALTER TABLE add PRIMARY KEY constraint */
    /*                                                       */
    SELECT 3,
           owner,
           table_name,
           owner,
           constraint_name,
           1,
           1,
           'alter table ' || owner || '.' || table_name     "TEXTLINE"
      FROM all_constraints
     WHERE constraint_type = 'P'
    UNION
    SELECT 3,
           owner,
           table_name,
           owner,
           constraint_name,
           2,
           1,
           'add constraint ' || constraint_name || ' primary key'
      FROM all_constraints
     WHERE constraint_type = 'P'
    UNION
    SELECT 3,
           a.owner,
           a.table_name,
           a.owner,
           a.constraint_name,
           3,
           b.position,
           DECODE (position, 1, '( ', ', ') || column_name
      FROM all_constraints a, all_cons_columns b
     WHERE     b.owner = a.owner
           AND b.table_name = a.table_name
           AND b.constraint_name = a.constraint_name
           AND a.constraint_type = 'P'
    UNION
    SELECT 3,
           ac.owner,
           ac.table_name,
           ac.owner,
           ac.constraint_name,
           4,
           1,
              ')'
           || CASE
                  WHEN AI.index_name = AC.constraint_name
                  THEN
                         ' using index '
                      || ac.owner
                      || '.'
                      || ac.constraint_name
                  ELSE
                      NULL
              END
      FROM all_constraints  "AC"
           LEFT OUTER JOIN all_indexes "AI"
               ON     AI.table_owner = AC.owner
                  AND AI.table_name = AC.table_name
                  AND AI.index_name = AC.constraint_name
     WHERE     AC.constraint_type = 'P'
           AND (AC.owner, AC.table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 3,
           owner,
           table_name,
           owner,
           constraint_name,
           4,
           2,
           '/'
      FROM all_constraints
     WHERE     constraint_type = 'P'
           AND (owner, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    /*                                                       */
    /* 4 level is for ALTER TABLE add FOREIGN KEY constraint */
    /*                                                       */
    SELECT 4,
           owner,
           table_name,
           owner,
           constraint_name,
           1,
           1,
           'alter table ' || owner || '.' || table_name
      FROM all_constraints
     WHERE constraint_type = 'R'
    UNION
    SELECT 4,
           owner,
           table_name,
           owner,
           constraint_name,
           2,
           1,
           'add constraint ' || constraint_name || ' foreign key'
      FROM all_constraints
     WHERE constraint_type = 'R'
    UNION
    SELECT 4,
           a.owner,
           a.table_name,
           a.owner,
           a.constraint_name,
           3,
           b.position,
           DECODE (position, 1, '( ', ', ') || column_name
      FROM all_constraints a, all_cons_columns b
     WHERE     b.owner = a.owner
           AND b.table_name = a.table_name
           AND b.constraint_name = a.constraint_name
           AND a.constraint_type = 'R'
    UNION
    SELECT 4,
           a.owner,
           a.table_name,
           a.owner,
           a.constraint_name,
           4,
           1,
           ') references ' || b.table_name
      FROM all_constraints a, all_constraints b
     WHERE     b.owner = a.r_owner
           AND b.constraint_name = a.r_constraint_name
           AND a.constraint_type = 'R'
           AND b.constraint_type = 'P'
    UNION
    SELECT 4,
           a.owner,
           a.table_name,
           a.owner,
           a.constraint_name,
           5,
           c.position,
           DECODE (c.position, 1, '( ', ', ') || c.column_name
      FROM all_constraints a, all_constraints b, all_cons_columns c
     WHERE     b.owner = a.r_owner
           AND b.constraint_name = a.r_constraint_name
           AND a.constraint_type = 'R'
           AND b.constraint_type = 'P'
           AND c.owner = b.owner
           AND c.table_name = b.table_name
           AND c.constraint_name = b.constraint_name
    UNION
    SELECT 4,
           owner,
           table_name,
           owner,
           constraint_name,
           6,
           1,
              ') '
           || CASE
                  WHEN status = 'DISABLED' THEN 'disable'
                  WHEN status = 'ENABLED' THEN 'enable'
                  ELSE NULL
              END
      FROM all_constraints
     WHERE constraint_type = 'R'
    UNION
    SELECT 4,
           owner,
           table_name,
           owner,
           constraint_name,
           6,
           2,
           '/'
      FROM all_constraints
     WHERE     constraint_type = 'R'
           AND (owner, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    /*                                                  */
    /* 5 level is for ALTER TABLE add UNIQUE constraint */
    /*                                                  */
    SELECT 5,
           owner,
           table_name,
           owner,
           constraint_name,
           1,
           1,
           'alter table ' || owner || '.' || table_name
      FROM all_constraints
     WHERE     constraint_type = 'U'
           AND (owner, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 5,
           owner,
           table_name,
           owner,
           constraint_name,
           2,
           1,
           'add constraint ' || constraint_name || ' unique'
      FROM all_constraints
     WHERE     constraint_type = 'U'
           AND (owner, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 5,
           a.owner,
           a.table_name,
           a.owner,
           a.constraint_name,
           3,
           position,
           DECODE (position, 1, '( ', ', ') || column_name
      FROM all_constraints a, all_cons_columns b
     WHERE     b.owner = a.owner
           AND b.constraint_name = a.constraint_name
           AND a.constraint_type = 'U'
    UNION
    SELECT 5,
           ac.owner,
           ac.table_name,
           ac.owner,
           ac.constraint_name,
           4,
           1,
              ')'
           || CASE
                  WHEN AI.index_name = AC.constraint_name
                  THEN
                         ' using index '
                      || ac.owner
                      || '.'
                      || ac.constraint_name
                  ELSE
                      NULL
              END
      FROM all_constraints  "AC"
           LEFT OUTER JOIN all_indexes "AI"
               ON     AI.table_owner = AC.owner
                  AND AI.table_name = AC.table_name
                  AND AI.index_name = AC.constraint_name
     WHERE     AC.constraint_type = 'U'
           AND (AC.owner, AC.table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 5,
           owner,
           table_name,
           owner,
           constraint_name,
           4,
           2,
           '/'
      FROM all_constraints
     WHERE     constraint_type = 'U'
           AND (owner, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    /*                                     */
    /* 6 level is for TABLE level comments */
    /*                                     */
    SELECT 6,
           owner,
           table_name,
           NULL,
           NULL,
           1,
           1,
              'comment on table '
           || owner
           || '.'
           || table_name
           || ' is '''
           || REPLACE (comments, '''', '''''')
           || ''';'
      FROM all_tab_comments
     WHERE comments IS NOT NULL AND table_type = 'TABLE'
    UNION
    /*                                      */
    /* 7 level is for COLUMN level comments */
    /*                                      */
    SELECT 7,
           owner,
           table_name,
           NULL,
           column_name,
           1,
           1,
              'comment on column '
           || owner
           || '.'
           || table_name
           || '.'
           || column_name
           || ' is '''
           || REPLACE (comments, '''', '''''')
           || ''';'
      FROM all_col_comments
     WHERE comments IS NOT NULL
    UNION
    /*                                      */
    /* 8 level is for DROP SEQUENCE command */
    /*                                      */
    SELECT 8,
           sequence_owner,
           sequence_name,
           NULL,
           NULL,
           1,
           1,
           'drop sequence ' || sequence_owner || '.' || sequence_name
      FROM all_sequences
    UNION
    SELECT 8,
           sequence_owner,
           sequence_name,
           NULL,
           NULL,
           2,
           1,
           '/'
      FROM all_sequences
    UNION
    /*                                        */
    /* 9 level is for CREATE SEQUENCE command */
    /*                                        */
    SELECT 9,
           sequence_owner,
           sequence_name,
           NULL,
           NULL,
           1,
           1,
           'create sequence ' || sequence_owner || '.' || sequence_name
      FROM all_sequences
    UNION
    SELECT 9,
           sequence_owner,
           sequence_name,
           NULL,
           NULL,
           2,
           1,
           'minvalue ' || min_value || ' maxvalue ' || max_value
      FROM all_sequences
    UNION
    SELECT 9,
           sequence_owner,
           sequence_name,
           NULL,
           NULL,
           3,
           1,
              'increment by '
           || increment_by
           || ' start with '
           || DECODE (last_number,
                      min_value, TO_CHAR (min_value),
                      TO_CHAR (last_number + increment_by))
      FROM all_sequences
    UNION
    SELECT 9,
           sequence_owner,
           sequence_name,
           NULL,
           NULL,
           4,
           1,
              DECODE (cache_size, 0, 'NOCACHE', 'CACHE ' || cache_size)
           || ' '
           || DECODE (order_flag, 'N', 'NO', NULL)
           || 'ORDER '
           || DECODE (cycle_flag, 'N', 'NO', NULL)
           || 'CYCLE'
      FROM all_sequences
    UNION
    SELECT 9,
           sequence_owner,
           sequence_name,
           NULL,
           NULL,
           4,
           2,
           '/'
      FROM all_sequences
    UNION
    /*                                */
    /* 10 level is for GRANT commands */
    /*                                */
    SELECT 10,
           table_schema,
           table_name,
           NULL,
           NULL,
           1,
           1,
              'grant '
           || privilege
           || ' on '
           || table_schema
           || '.'
           || table_name
           || ' to '
           || grantee
           || DECODE (grantable, 'YES', ' with grant option', NULL)
      FROM all_tab_privs
     WHERE     privilege != 'INHERIT PRIVILEGES'
           AND (table_schema, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    SELECT 10,
           table_schema,
           table_name,
           NULL,
           NULL,
           1,
           2,
           '/'
      FROM all_tab_privs
     WHERE     privilege != 'INHERIT PRIVILEGES'
           AND (table_schema, table_name) NOT IN
                   (SELECT owner, view_name FROM all_views)
    UNION
    /*                                                            */
    /* 11 level is for ALTER TABLE CACHE and/or PARALLEL commands */
    /*                                                            */
    SELECT 11,
           owner,
           table_name,
           NULL,
           NULL,
           1,
           1,
              'alter table '
           || owner
           || '.'
           || table_name
           || ' '
           || DECODE (LTRIM (RTRIM (cache, ' '), ' '), 'Y', 'CACHE ', NULL)
           || DECODE (
                  LTRIM (RTRIM (degree, ' '), ' '),
                  '1', NULL,
                  'DEFAULT', NULL,
                     'PARALLEL(DEGREE '
                  || LTRIM (RTRIM (degree, ' '), ' ')
                  || ')')
      FROM all_tables
     WHERE    LTRIM (RTRIM (degree, ' '), ' ') NOT IN ('1', 'DEFAULT')
           OR LTRIM (RTRIM (cache, ' '), ' ') = 'Y'
    UNION
    SELECT 11,
           owner,
           table_name,
           NULL,
           NULL,
           1,
           1,
           '/'
      FROM all_tables
     WHERE    LTRIM (RTRIM (degree, ' '), ' ') NOT IN ('1', 'DEFAULT')
           OR LTRIM (RTRIM (cache, ' '), ' ') = 'Y'
/
SHOW ERRORS;
