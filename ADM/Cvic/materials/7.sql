DROP TABLE HODNOCENI_EXT;

CREATE TABLE HODNOCENI_EXT
(
    osobni_cislo VARCHAR2(16),
    jmeno VARCHAR2(20),
    prijmeni VARCHAR2(25),
    username VARCHAR2(25),
    ip VARCHAR2(25),
    body_hesla NUMBER(4),
    body_audit NUMBER(4),
    body_addm NUMBER(4),
    body_zamky NUMBER(4),
    body_zaloha NUMBER(4)
)
ORGANIZATION EXTERNAL
(
    TYPE ORACLE_LOADER
    DEFAULT DIRECTORY DATA_PUMP_DIR
    ACCESS PARAMETERS
    (
        RECORDS DELIMITED BY NEWLINE
        BADFILE DATA_PUMP_DIR:'empxt%a_%p.bad'
        LOGFILE DATA_PUMP_DIR:'empxt%a_%p.log'
        SKIP 2
        FIELDS TERMINATED BY ','
        MISSING FIELD VALUES ARE NULL
        (osobni_cislo, jmeno, prijmeni, username, ip, body_hesla, body_audit, body_addm, body_zamky, body_zaloha)
    )
    LOCATION ('seznam_studentu.csv')
)
PARALLEL REJECT LIMIT UNLIMITED;

SELECT 
    prijmeni,
    jmeno, 
    (COALESCE(body_hesla, 0) + COALESCE(body_audit, 0) + COALESCE(body_addm, 0) + COALESCE(body_zamky, 0) + COALESCE(body_zaloha, 0)) AS celkove_body
FROM 
    HODNOCENI_EXT
ORDER BY 
    celkove_body DESC;
