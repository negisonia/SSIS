CREATE OR REPLACE FUNCTION common_create_country(new_id INTEGER, new_is_active BOOLEAN,  new_name VARCHAR, new_abbreviation VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
country_id INTEGER DEFAULT NULL;
BEGIN
	
SELECT c.id INTO country_id FROM country c WHERE c.name=new_name or c.abbreviation=new_abbreviation  LIMIT 1;

--VALIDATE IF THE FORMULARY ENTRY ALREADY EXISTS
IF country_id IS NULL THEN
	--INSERT FORMULARY ENTRY RECORD
	INSERT INTO country(id, isactive, name, abbreviation)
    VALUES (new_id,new_is_active,new_name,new_abbreviation) RETURNING id INTO country_id;

	RETURN country_id;
ELSE
	RETURN country_id;
END IF;

END
$$ LANGUAGE plpgsql;

