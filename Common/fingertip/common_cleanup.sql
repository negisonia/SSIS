CREATE OR REPLACE FUNCTION clear_test_data()--ADMIN
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

	--CLEAR TABLES
	TRUNCATE TABLE healthplantype CASCADE;
	TRUNCATE TABLE healthplan CASCADE;
	
	--CLEAR SEQUENCES
	ALTER SEQUENCE healthplan_id_seq RESTART;
	ALTER SEQUENCE healthplantype_id_seq RESTART;
	
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
