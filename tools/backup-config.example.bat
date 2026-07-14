@echo off
rem Copia este archivo como tools\backup-config.local.bat y rellena DATABASE_URL.
rem No subas backup-config.local.bat a Git.
rem
rem Preferido para pg_dump/psql si tu red soporta IPv6:
rem postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
rem
rem Alternativa si tu red es solo IPv4: Session Pooler, no Transaction Pooler.
rem postgres://postgres.[PROJECT-REF]:[PASSWORD]@aws-[REGION].pooler.supabase.com:5432/postgres

rem Los scripts fuerzan SSL con PGSSLMODE=require; no hace falta anadir sslmode a la URL.
set "DATABASE_URL=postgresql://postgres:[PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres"
