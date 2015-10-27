CREATE OR REPLACE FUNCTION test_data_azbusinesscenter() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

PERFORM common_azbusinesscenter(1,'Great Lakes Business Center');
PERFORM common_azbusinesscenter(2,'Mid-Atlantic Business Center');
PERFORM common_azbusinesscenter(3,'Northeast Business Center');
PERFORM common_azbusinesscenter(4,'Southeast Business Center');
PERFORM common_azbusinesscenter(5,'Western Business Center');
PERFORM common_azbusinesscenter(6,'Central Business Center');

success=true;
return success;
END
$$ LANGUAGE plpgsql;