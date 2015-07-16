CREATE OR REPLACE FUNCTION common_create_country(country_name VARCHAR, country_abbreviation VARCHAR, is_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
country_id INTEGER DEFAULT NULL;
BEGIN
	
SELECT c.id INTO country_id FROM country c WHERE c.name=country_name or c.abbreviation=country_abbreviation  LIMIT 1;

--VALIDATE IF THE FORMULARY ENTRY ALREADY EXISTS
IF country_id IS NULL THEN
	--INSERT FORMULARY ENTRY RECORD
	INSERT INTO country(
            isactive, name, abbreviation)
    VALUES ( CASE when is_active IS NULL THEN TRUE ELSE is_active END, country_name, country_abbreviation) RETURNING id INTO country_id;

	RETURN country_id;
ELSE
	RETURN country_id;
END IF;

END
$$ LANGUAGE plpgsql;

