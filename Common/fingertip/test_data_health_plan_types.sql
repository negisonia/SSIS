CREATE OR REPLACE FUNCTION test_data_health_plan_types() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

        --HEALTH PLAN TYPES
		PERFORM common_create_health_plan_type(1, TRUE,'commercial', TRUE, TRUE) ;
		PERFORM common_create_health_plan_type(2, TRUE,'commercial_bcbs', TRUE, TRUE);
		PERFORM common_create_health_plan_type(3, TRUE,'commercial_medicaid', TRUE, TRUE);
		PERFORM common_create_health_plan_type(4, TRUE,'employer', TRUE, TRUE);
		PERFORM common_create_health_plan_type(5, TRUE,'medicare_ma', TRUE, TRUE);
		PERFORM common_create_health_plan_type(6, TRUE,'medicare_pdp', TRUE, TRUE);
		PERFORM common_create_health_plan_type(7, TRUE,'medicare_sn', TRUE, TRUE);
		PERFORM common_create_health_plan_type(8, TRUE,'municipal_plan', TRUE, TRUE);
		PERFORM common_create_health_plan_type(9, TRUE,'pbm', TRUE, TRUE);
		PERFORM common_create_health_plan_type(10, TRUE,'state_medicare', TRUE, TRUE);
		PERFORM common_create_health_plan_type(11, TRUE,'union', TRUE, TRUE);
		PERFORM common_create_health_plan_type(12, TRUE,'dpp', TRUE, TRUE);
		PERFORM common_create_health_plan_type(13, TRUE,'hix', TRUE, TRUE);
		PERFORM common_create_health_plan_type(14, FALSE,'commercial_inactive', TRUE, TRUE);
		PERFORM common_create_health_plan_type(15, TRUE, 'HEALTH_PLAN_TYPE_001', TRUE, FALSE);
		PERFORM common_create_health_plan_type(16, TRUE, 'HEALTH_PLAN_TYPE_002', FALSE, TRUE);
		PERFORM common_create_health_plan_type(17, TRUE, 'HEALTH_PLAN_TYPE_003', TRUE, FALSE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;