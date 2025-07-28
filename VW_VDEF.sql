CREATE OR REPLACE FORCE VIEW VDEF
AS
    SELECT view_name    "VIEW_NM",
           1            "SORT1",
              'create or replace force view '
           || USER
           || '.'
           || view_name
           || ' as'     "TEXTLINE"
      FROM user_views
    UNION
    SELECT view_name, 2, text_vc FROM user_views
    UNION
    SELECT view_name, 3, '/' FROM user_views
/
SHOW ERRORS;
