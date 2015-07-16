CREATE OR REPLACE FUNCTION common_create_state(state_name  VARCHAR, state_abbreviation VARCHAR, country_id INTEGER, is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
state_id INTEGER DEFAULT NULL;
BEGIN
	
SELECT s.id INTO state_id FROM state s WHERE (s.countryfid=country_id and s.name=state_name) or (s.countryfid=country_id and s.abbreviation=state_abbreviation)  LIMIT 1;

--VALIDATE IF THE FORMULARY ENTRY ALREADY EXISTS
IF state_id IS NULL THEN
	--INSERT FORMULARY ENTRY RECORD
	INSERT INTO state(
            isactive, name, abbreviation, countryfid, legacycolumnname, 
            azbusinesscenterfid, population, formulary_state, fipsid, medicare_lis_lives)
        VALUES (CASE WHEN is_active IS NULL THEN TRUE ELSE is_active END , state_name, state_abbreviation, country_id, NULL, 
            NULL, NULL, NULL, NULL, NULL) RETURNING id INTO state_id;

	RETURN state_id;
ELSE
	RETURN state_id;
END IF;

END
$$ LANGUAGE plpgsql;

