-- Rado - compressed backupset
-- Filip - backupset
-- ??? - copy

-- provedení zálohy
backup as BACKUPSET database;
backup as COMPRESSED BACKUPSET database;
backup as COPY database;

---- smazat DB
-- rm -r /opt/oracle/oradata/ORCL/datafile

-- vypnutí když je DB rozbitá
shutdown abort;

-- obnova databáze

-- zapnutí přes RMANa
startup nomount;
-- obnova controlfile
restore controlfile from autobackup;
-- načtení řídícího souboru
alter database mount;
-- obnova souborů z řídicího souboru
restore database;
-- obnova DB
recover database;
-- znovuspuštění databáze a vyresetování redologů
alter database open resetlogs;



--- POKUD POUŽÍVÁME COPY

-- přepnutí na zálohu
switch database to copy;

-- přesun datafile
alter database move datafile 1;

-- seznam datafiles
select file#,name from v$datafile;
