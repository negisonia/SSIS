CREATE OR REPLACE FUNCTION test_data_parent() --FF NEW
RETURNS boolean AS $$
DECLARE

success BOOLEAN:=FALSE;

BEGIN

  PERFORM common_create_parent('TEST_PARENT_001',TRUE);
  PERFORM common_create_parent('TEST_PARENT_002',FALSE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;