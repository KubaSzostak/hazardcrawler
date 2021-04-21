CREATE SCHEMA IF NOT EXISTS crawler;

-- DROP TABLE crawler.hazard_events;

CREATE TABLE IF NOT EXISTS crawler.hazard_events
(
    geom geography(Point,4326),
    fid serial primary key,
    event_id text,
    event_type text,
    event_date timestamp,
    alert_level text,
    name text,
    description text,
    origin text,
    origin_id text,
    UNIQUE (origin, origin_id)
);


CREATE INDEX IF NOT EXISTS crawler_hazard_events_wkb_geometry_geom_idx
    ON crawler.hazard_events 
    USING gist (geom);



CREATE OR REPLACE VIEW crawler.earthquake_events AS
    SELECT * FROM crawler.hazard_events
WHERE 
    hazard_events.event_type = 'earthquakes';


CREATE OR REPLACE VIEW crawler.severe_storm_events AS
    SELECT * FROM crawler.hazard_events
WHERE 
    hazard_events.event_type = 'severeStorms';


CREATE OR REPLACE VIEW crawler.flood_events AS
    SELECT * FROM crawler.hazard_events
WHERE 
    hazard_events.event_type = 'floods';


CREATE OR REPLACE VIEW crawler.volcano_events AS
    SELECT * FROM crawler.hazard_events
WHERE 
    hazard_events.event_type = 'volcanoes';


CREATE OR REPLACE VIEW crawler.drought_events AS
    SELECT * FROM crawler.hazard_events
WHERE 
    hazard_events.event_type = 'drought';