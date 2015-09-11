CREATE OR REPLACE FUNCTION test_data_health_plan_state() --FF NEW
RETURNS boolean AS $$
DECLARE

state_001_id INTEGER;
state_002_id INTEGER;
state_003_id INTEGER;
state_ma_id INTEGER;
state_ct_id INTEGER;

health_plan VARCHAR:='healthplan';
state VARCHAR:='state';

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE STATES
  SELECT common_get_table_id_by_name(state, 'STATE_001') INTO state_001_id;
  SELECT common_get_table_id_by_name(state, 'STATE_002') INTO state_002_id;
  SELECT common_get_table_id_by_name(state, 'STATE_003') INTO state_003_id;
  SELECT common_get_table_id_by_name(state, 'Massachusetts') INTO state_ma_id;
  SELECT common_get_table_id_by_name(state, 'Connecticut') INTO state_ct_id;

  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_001'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_002'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_003'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_004'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_005'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_006'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_007'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_008'), state_002_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_009'), state_002_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_010'), state_002_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_011'), state_003_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_012'), state_002_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_013'), state_002_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_014'), state_003_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_015'), state_003_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_016'), state_003_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_017'), state_002_id);

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
  
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_018'), state_002_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_019'), state_002_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_020'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_021'), state_001_id);
  PERFORM common_create_health_plan_state(common_get_table_id_by_name(health_plan, 'TEST_PLAN_022'), state_001_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;