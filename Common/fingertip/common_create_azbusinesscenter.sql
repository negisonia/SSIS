CREATE OR REPLACE FUNCTION common_azbusinesscenter(new_id INTEGER, new_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
azbusiness_id INTEGER;
BEGIN
	--INSERT  RECORD
	INSERT INTO azbusinesscenter(entityid, businesscenter)
    VALUES (new_id, new_name) RETURNING entityid INTO azbusiness_id;

	RETURN azbusiness_id;
END
$$ LANGUAGE plpgsql;

