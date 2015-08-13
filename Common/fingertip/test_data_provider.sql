CREATE OR REPLACE FUNCTION test_data_provider() --FF NEW
RETURNS boolean AS $$
DECLARE

parent_001_id INTEGER;

success BOOLEAN:=FALSE;
BEGIN

--RETRIEVE PARENTS
    SELECT p.id into parent_001_id FROM parent p WHERE p.name='PARENT_001';

PERFORM common_create_provider(TRUE,'provider_1',NULL);
PERFORM common_create_provider(TRUE,'provider_2',NULL);
PERFORM common_create_provider(TRUE,'provider_3',NULL);
PERFORM common_create_provider(TRUE,'provider_4',NULL);
PERFORM common_create_provider(TRUE,'provider_5',NULL);
PERFORM common_create_provider(TRUE,'provider_6',NULL);
PERFORM common_create_provider(TRUE,'provider_7',NULL);
PERFORM common_create_provider(TRUE,'provider_8',NULL);
PERFORM common_create_provider(TRUE,'provider_9',NULL);
PERFORM common_create_provider(TRUE,'provider_10',NULL);
PERFORM common_create_provider(TRUE, 'TEST_PROVIDER_001', parent_001_id);
PERFORM common_create_provider(TRUE, 'TEST_PROVIDER_002', parent_001_id);
PERFORM common_create_provider(TRUE, 'TEST_PROVIDER_003', parent_001_id);
PERFORM common_create_provider(TRUE, 'TEST_PROVIDER_001', parent_001_id);
PERFORM common_create_provider(TRUE, 'TEST_PROVIDER_002', parent_001_id);
PERFORM common_create_provider(TRUE, 'TEST_PROVIDER_003', parent_001_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;