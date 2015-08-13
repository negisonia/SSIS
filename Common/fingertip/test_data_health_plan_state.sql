CREATE OR REPLACE FUNCTION test_data_health_plan_state() --FF NEW
RETURNS boolean AS $$
DECLARE

state_001_id INTEGER;
state_002_id INTEGER;

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

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE STATES
    SELECT s.id into state_001_id FROM state s WHERE s.name='STATE_001';
    SELECT s.id into state_002_id FROM state s WHERE s.name='STATE_002';
    SELECT s.id into state_003_id FROM state s WHERE s.name='STATE_003';

--RETRIVE HEALTH PLANS
    SELECT h.id into health_plan_001_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_001';
    SELECT h.id into health_plan_002_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_002';
    SELECT h.id into health_plan_003_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_003';
    SELECT h.id into health_plan_004_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_004';
    SELECT h.id into health_plan_005_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_005';
    SELECT h.id into health_plan_006_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_006';
    SELECT h.id into health_plan_007_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_007';
    SELECT h.id into health_plan_008_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_008';
    SELECT h.id into health_plan_009_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_009';
    SELECT h.id into health_plan_010_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_010';
    SELECT h.id into health_plan_011_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_011';
    SELECT h.id into health_plan_012_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_012';
    SELECT h.id into health_plan_013_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_013';
    SELECT h.id into health_plan_014_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_014';
    SELECT h.id into health_plan_015_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_015';
    SELECT h.id into health_plan_016_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_016';
    SELECT h.id into health_plan_017_id FROM healthplan h WHERE h.name='HEALTH_PLAN_TYPE_017';

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

success=true;
return success;
END
$$ LANGUAGE plpgsql;