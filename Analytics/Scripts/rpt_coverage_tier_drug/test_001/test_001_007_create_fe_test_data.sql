CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_drug_test_001_007_create_fe_data() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

health_plan_type_001_id INTEGER;
health_plan_type_002_id INTEGER;
drug_001_id INTEGER;
drug_002_id INTEGER;
state_001_id INTEGER;
criteria_report_id INTEGER;

BEGIN

--GET the input data
SELECT id from drugs where name = 'DRUG_001' limit 1 INTO drug_001_id;
SELECT id from drugs where name = 'DRUG_002' limit 1 INTO drug_002_id;
SELECT id from health_plan_types where name = 'HEALTH_PLAN_TYPE_001' limit 1 INTO health_plan_type_001_id;
SELECT id from health_plan_types where name = 'HEALTH_PLAN_TYPE_002' limit 1 INTO health_plan_type_002_id;
SELECT id from states where name = 'STATE_001' limit 1 INTO state_001_id;

SELECT create_criteria_report(0,0,0,0,2,FALSE,FALSE,FALSE,ARRAY[drug_001_id,drug_002_id],ARRAY[health_plan_type_001_id,health_plan_type_002_id],'State',ARRAY[state_001_id], NULL,NULL) INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;