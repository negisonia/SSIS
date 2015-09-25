CREATE OR REPLACE FUNCTION test_data_counties() --FF NEW
RETURNS boolean AS $$
DECLARE

state_001_id INTEGER;
state_002_id INTEGER;
state_003_id INTEGER;
state_004_id INTEGER;
state_005_id INTEGER;

metro_stat_area_001_id INTEGER;
metro_stat_area_002_id INTEGER;
metro_stat_area_003_id INTEGER;
metro_stat_area_004_id INTEGER;
state VARCHAR:='state';
metrostatarea VARCHAR:='metrostatarea';

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE STATES
  SELECT common_get_table_id_by_name(state,'STATE_001') into state_001_id;
  SELECT common_get_table_id_by_name(state,'STATE_002') into state_002_id;
  SELECT common_get_table_id_by_name(state,'STATE_003') into state_003_id;
  SELECT common_get_table_id_by_name(state,'Massachusetts') into state_004_id;
  SELECT common_get_table_id_by_name(state,'Connecticut') into state_005_id;

--RETRIEVE METRO STAT AREAS
  SELECT common_get_table_id_by_name(metrostatarea,'MSA_001') INTO metro_stat_area_001_id;
  SELECT common_get_table_id_by_name(metrostatarea,'MSA_002') INTO metro_stat_area_002_id;
  SELECT common_get_table_id_by_name(metrostatarea,'MSA_003') INTO metro_stat_area_003_id;
  SELECT common_get_table_id_by_name(metrostatarea,'MSA_004') INTO metro_stat_area_004_id;

  PERFORM common_create_county('COUNTY_001',0,state_002_id,metro_stat_area_001_id);
  PERFORM common_create_county('COUNTY_002',0,state_002_id,metro_stat_area_004_id);
  PERFORM common_create_county('COUNTY_003',0,state_003_id,metro_stat_area_004_id);
  PERFORM common_create_county('COUNTY_004',0,state_003_id,metro_stat_area_001_id);

  PERFORM common_create_county('Middlesex',0,state_004_id,NULL);
  PERFORM common_create_county('Middlesex',0,state_005_id,NULL);
  PERFORM common_create_county('New London',0,state_005_id,NULL);
  PERFORM common_create_county('Bristol',0,state_004_id,NULL);
  PERFORM common_create_county('Franklin',0,state_004_id,NULL);

  PERFORM common_create_county('COUNTY_005',0,state_001_id,metro_stat_area_002_id);
  PERFORM common_create_county('COUNTY_006',0,state_001_id,metro_stat_area_002_id);
  PERFORM common_create_county('COUNTY_007',0,state_001_id,metro_stat_area_003_id);
  PERFORM common_create_county('COUNTY_008',0,state_001_id,metro_stat_area_003_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;