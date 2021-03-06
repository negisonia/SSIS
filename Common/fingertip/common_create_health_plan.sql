﻿CREATE OR REPLACE FUNCTION common_create_healthplan(health_plan_type_id INTEGER, is_active BOOLEAN, health_plan_name VARCHAR, formulary_id INTEGER,provider_id INTEGER, formulary_url VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
health_plan_id INTEGER DEFAULT NULL;
BEGIN

SELECT h.id INTO health_plan_id FROM healthplan h WHERE h.name=health_plan_name and h.healthplantypefid=health_plan_type_id  LIMIT 1;

--VALIDATE IF THE PROVIDER ALREADY EXISTS
IF health_plan_id IS NULL THEN
	
	INSERT INTO healthplan(
            healthplantypefid, isactive, name, webname, rewritename, 
            bookname, formularyurl, formularyfid, comingsoon, legacyfid, 
            providerfid, createtimestamp, modifytimestamp, pbmhealthplanfid, 
            displayid, qualifierurl, comingformularyfid, comingformularydate, 
            pbmlastupdated, comingformularynote, formularycopy, assignment_comment, 
            formularyname, tiers, tierstructure, ptdates, ptmembers, ptcomments, 
            corporatestructure, county_url, county_comment, existing_formularyfid, 
            existing_comingformularyfid)
            VALUES (health_plan_type_id, CASE when is_active IS NULL THEN TRUE ELSE is_active END , health_plan_name, health_plan_name, health_plan_name, 
            NULL, formulary_url,formulary_id, TRUE, NULL,
            provider_id, current_timestamp, current_timestamp, NULL, 
            NEXTVAL('health_plan_display_id_seq'), NULL, NULL, NULL, 
            NULL, NULL, 0, NULL, 
            NULL, NULL, NULL, NULL, NULL, NULL, 
            NULL, NULL, NULL, NULL, 
            NULL) RETURNING id INTO health_plan_id;

	RETURN health_plan_id;
ELSE
	RETURN health_plan_id;
END IF;
END
$$ LANGUAGE plpgsql;

