CREATE OR REPLACE FUNCTION  test_data_jcodes() --FF NEW DB
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
BEGIN

--CREATE JCODES
PERFORM common_create_jcode('J9678');
PERFORM common_create_jcode('J675');

success=true;
return success;
END
$$ LANGUAGE plpgsql;