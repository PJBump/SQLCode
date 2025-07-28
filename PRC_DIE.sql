CREATE OR REPLACE procedure DIE
( iOBJECT_NAME     IN    VARCHAR2
, iOWNER           IN    VARCHAR2  default USER
, iOBJECT_TYPE     IN    VARCHAR2  default 'TABLE'
) as

/* DIE is an acronym for "DROP IF EXISTS"
   This procedure created to eliminate informational error messages of "object does not exist"
   when attempting to drop the object.
*/

v_object_name  VARCHAR2(30);
v_owner        VARCHAR2(30);
v_object_type  VARCHAR2(80);
v_continue  NUMBER := 0;
v_cmd       VARCHAR2(200) := 'select dummy from dual';

begin
/* convert input/default parameters to uppercase if not enclosed in doublequotes */
  if iOBJECT_NAME like '"%"'
  then
    v_object_name := iOBJECT_NAME;
  else
    v_object_name := upper(iOBJECT_NAME);
  end if; -- iOBJECT_NAME ''"%"'
  
  if iOWNER like '"%"'
  then
    v_owner := iOWNER;
  else
    v_owner := upper(iOWNER);
  end if; -- iOWNER ''"%"'
  
  if iOBJECT_TYPE like '"%"'
  then
    v_object_type := iOBJECT_TYPE;
  else
    v_object_type := upper(iOBJECT_TYPE);
  end if; -- iOBJECT_TYPE ''"%"'
    
  select count(*)
    into v_continue
    from ALL_OBJECTS
   where OBJECT_NAME = iOBJECT_NAME
     and OWNER       = iOWNER
     and OBJECT_TYPE = iOBJECT_TYPE;

  if v_continue > 0 then
    v_cmd := 'drop ' || v_object_type || ' ' || v_owner || '.' || v_object_name;
    if v_object_type = 'TABLE' then
      v_cmd := v_cmd || ' cascade constraints purge';
    end if; -- v_object_type = 'TABLE'
  end if; -- v_continue > 0

  insert into DIE_LOG values (sysdate, user, v_cmd);
  commit;
  
  if v_continue > 0 then
    execute immediate (v_cmd);
  end if;  -- v_continue > 0

end;
/
SHOW ERRORS;
