---- ARCHIVE LOGY

mkdir -p /home/oracle/multiplex/arch

-- Nastavit multiplexování archivních logů
ALTER SYSTEM SET LOG_ARCHIVE_DEST_1='LOCATION=USE_DB_RECOVERY_FILE_DEST' SCOPE=BOTH;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='LOCATION=/home/oracle/multiplex/arch' SCOPE=BOTH;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_STATE_2=ENABLE;

-- Ověřit nastavení
SELECT destination, status FROM v$archive_dest WHERE status='VALID';

---- REDO LOGY

mkdir -p /home/oracle/multiplex/redo

-- Přidat členy do skupin
ALTER DATABASE ADD LOGFILE MEMBER '/home/oracle/multiplex/redo/redo01.log' TO GROUP 1;
ALTER DATABASE ADD LOGFILE MEMBER '/home/oracle/multiplex/redo/redo02.log' TO GROUP 2;
ALTER DATABASE ADD LOGFILE MEMBER '/home/oracle/multiplex/redo/redo03.log' TO GROUP 3;

---- CONTROL FILE

-- najít control files
ls /opt/oracle/oradata/ADM_DB/controlfile/
ls /opt/oracle/fast_recovery_area/ADM_DB/controlfile/

-- přidat do nastavení DB
alter system set control_files='/opt/oracle/oradata/ADM_DB/controlfile/<první>.ctl', '/opt/oracle/fast_recovery_area/ORCL/controlfile/<druhý>.ctl', '/home/oracle/control.bak' scope=spfile;

MY:
alter system set control_files='/opt/oracle/oradata/ADM_DB/controlfile/o1_mf_mhbsw2hp_.ctl', '/opt/oracle/fast_recovery_area/ADM_DB/controlfile/o1_mf_mhbsw2kb_.ctl', '/home/oracle/control.bak' scope=spfile;


-- vypnout db
shut immediate;

-- zkopírovat control file
cp /opt/oracle/oradata/ADM_DB/controlfile/*.ctl /home/oracle/control.bak

-- zapnout db
startup;
