CREATE OR REPLACE FUNCTION test_data_client() --FF NEW
RETURNS boolean AS $$
DECLARE

success BOOLEAN:=FALSE;
BEGIN

--CREATE REASON CODES
PERFORM create_client('Client_1');
PERFORM create_client('Client_2');

success=true;
return success;
END
$$ LANGUAGE plpgsql;