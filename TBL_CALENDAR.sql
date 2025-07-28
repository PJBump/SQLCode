CREATE TABLE CALENDAR
(
  DT        DATE                                NOT NULL,
  EXCEL_DT  NUMBER                              DEFAULT 0,
  EPOCH_TM  NUMBER                              DEFAULT 0
)
TABLESPACE USERDATA
/
SHOW ERRORS;
