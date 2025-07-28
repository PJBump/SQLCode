CREATE OR REPLACE TRIGGER CALENDAR_BIR
before insert ON CALENDAR
for each row
begin
  select trunc(:new.DT) - to_date('18991230','YYYYMMDD')
    into :new.EXCEL_DT
    from dual;

  select (trunc(:new.DT) - to_date('19700101','YYYYMMDD')) * 86400
    into :new.EPOCH_TM
    from dual; 
end;
/
SHOW ERRORS;
