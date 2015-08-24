<<<<<<< HEAD
CREATE OR REPLACE FUNCTION  test_data_client()--ADMIN DB
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
BEGIN

PERFORM common_create_client('client_1');
PERFORM common_create_client('client_2');
PERFORM common_create_client('client_3');
PERFORM common_create_client('client_4');

success:= TRUE;
RETURN success;

END
$$ LANGUAGE plpgsql;


