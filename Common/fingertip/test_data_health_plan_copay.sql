CREATE OR REPLACE FUNCTION test_data_health_plan_copay() --FF NEW
RETURNS boolean AS $$
DECLARE

state_001_id INTEGER;
state_002_id INTEGER;

tier_1_id INTEGER;
tier_2_id INTEGER;
tier_4_id INTEGER;
tier_na_id INTEGER;
tier_nc_id INTEGER;

health_plan VARCHAR:='healthplan';
state VARCHAR:='state';
tier VARCHAR:='tier';

benefit_structure_copay_id INTEGER;
benefit_structure_id INTEGER;

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE STATES
  SELECT common_get_table_id_by_name(state, 'STATE_001') INTO state_001_id;
  SELECT common_get_table_id_by_name(state, 'STATE_002') INTO state_002_id;

--RETRIEVE TIER
  SELECT common_get_table_id_by_name(tier, 'tier_1') INTO tier_1_id;
  SELECT common_get_table_id_by_name(tier, 'tier_2') INTO tier_2_id;
  SELECT common_get_table_id_by_name(tier, 'tier_4') INTO tier_2_id;
  SELECT common_get_table_id_by_name(tier, 'N/A') INTO tier_na_id;
  SELECT common_get_table_id_by_name(tier, 'Not Covered') INTO tier_nc_id;  

  -- TEST_PLAN_003
  SELECT common_create_benefit_structure(common_get_table_id_by_name(health_plan, 'TEST_PLAN_003'),TRUE) INTO benefit_structure_id;
    -- Insert Benefit Structure State
    PERFORM common_create_benefit_structure_state(benefit_structure_id, state_001_id);  
    -- Insert Benefit Structure Copay
    SELECT common_create_benefit_structure_copay(benefit_structure_id,TRUE) INTO benefit_structure_copay_id;
    -- Insert Benefit Structure Copay Value
    PERFORM common_create_benefit_structure_copay_value(benefit_structure_copay_id, tier_2_id, 5.00, 15.00, NULL, NULL, TRUE);

  -- TEST_PLAN_004
  SELECT common_create_benefit_structure(common_get_table_id_by_name(health_plan, 'TEST_PLAN_004'),TRUE) INTO benefit_structure_id;
    -- Insert Benefit Structure State
    PERFORM common_create_benefit_structure_state(benefit_structure_id, state_001_id);  
    -- Insert Benefit Structure Copay
    SELECT common_create_benefit_structure_copay(benefit_structure_id,TRUE) INTO benefit_structure_copay_id;
    -- Insert Benefit Structure Copay Value
    PERFORM common_create_benefit_structure_copay_value(benefit_structure_copay_id, tier_2_id, 10.00, 30.00, NULL, NULL, TRUE);
    
  -- TEST_PLAN_008
  SELECT common_create_benefit_structure(common_get_table_id_by_name(health_plan, 'TEST_PLAN_008'),TRUE) INTO benefit_structure_id;
    -- Insert Benefit Structure State
    PERFORM common_create_benefit_structure_state(benefit_structure_id, state_002_id);
    -- Insert Benefit Structure Copay
    SELECT common_create_benefit_structure_copay(benefit_structure_id,TRUE) INTO benefit_structure_copay_id;
    -- Insert Benefit Structure Copay Value
    PERFORM common_create_benefit_structure_copay_value(benefit_structure_copay_id, tier_1_id, 40.00, 80.00, NULL, NULL, TRUE);

  -- TEST_PLAN_009
  SELECT common_create_benefit_structure(common_get_table_id_by_name(health_plan, 'TEST_PLAN_009'),TRUE) INTO benefit_structure_id;
    -- Insert Benefit Structure State
    PERFORM common_create_benefit_structure_state(benefit_structure_id, state_002_id);
    -- Insert Benefit Structure Copay
    SELECT common_create_benefit_structure_copay(benefit_structure_id,TRUE) INTO benefit_structure_copay_id;
    -- Insert Benefit Structure Copay Value
    PERFORM common_create_benefit_structure_copay_value(benefit_structure_copay_id, tier_2_id, 5.00, 15.00, NULL, NULL, TRUE);

  -- TEST_PLAN_010
  SELECT common_create_benefit_structure(common_get_table_id_by_name(health_plan, 'TEST_PLAN_010'),TRUE) INTO benefit_structure_id;
    -- Insert Benefit Structure State
    PERFORM common_create_benefit_structure_state(benefit_structure_id, state_002_id);
    -- Insert Benefit Structure Copay
    SELECT common_create_benefit_structure_copay(benefit_structure_id,TRUE) INTO benefit_structure_copay_id;
    -- Insert Benefit Structure Copay Value
    PERFORM common_create_benefit_structure_copay_value(benefit_structure_copay_id, tier_2_id, 15.00, 45.00, NULL, NULL, TRUE);

  -- TEST_PLAN_020
  SELECT common_create_benefit_structure(common_get_table_id_by_name(health_plan, 'TEST_PLAN_020'),TRUE) INTO benefit_structure_id;
    -- Insert Benefit Structure State
    PERFORM common_create_benefit_structure_state(benefit_structure_id, state_001_id);
    -- Insert Benefit Structure Copay
    SELECT common_create_benefit_structure_copay(benefit_structure_id,TRUE) INTO benefit_structure_copay_id;
    -- Insert Benefit Structure Copay Value
    PERFORM common_create_benefit_structure_copay_value(benefit_structure_copay_id, tier_2_id, 15.00, 25.00, NULL, NULL, TRUE);

-- TEST_PLAN_021
  SELECT common_create_benefit_structure(common_get_table_id_by_name(health_plan, 'TEST_PLAN_021'),TRUE) INTO benefit_structure_id;
    -- Insert Benefit Structure State
    PERFORM common_create_benefit_structure_state(benefit_structure_id, state_001_id);
    -- Insert Benefit Structure Copay
    SELECT common_create_benefit_structure_copay(benefit_structure_id,TRUE) INTO benefit_structure_copay_id;
    -- Insert Benefit Structure Copay Value
    PERFORM common_create_benefit_structure_copay_value(benefit_structure_copay_id, tier_4_id, 25.00, 35.00, NULL, NULL, TRUE);

-- TEST_PLAN_022
  SELECT common_create_benefit_structure(common_get_table_id_by_name(health_plan, 'TEST_PLAN_022'),TRUE) INTO benefit_structure_id;
    -- Insert Benefit Structure State
    PERFORM common_create_benefit_structure_state(benefit_structure_id, state_001_id);
    -- Insert Benefit Structure Copay
    SELECT common_create_benefit_structure_copay(benefit_structure_id,TRUE) INTO benefit_structure_copay_id;
    -- Insert Benefit Structure Copay Value
    PERFORM common_create_benefit_structure_copay_value(benefit_structure_copay_id, tier_2_id, 25.00, 85.00, NULL, NULL, TRUE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;