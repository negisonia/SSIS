CREATE OR REPLACE FUNCTION clear_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

--CLEAR DATA
perform test_001_clear_test_data();
perform test_002_clear_test_data();	

SUCCESS:=true;
return SUCCESS;
END
$$ LANGUAGE plpgsql;