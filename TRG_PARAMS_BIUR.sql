CREATE OR REPLACE TRIGGER PARAMS_BIUR 
before insert or update on PARAMS
for each row
begin
  if inserting then
    select nvl(max(PARAM_ID),0) + 1
      into :new.PARAM_ID
      from PARAMS;
  elsif updating then
    select SYSDATE, USER
      into :new.LAST_UPDT_DTTM, :new.LAST_UPDT_USER
      from DUAL;
  end if;

  if :new.STR_VAL is not null then
     :new.NBR_VAL := null;
     :new.DT_VAL := null;
  elsif :new.NBR_VAL is not null then
        :new.DT_VAL := null;
  end if;
  
end;
/
SHOW ERRORS;
