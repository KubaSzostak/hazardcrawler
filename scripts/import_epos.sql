INSERT INTO crawler.hazard_events 
	(geom, origin, origin_id, event_id, event_type, event_date, alert_level, name, description)

SELECT 
	ST_GeomFromEWKB(ST_AsEWKB(geom)),
	'epos', 
	id,  
	source_id, 	
	'earthquakes',
	time,
	CASE
	    -- http://www.geo.mtu.edu/UPSeis/magnitude.html 
		WHEN mag > 7 THEN 'Red' 	-- Great and Major
		WHEN mag > 6 THEN 'Orange' 	-- Strong
		ELSE 'Green'				-- Moderate, Light, Minor
	END,
	flynn_region, 
	NULL

FROM 
	crawler.import_epos
	
WHERE
	mag >= 5.0 -- Moderate, Strong, Great and Major: http://www.geo.mtu.edu/UPSeis/magnitude.html 
	
ON CONFLICT 
	(origin, origin_id) DO NOTHING; 