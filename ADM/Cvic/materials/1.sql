-- Zobrazit log (Audit trail)
select action_name,SQL_TEXT,UNIFIED_AUDIT_POLICIES ,EVENT_TIMESTAMP from unified_AUDIT_trail
where EVENT_TIMESTAMP > sysdate -1;

-- Zobrazit log (Audit trail) username SYSTEM
select action_name,SQL_TEXT,UNIFIED_AUDIT_POLICIES ,EVENT_TIMESTAMP from unified_AUDIT_trail
where EVENT_TIMESTAMP > sysdate -1 and dbusername = 'SYSTEM';

-- Je zaplé unified auditing?
SELECT value FROM v$option WHERE parameter = 'Unified Auditing';

-- Zapnuté polotiky
SELECT policy_name, enabled_option, entity_name, success, failure
FROM audit_unified_enabled_policies;

-- Přehled všech audit policies
select distinct POLICY_NAME from AUDIT_UNIFIED_POLICIES;

-- Vytvoření audit policy
create audit policy test_audit_policy
  actions delete, insert, update, select
  when 'sys_context(''userenv'',''session_user'') =''SYSTEM'''
  evaluate per session;
  
-- Zapnutí politiky
audit policy test_audit_policy;

-- Vypnutí politiky
noaudit policy test_audit_policy;

-------------------
-- Hledání v auditu
-------------------

select to_char(sql_text) text from unified_audit_trail
where  dbusername = 'SYSTEM'
and object_schema='SYSTEM'
order by event_timestamp desc;

select event_timestamp,
       dbusername,
       action_name,
       object_schema,
       object_name
from   unified_audit_trail
where  dbusername = 'SYSTEM'
and object_schema='SYSTEM'
order by event_timestamp desc;

-- Sloupce v auditu
desc unified_audit_trail;






--- PLAYGROUND

CREATE AUDIT POLICY test_audit_policy2
  ACTIONS DROP TABLE, DROP USER, DROP INDEX;

audit policy test_audit_policy2;

noaudit policy test_audit_policy2;
drop audit policy test_audit_policy2;


select to_char(sql_text) text, dbusername, event_timestamp from unified_audit_trail
order by event_timestamp desc;



select to_char(sql_text) text, dbusername, event_timestamp from unified_audit_trail
where object_name = 'DBA_USERS'
order by event_timestamp desc;




