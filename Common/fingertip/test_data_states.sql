CREATE OR REPLACE FUNCTION test_data_states() --FF NEW
RETURNS boolean AS $$
DECLARE

country_001_id INTEGER;

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE COUNTRIES
    SELECT c.id into country_001_id FROM country c WHERE c.name='COUNTRY_001';

    PERFORM common_create_state('STATE_001','S_001',country_001_id,TRUE);
    PERFORM common_create_state('STATE_002','S_002',country_001_id,TRUE);
    PERFORM common_create_state('STATE_003','S_003',country_001_id,TRUE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;