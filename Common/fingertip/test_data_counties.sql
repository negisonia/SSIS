CREATE OR REPLACE FUNCTION test_data_counties() --FF NEW
RETURNS boolean AS $$
DECLARE

state_002_id INTEGER;
state_003_id INTEGER;
state_004_id INTEGER;
state_005_id INTEGER;

metro_stat_area_001_id INTEGER;

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE STATES
  SELECT common_get_table_id_by_name('State','STATE_002') into state_002_id;
  SELECT common_get_table_id_by_name('State','STATE_003') into state_003_id;
  SELECT common_get_table_id_by_name('State','Massachusetts') into state_004_id;
  SELECT common_get_table_id_by_name('State','Connecticut') into state_005_id;

--RETRIEVE METRO STAT AREAS
  SELECT m.id into metro_stat_area_001_id FROM metrostatarea m WHERE m.name='MSA_001';

  PERFORM common_create_county('COUNTY_001',0,state_002_id,metro_stat_area_001_id);
  PERFORM common_create_county('COUNTY_002',0,state_002_id,NULL);
  PERFORM common_create_county('COUNTY_003',0,state_003_id,NULL);
  PERFORM common_create_county('COUNTY_004',0,state_003_id,metro_stat_area_001_id);
  PERFORM common_create_county('Middlesex',0,state_004_id,NULL);
  PERFORM common_create_county('Middlesex',0,state_005_id,NULL);
  PERFORM common_create_county('New London',0,state_005_id,NULL);
  PERFORM common_create_county('Bristol',0,state_004_id,NULL);
  PERFORM common_create_county('Franklin',0,state_004_id,NULL);

success=true;
return success;
END
$$ LANGUAGE plpgsql;