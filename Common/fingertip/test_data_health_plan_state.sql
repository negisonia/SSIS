CREATE OR REPLACE FUNCTION test_data_health_plan_state() --FF NEW
RETURNS boolean AS $$
DECLARE

state_001_id INTEGER;
state_002_id INTEGER;
state_003_id INTEGER;
state_ma_id INTEGER;
state_ct_id INTEGER;

health_plan_001_id INTEGER;
health_plan_002_id INTEGER;
health_plan_003_id INTEGER;
health_plan_004_id INTEGER;
health_plan_005_id INTEGER;
health_plan_006_id INTEGER;
health_plan_007_id INTEGER;
health_plan_008_id INTEGER;
health_plan_009_id INTEGER;
health_plan_010_id INTEGER;
health_plan_011_id INTEGER;
health_plan_012_id INTEGER;
health_plan_013_id INTEGER;
health_plan_014_id INTEGER;
health_plan_015_id INTEGER;
health_plan_016_id INTEGER;
health_plan_017_id INTEGER;

health_plan VARCHAR:='healthplan';

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE STATES
    SELECT s.id into state_001_id FROM state s WHERE s.name='STATE_001';
    SELECT s.id into state_002_id FROM state s WHERE s.name='STATE_002';
    SELECT s.id into state_003_id FROM state s WHERE s.name='STATE_003';
    SELECT common_get_table_id_by_name('state', 'Massachusetts') INTO state_ma_id;
    SELECT common_get_table_id_by_name('state', 'Connecticut') INTO state_ct_id;

--RETRIVE HEALTH PLANS
    SELECT h.id into health_plan_001_id FROM healthplan h WHERE h.name='TEST_PLAN_001';
    SELECT h.id into health_plan_002_id FROM healthplan h WHERE h.name='TEST_PLAN_002';
    SELECT h.id into health_plan_003_id FROM healthplan h WHERE h.name='TEST_PLAN_003';
    SELECT h.id into health_plan_004_id FROM healthplan h WHERE h.name='TEST_PLAN_004';
    SELECT h.id into health_plan_005_id FROM healthplan h WHERE h.name='TEST_PLAN_005';
    SELECT h.id into health_plan_006_id FROM healthplan h WHERE h.name='TEST_PLAN_006';
    SELECT h.id into health_plan_007_id FROM healthplan h WHERE h.name='TEST_PLAN_007';
    SELECT h.id into health_plan_008_id FROM healthplan h WHERE h.name='TEST_PLAN_008';
    SELECT h.id into health_plan_009_id FROM healthplan h WHERE h.name='TEST_PLAN_009';
    SELECT h.id into health_plan_010_id FROM healthplan h WHERE h.name='TEST_PLAN_010';
    SELECT h.id into health_plan_011_id FROM healthplan h WHERE h.name='TEST_PLAN_011';
    SELECT h.id into health_plan_012_id FROM healthplan h WHERE h.name='TEST_PLAN_012';
    SELECT h.id into health_plan_013_id FROM healthplan h WHERE h.name='TEST_PLAN_013';
    SELECT h.id into health_plan_014_id FROM healthplan h WHERE h.name='TEST_PLAN_014';
    SELECT h.id into health_plan_015_id FROM healthplan h WHERE h.name='TEST_PLAN_015';
    SELECT h.id into health_plan_016_id FROM healthplan h WHERE h.name='TEST_PLAN_016';
    SELECT h.id into health_plan_017_id FROM healthplan h WHERE h.name='TEST_PLAN_017';

  PERFORM common_create_health_plan_state(health_plan_001_id, state_001_id);
  PERFORM common_create_health_plan_state(health_plan_002_id, state_001_id);
  PERFORM common_create_health_plan_state(health_plan_003_id, state_001_id);
  PERFORM common_create_health_plan_state(health_plan_004_id, state_001_id);
  PERFORM common_create_health_plan_state(health_plan_005_id, state_001_id);
  PERFORM common_create_health_plan_state(health_plan_006_id, state_001_id);
  PERFORM common_create_health_plan_state(health_plan_007_id, state_001_id);
  PERFORM common_create_health_plan_state(health_plan_008_id, state_002_id);
  PERFORM common_create_health_plan_state(health_plan_009_id, state_002_id);
  PERFORM common_create_health_plan_state(health_plan_010_id, state_002_id);
  PERFORM common_create_health_plan_state(health_plan_011_id, state_003_id);
  PERFORM common_create_health_plan_state(health_plan_012_id, state_002_id);
  PERFORM common_create_health_plan_state(health_plan_013_id, state_002_id);
  PERFORM common_create_health_plan_state(health_plan_014_id, state_003_id);
  PERFORM common_create_health_plan_state(health_plan_015_id, state_003_id);
  PERFORM common_create_health_plan_state(health_plan_016_id, state_003_id);
  PERFORM common_create_health_plan_state(health_plan_017_id, state_002_id);

  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_comm'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_hix'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_bcbs'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_empl'), state_ct_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_ma'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_sn'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_pdp'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_state'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_dpp'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_com_med'), state_ct_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_union'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_mun'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_pbm'), state_ma_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_comm_1'), state_ct_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'health_plan_comm_2'), state_ma_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;