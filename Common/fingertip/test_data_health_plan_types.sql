CREATE OR REPLACE FUNCTION test_data_health_plan_types() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

        --HEALTH PLAN TYPES
		PERFORM common_create_health_plan_type(TRUE,'commercial', TRUE, TRUE) ;
		PERFORM common_create_health_plan_type(TRUE,'hix', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'commercial_bcbs', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'employer', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'medicare_ma', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'medicare_sn', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'medicare_pdp', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'state_medicare', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'dpp', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'commercial_medicaid', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'union', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'municipal_plan', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE,'pbm', TRUE, TRUE);
		PERFORM common_create_health_plan_type(FALSE,'commercial_inactive', TRUE, TRUE);
		PERFORM common_create_health_plan_type(TRUE, 'HEALTH_PLAN_TYPE_001', TRUE, FALSE);
		PERFORM common_create_health_plan_type(TRUE, 'HEALTH_PLAN_TYPE_002', FALSE, TRUE);
		PERFORM common_create_health_plan_type(TRUE, 'HEALTH_PLAN_TYPE_003', TRUE, FALSE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;