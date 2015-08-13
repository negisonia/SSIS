CREATE OR REPLACE FUNCTION test_data_counties() --FF NEW
RETURNS boolean AS $$
DECLARE

state_002_id INTEGER;
state_003_id INTEGER;

metro_stat_area_001_id INTEGER;

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE STATES
    SELECT s.id into state_002_id FROM state s WHERE s.name='STATE_002';
    SELECT s.id into state_003_id FROM state s WHERE s.name='STATE_003';

--RETRIEVE METRO STAT AREAS
    SELECT m.id into metro_stat_area_001_id FROM metrostatarea m WHERE m.name='MSA_001';

  PERFORM common_create_county('COUNTY_001',0,state_002_id,metro_stat_area_001_id);
  PERFORM common_create_county('COUNTY_002',0,state_002_id,NULL);
  PERFORM common_create_county('COUNTY_003',0,state_003_id,NULL);
  PERFORM common_create_county('COUNTY_004',0,state_003_id,metro_stat_area_001_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;