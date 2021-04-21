INSERT INTO crawler.hazard_events 
	(geom, origin, origin_id, event_id, event_type, event_date, alert_level, name, description)

SELECT 
	ST_GeomFromEWKB(ST_AsEWKB(geom)),
	'gdacs', 
	CONCAT(eventtype, eventid),  
	eventid, 	
	CASE
		WHEN eventtype = 'EQ' THEN 'earthquakes'
		WHEN eventtype = 'TC' THEN 'severeStorms'
		WHEN eventtype = 'FL' THEN 'floods'
		WHEN eventtype = 'VO' THEN 'volcanoes'
		WHEN eventtype = 'DR' THEN 'drought'
		ELSE eventtype
	END,
	to_timestamp(todate, 'DD/Mon/YYYY HH24:MI:SS'),	-- to_timestamp(fromdate, 'DD/Mon/YYYY HH24:MI:SS'), /* 28/Oct/2020 00:00:00 */
	alertlevel, 
	name, 
	description

FROM 
	crawler.import_gdacs
	
ON CONFLICT 
	(origin, origin_id) DO NOTHING; 
