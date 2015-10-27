CREATE OR REPLACE FUNCTION test_data_countries() --FF NEW
RETURNS boolean AS $$
DECLARE

success BOOLEAN:=FALSE;

BEGIN

  PERFORM common_create_country('United States','US',TRUE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;