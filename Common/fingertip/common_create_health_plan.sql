CREATE OR REPLACE FUNCTION common_create_healthplan(health_plan_type_id INTEGER, is_active BOOLEAN, health_plan_name VARCHAR, web_name VARCHAR,re_write_name VARCHAR, formulary_id INTEGER,provider_id INTEGER, comming_soon BOOLEAN ) --FF_NEW DB
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
            VALUES (health_plan_type_id, CASE when is_active IS NULL THEN TRUE ELSE is_active END , health_plan_name, web_name, re_write_name, 
            NULL, NULL,formulary_id, CASE WHEN comming_soon IS NULL THEN TRUE ELSE comming_soon END, NULL, 
            provider_id, current_timestamp, current_timestamp, NULL, 
            0, NULL, NULL, NULL, 
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

