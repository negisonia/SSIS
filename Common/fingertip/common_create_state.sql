CREATE OR REPLACE FUNCTION common_create_state(new_id INTEGER, new_isactive BOOLEAN, new_name VARCHAR, new_abbreviation VARCHAR, new_countryfid INTEGER, new_legacycolumnname VARCHAR, new_businesscenterfid INTEGER, new_population INTEGER, new_formulary_state BOOLEAN, new_fipsid INTEGER,new_medicare_lis_lives INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
state_id INTEGER DEFAULT NULL;
BEGIN
	
SELECT s.id INTO state_id FROM state s WHERE (s.countryfid=new_countryfid and s.name=new_name) or (s.countryfid=new_countryfid and s.abbreviation=new_abbreviation)  LIMIT 1;

--VALIDATE IF THE FORMULARY ENTRY ALREADY EXISTS
IF state_id IS NULL THEN
	--INSERT FORMULARY ENTRY RECORD
INSERT INTO state(
            id, isactive, name, abbreviation, countryfid, legacycolumnname,
            azbusinesscenterfid, population, formulary_state, fipsid, medicare_lis_lives)
    VALUES (new_id, new_isactive, new_name, new_abbreviation, new_countryfid, new_legacycolumnname,
            new_businesscenterfid, new_population, new_formulary_state, new_fipsid, new_medicare_lis_lives) RETURNING id INTO state_id;
	RETURN state_id;
ELSE
	RETURN state_id;
END IF;

END
$$ LANGUAGE plpgsql;

