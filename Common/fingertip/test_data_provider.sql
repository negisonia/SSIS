CREATE OR REPLACE FUNCTION test_data_provider() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

PERFORM common_create_provider(TRUE,'provider_1',NULL);
PERFORM common_create_provider(TRUE,'provider_2',NULL);
PERFORM common_create_provider(TRUE,'provider_3',NULL);
PERFORM common_create_provider(TRUE,'provider_4',NULL);
PERFORM common_create_provider(TRUE,'provider_5',NULL);
PERFORM common_create_provider(TRUE,'provider_6',NULL);
PERFORM common_create_provider(TRUE,'provider_7',NULL);
PERFORM common_create_provider(TRUE,'provider_8',NULL);
PERFORM common_create_provider(FALSE,'provider_9',NULL);
PERFORM common_create_provider(FALSE,'provider_10',NULL);

success=true;
return success;
END
$$ LANGUAGE plpgsql;