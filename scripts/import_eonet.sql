INSERT INTO crawler.hazard_events 
	(geom, origin, origin_id, event_id, event_type, event_date, alert_level, name, description)

SELECT 
	ST_GeomFromEWKB(ST_AsEWKB(geom)),
	'eonet', 
	id,  
	id, 	
	split_part(split_part(split_part(categories, ']', 1), '", "', 1), '"id": "', 2), -- [ { "id": "severeStorms", "title": "Severe Storms" } ]
	date,
	NULL, 
	title, 
	description

FROM 
	crawler.import_eonet
	
WHERE 
	ST_GeometryType(geom)='ST_Point'
	
ON CONFLICT 
	(origin, origin_id) DO NOTHING; 