CREATE OR REPLACE FUNCTION clear_test_data() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

--CLEAR TEST001 DATA
perform test_001_clear_test_data();
	

SUCCESS:=true;
return SUCCESS;
END
$$ LANGUAGE plpgsql;