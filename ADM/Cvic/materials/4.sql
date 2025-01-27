-- Adam - image
-- Filip - compressed
-- Luky - necompressed

--  1.  35, 299 960
--  2.  35, 299 976
--  3.  35, 299 968
--  4.  35, 299 968
--  5.  35, 299 968
--  6.  35, 299 928
--  7.  35, 299 928
--  8.  35, 299 928
--  9.  35, 299 928
-- 10.  35, 299 944
---- 35, 299 950 -> 293 MB

-- nastavení archivelog režimu
shut immediate;
startup mount;
alter database archivelog;
alter database open;

-- kontrola
select log_mode from v$database;

-- nastavení limitu
ALTER SYSTEM SET db_recovery_file_dest_size = 500G;

--- PŘÍKAZY RMAN ----
-- příkaz: rman target /

-- nastavení retention policy na 10 dní
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 10 DAYS;

-- nastavení typu
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO BACKUPSET;
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO COMPRESSED BACKUPSET;
CONFIGURE DEVICE TYPE DISK PARALLELISM 1 BACKUP TYPE TO COPY;

-- provedení zálohy
backup database;

---- změřit velikost
-- du --max-depth=1 /opt/oracle/fast_recovery_area/ORCL/

---- smazat zálohy
-- PONECHAT pouze: archivelog controlfile onlinelog
-- rm -r /opt/oracle/fast_recovery_area/ORCL/{autobackup,backupset,datafile}


-- TOTO AŽ NA KONCI CVIČENÍ (taky RMAN)

-- synchronizace
crosscheck backup;

-- smazání expirovaných
delete expired backup;



---- ZÁVĚR
-- BSET   26s   1.3 GB
-- CBSET  35s   0.3 GB
-- COPY   61s   2.3 GB
