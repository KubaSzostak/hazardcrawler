import os
import ogr2ogr
import pgconfig
import psycopg2

from datetime import datetime
from osgeo import ogr
# from osgeo import gdal
# from osgeo import osr
# from osgeo import gdalconst


# Report OGR errors by raising exceptions
ogr.UseExceptions()


def log_info(msg):
    print(str(datetime.now()) + " " + msg)


def execute_sql(sql):
    with psycopg2.connect(pgconfig.connstr) as conn:
        with conn.cursor() as cur:
            cur.execute(sql)


def read_file(fname):
    fpath = os.path.join(os.path.dirname(__file__), fname)
    with open(fpath, 'r') as f:
        return f.read()


# Tested with "PostgreSQL 10.16 + PostGIS 2.4
def import_geojson(tbname, src):
    log_info("Importing geojson data: ")
    log_info("  " + src)
    
    log_info("  Loading geojson data into the " + tbname + " table")
    ogr2ogr.main(["","-f", "PostgreSQL", "PG:" + pgconfig.connstr, src, "-nln", pgconfig.schema + "." + tbname, "-lco", "GEOMETRY_NAME=geom", "-overwrite"]) # "-nlt", "PROMOTE_TO_MULTI"
    
    log_info("  Updating hazard_events table")
    sql = read_file(tbname + ".sql")
    execute_sql(sql)
    
    log_info("Import succeeded.")
    

# ------------------------------------------------------------------------------

# https://www.gdacs.org/feed_reference.aspx
# https://www.gdacs.org/xml/rss_24h.xml
# https://www.gdacs.org/xml/rss_7d.xml
# https://www.gdacs.org/xml/archive.geojson
import_geojson("import_gdacs", "https://www.gdacs.org/xml/archive.geojson")


# https://eonet.sci.gsfc.nasa.gov/docs/v3
import_geojson("import_eonet", "https://eonet.sci.gsfc.nasa.gov/api/v3/events/geojson")


# https://earthquake.usgs.gov/fdsnws/event/1/
import_geojson("import_usgg", "https://earthquake.usgs.gov/fdsnws/event/1/query?format=geojson")


# https://www.seismicportal.eu/fdsn-wsevent.html
import_geojson("import_epos", "https://www.seismicportal.eu/fdsnws/event/1/query?limit=1000&format=json")

