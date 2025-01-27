---- Smazat soubory z ORCL
-- nechat jen: archivelog, controlfile, onlinelog

-- Poté aktualizujeme backupy z pohledu DB
crosscheck backup;
crosscheck archivelog all;
delete expired backup;
delete expired archivelog all;

-- Nastavíme compressed backupset
SHOW ALL;
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET;

-- Zazálohujeme
backup database;

---- Budeme mazat soubory DB
-- Systémovou tablespace (SYSTEM) (/opt/oracle/oradata/ORCL/datafile/o1_mf_system_xxx)
-- Uživatelskou tablespace (USERS)  (/opt/oracle/oradata/ORCL/datafile/o1_mf_users_xxx)
-- Jednu z kopií controlfile  (/opt/oracle/oradata/ORCL/controlfile/o1_mf_xxx.ctl)
-- Všechny controlfile -  (/opt/oracle/oradata/ORCL/controlfile/o1_mf_xxx.ctl a /opt/oracle/fast_recovery_area/ORCL/controlfile//o1_mf_xxx.ctl)
-- Jeden z online redologů -  (/opt/oracle/oradata/ORCL/onlinelog/o1_mf_1_xxx)
-- Jednu skupinu redologů -  (/opt/oracle/oradata/ORCL/onlinelog/o1_mf_1_xxx a /opt/oracle/fast_recovery_area/ORCL/onlinelog//o1_mf_1_xxx)
-- Všechny redology  (/opt/oracle/oradata/ORCL/onlinelog/* a /opt/oracle/fast_recovery_area/ORCL/onlinelog//*)
-- Kombinace předchozího např. jednu kopii controlfile a jeden redolog

-- Po každém smazání opravit přes recovery advisora
list failure;
advise failure;
repair failure preview;
repair failure;

-- Špatné redology
select group#,member from v$logfile where status='INVALID';

-- Oprava redologů (onlinelog)
ALTER DATABASE DROP LOGFILE GROUP xxx:
ALTER DATABASE ADD LOGFILE GROUP xxx:

-- Přepnutí redologu
ALTER SYSTEM SWITCH LOGFILE;

