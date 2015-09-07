CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test_001_010_create_fe_data() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

health_plan_type_001_id INTEGER;
health_plan_type_002_id INTEGER;
drug_003_id INTEGER;
state_002_id INTEGER;
criteria_report_id INTEGER;

BEGIN

--GET the input data
SELECT common_get_table_id_by_name('drugs','DRUG_003') INTO drug_003_id;
SELECT common_get_table_id_by_name('health_plan_types','HEALTH_PLAN_TYPE_001') INTO health_plan_type_001_id;
SELECT common_get_table_id_by_name('health_plan_types','HEALTH_PLAN_TYPE_002') INTO health_plan_type_002_id;
SELECT common_get_table_id_by_name('states','STATE_002') INTO state_002_id;

SELECT create_criteria_report(NULL,0,0,0,2,FALSE,FALSE,FALSE,ARRAY[drug_003_id],ARRAY[health_plan_type_001_id,health_plan_type_002_id],'State',ARRAY[state_002_id],NULL,NULL,NULL,NULL,NULL,NULL) INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;