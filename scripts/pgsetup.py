import os
import psycopg2

events_table = "hazard_events"
events_schema = "crawler"

print("Enter PostgreSQL/PostGIS database connection parameters")
connstr  =  "dbname="   + (input("  DB name:  ") or "mr")
connstr += " user="     + (input("  User:     ") or "kuba")
connstr += " password=" + (input("  Password: ") or "qwer")
connstr += " host="     + (input("  Host:     ") or "127.0.0.1")


pgsetup_sql = ""
pgsetup_path = os.path.join(os.path.dirname(__file__), 'pgsetup.sql')
with open(pgsetup_path, 'r') as pgsetup:
    pgsetup_sql = pgsetup.read()


print("\nConnecting to database...")
with psycopg2.connect(connstr) as conn:
    with conn.cursor() as cur:
        cur.execute("SELECT version(), postgis_version();")
        sqlver, gisver = cur.fetchone()
        print("  " + sqlver)
        print("  PostGIS    " + gisver)
        cur.execute(pgsetup_sql)
        print("  Table " + events_schema + "." + events_table + " created.")


pgconfig_path = os.path.join(os.path.dirname(__file__), 'pgconfig.py')
with open(pgconfig_path, 'w') as pgconfig:
    pgconfig.write('connstr = "' + connstr + '"\n')
    pgconfig.write('schema = "' + events_schema + '"\n')
    pgconfig.write('hazard_events_table = "' + events_table + '"\n')


print("\nConfiguration saved.")

