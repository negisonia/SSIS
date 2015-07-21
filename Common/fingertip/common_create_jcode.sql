CREATE OR REPLACE FUNCTION common_create_jcode(jcode_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
jcode_id INTEGER DEFAULT NULL;
BEGIN

SELECT j.id INTO jcode_id FROM jcodes j WHERE j.name=jcode_name LIMIT 1;

--VALIDATE IF JCODE ALREADY EXISTS
IF jcode_id IS NULL THEN
	--INSERT NEW JCODE
	INSERT INTO jcodes(name, description, created_at, updated_at)
        VALUES (jcode_name, NULL, current_timestamp, current_timestamp) RETURNING id INTO jcode_id;
	RETURN jcode_id;
ELSE
	--RETURN EXISTING JCODE ID
	RETURN jcode_id;
END IF;

END
$$ LANGUAGE plpgsql;