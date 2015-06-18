CREATE OR REPLACE FUNCTION cleartestdata() --ADMIN DB
  RETURNS void AS $$
BEGIN

--CLEAR TEST001 DATA
select test001cleartestdata();
	
END
$$ LANGUAGE plpgsql;