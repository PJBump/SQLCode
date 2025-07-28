CREATE OR REPLACE function DATA_DFLT
( iOWNER  IN  VARCHAR2
, iTABLE  IN  VARCHAR2
, iCOLUMN IN  VARCHAR2
) return VARCHAR2
is

l_data  long;
begin
  select DATA_DEFAULT
    into l_data
    from ALL_TAB_COLUMNS
   where OWNER = iOWNER
     and TABLE_NAME = iTABLE
     and COLUMN_NAME = iCOLUMN;
  return trim(substr(l_data, 1, 4000));
end;
/
SHOW ERRORS;
