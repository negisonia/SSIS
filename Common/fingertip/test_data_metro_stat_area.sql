CREATE OR REPLACE FUNCTION test_data_metro_stat_area() --FF NEW
RETURNS boolean AS $$
DECLARE

success BOOLEAN:=FALSE;

BEGIN

  PERFORM common_create_metro_stat_area('MSA_001','MSA_001');

success=true;
return success;
END
$$ LANGUAGE plpgsql;