CREATE OR REPLACE FUNCTION clear_test_data()--ADMIN
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

	--CLEAR TABLES
	TRUNCATE TABLE healthplantype CASCADE;
	TRUNCATE TABLE healthplan CASCADE;
	TRUNCATE TABLE jcodes CASCADE;
	TRUNCATE TABLE drug CASCADE;
	TRUNCATE TABLE drugclass CASCADE;
	TRUNCATE TABLE drugs_jcodes CASCADE;
	TRUNCATE TABLE drugdrugclass CASCADE;
	
	--CLEAR SEQUENCES
	ALTER SEQUENCE healthplan_id_seq RESTART;
	ALTER SEQUENCE healthplantype_id_seq RESTART;
	ALTER SEQUENCE jcodes_id_seq RESTART;
	ALTER SEQUENCE	drug_id_seq RESTART;
	ALTER SEQUENCE drugclass_id_seq RESTART;
	ALTER SEQUENCE drugdrugclass_id_seq RESTART;
	ALTER SEQUENCE drugs_jcodes_id_seq RESTART;
	
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
