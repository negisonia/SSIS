CREATE OR REPLACE FUNCTION cleartestdata() --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

--CLEAR TEST001 DATA
perform test001cleartestdata();
	

SUCCESS:=true;
return SUCCESS;
END
$$ LANGUAGE plpgsql;