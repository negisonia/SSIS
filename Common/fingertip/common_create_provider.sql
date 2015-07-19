CREATE OR REPLACE FUNCTION common_create_provider(is_active BOOLEAN, provider_name VARCHAR, parents_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
provider_id INTEGER DEFAULT NULL;
BEGIN

SELECT p.id INTO provider_id FROM provider p WHERE p.name=provider_name LIMIT 1;

--VALIDATE IF THE PROVIDER ALREADY EXISTS
IF provider_id IS NULL THEN
	
	--INSERT PROVIDER RECORD
	INSERT INTO provider(isactive, name, webname, suppressrollup, altwebname, parentsfid, 
            corporatestructure, ptdates, ptmembers, ptcomments, top_provider, 
            is_medical_benefits)
       VALUES (CASE when is_active IS NULL THEN TRUE ELSE is_active END, provider_name, provider_name, 0, provider_name, parents_id, 
            NULL, NULL, NULL, NULL, FALSE, 
            FALSE) RETURNING id INTO provider_id;

	RETURN provider_id;
ELSE
	RETURN provider_id;
END IF;
END
$$ LANGUAGE plpgsql;

