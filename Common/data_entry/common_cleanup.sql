CREATE OR REPLACE FUNCTION clear_test_data()--DATA ENTRY
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

	--CLEAR TABLES
  TRUNCATE TABLE indications CASCADE;
  TRUNCATE TABLE drug_indications CASCADE;
  TRUNCATE TABLE drug_class_indications CASCADE;


	--CLEAR SEQUENCES
  ALTER SEQUENCE indications_id_seq RESTART;
  ALTER SEQUENCE indications_id_seq RESTART;


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
