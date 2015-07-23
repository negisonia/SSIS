CREATE OR REPLACE FUNCTION restrictions_test_001_create_test_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE
health_plan_types VARCHAR[] := ARRAY['restrictions_test_commercial','restrictions_test_hix','restrictions_test_commercial_bcbs','restrictions_test_employer','restrictions_test_medicare_ma','restrictions_test_medicare_sn','restrictions_test_medicare_pdp','restrictions_test_state_medicare','restrictions_test_dpp','restrictions_test_commercial_medicaid','restrictions_test_union','restrictions_test_municipal_plan','restrictions_test_pbm','restrictions_test_commercial_inactive'];
intvalue INTEGER;
commercial_hpt_id INTEGER;
textValue VARCHAR;

provider_1 INTEGER;
provider_2 INTEGER;
provider_3 INTEGER;
provider_4 INTEGER;
provider_5 INTEGER;
provider_6 INTEGER;
provider_7 INTEGER;
provider_8 INTEGER;

success BOOLEAN:=FALSE;
BEGIN

SELECT common_create_provider(TRUE,'restrictions_provider_1',NULL) INTO provider_1;
SELECT common_create_provider(TRUE,'restrictions_provider_2',NULL) INTO provider_2;
SELECT common_create_provider(TRUE,'restrictions_provider_3',NULL) INTO provider_3;
SELECT common_create_provider(TRUE,'restrictions_provider_4',NULL) INTO provider_4;
SELECT common_create_provider(TRUE,'restrictions_provider_5',NULL) INTO provider_5;
SELECT common_create_provider(TRUE,'restrictions_provider_6',NULL) INTO provider_6;
SELECT common_create_provider(TRUE,'restrictions_provider_7',NULL) INTO provider_7;
SELECT common_create_provider(TRUE,'restrictions_provider_8',NULL) INTO provider_8;



--ITERATE HEALTHPLAN TYPES
FOREACH textValue IN ARRAY health_plan_types
LOOP

--INSERT HEALTHPLAN TYPES
CASE textValue 
	WHEN 'restrictions_test_commercial' THEN		
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;		
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_commercial_1',NULL,provider_1);
		PERFORM common_create_healthplan(intvalue,FALSE,'restrictions_test_hp_commercial_2',NULL,provider_1);
	WHEN 'restrictions_test_hix' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_hix_1',NULL,provider_1);
	WHEN 'restrictions_test_commercial_bcbs' THEN		
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
	        PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_bcbs_1',NULL,provider_7);
	WHEN 'restrictions_test_employer' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_employeer_1',NULL,provider_3);
	WHEN 'restrictions_test_medicare_ma' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_na_1',NULL,provider_7);
	WHEN 'restrictions_test_medicare_sn' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_sn_1',NULL,provider_7);
	WHEN 'restrictions_test_medicare_pdp' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_pdp_1',NULL,provider_6);
	WHEN 'restrictions_test_state_medicare' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_state_1',NULL,provider_1);
	WHEN 'restrictions_test_dpp' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_dpp_1',NULL,provider_5);
	WHEN 'restrictions_test_commercial_medicaid' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_commercial_medicaid_1',NULL,provider_7);
	WHEN 'restrictions_test_union' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_union_1',NULL,provider_2);
	WHEN 'restrictions_test_municipal_plan' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_municipal_plan_1',NULL,provider_4);
	WHEN 'restrictions_test_pbm' THEN
		SELECT common_create_health_plan_type(TRUE,textValue, TRUE, TRUE) INTO intvalue;
		PERFORM common_create_healthplan(intvalue,TRUE,'restrictions_test_hp_pbm_1',NULL,provider_8);
	ELSE 
		RAISE NOTICE 'UNEXPECTED HEALTH PLAN TYPE ITERATION';
END CASE;
	
END LOOP;

success=true;
return success;
END
$$ LANGUAGE plpgsql;