CREATE OR REPLACE FUNCTION test_data_metro_stat_area() --FF NEW
RETURNS boolean AS $$
DECLARE

success BOOLEAN:=FALSE;

BEGIN

  PERFORM common_create_metro_stat_area('Abilene, TX','MSA_001');



  PERFORM common_create_metro_stat_area('MSA_001','MSA_001');
  PERFORM common_create_metro_stat_area('MSA_002','MSA_002');
  PERFORM common_create_metro_stat_area('MSA_003','MSA_003');
  PERFORM common_create_metro_stat_area('MSA_004','MSA_004');

success=true;
return success;
END
$$ LANGUAGE plpgsql;