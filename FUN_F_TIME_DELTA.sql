CREATE OR REPLACE function f_time_delta
( iseconds    IN  number
) return varchar2
is

v_num            NUMBER := 0;
v_sec            NUMBER := 0;
v_min            NUMBER := 0;
v_hrs            NUMBER := 0;
v_dys            NUMBER := 0;
v_yrs            NUMBER := 0;
v_str            VARCHAR2(40);

begin
  v_num := iseconds;

  case when v_num >= 31557600 then
    v_yrs := floor(v_num / 31557600);
    v_num := v_num - (v_yrs * 31557600);
    v_dys := floor(v_num / 86400);
    v_num := v_num - (v_dys * 86400);
    v_hrs := floor(v_num / 3600);
    v_num := v_num - (v_hrs * 3600);
    v_min := floor(v_num / 60);
    v_num := v_num - (v_min * 60);
    v_sec := v_num;
    v_str := substr(to_char(v_yrs, '999'), 2) || ' y ' ||
             substr(to_char(v_dys, '099'), 2) || ' d ' ||
             substr(to_char(v_hrs,  '09'), 2) || ' h ' ||
             substr(to_char(v_min,  '09'), 2) || ' m ' ||
             substr(to_char(v_sec,  '09'), 2) || ' s';
      when v_num >= 86400 then
    v_dys := floor(v_num / 86400);
    v_num := v_num - (v_dys * 86400);
    v_hrs := floor(v_num / 3600);
    v_num := v_num - (v_hrs * 3600);
    v_min := floor(v_num / 60);
    v_num := v_num - (v_min * 60);
    v_sec := v_num;
    v_str := substr(to_char(v_dys, '999'), 2) || ' d ' ||
             substr(to_char(v_hrs,  '09'), 2) || ' h ' ||
             substr(to_char(v_min,  '09'), 2) || ' m ' ||
             substr(to_char(v_sec,  '09'), 2) || ' s';
      when v_num >= 3600 then
    v_hrs := floor(v_num / 3600);
    v_num := v_num - (v_hrs * 3600);
    v_min := floor(v_num / 60);
    v_num := v_num - (v_min * 60);
    v_sec := v_num;
    v_str := substr(to_char(v_hrs,  '99'), 2) || ' h ' ||
             substr(to_char(v_min,  '09'), 2) || ' m ' ||
             substr(to_char(v_sec,  '09'), 2) || ' s';
      when v_num >= 60 then
    v_min := floor(v_num / 60);
    v_num := v_num - (v_min * 60);
    v_sec := v_num;
    v_str := substr(to_char(v_min,  '99'), 2) || ' m ' ||
             substr(to_char(v_sec,  '09'), 2) || ' s';
      else
    v_sec := v_num;
    v_str := substr(to_char(v_sec,  '99'), 2) || ' s';
    end case;
                
  return v_str;
end;
/
SHOW ERRORS;
