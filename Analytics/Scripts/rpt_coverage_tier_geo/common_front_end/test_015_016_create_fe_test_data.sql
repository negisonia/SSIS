CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_geo_test_015_016_create_fe_data() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

health_plan_type_001_id INTEGER;
drug_003_id INTEGER;
county_002_id INTEGER;
county_004_id INTEGER;
criteria_report_id INTEGER;

BEGIN

--GET the input data
SELECT id from drugs where name = 'DRUG_003' limit 1 INTO drug_003_id;
SELECT id from health_plan_types where name = 'HEALTH_PLAN_TYPE_001' limit 1 INTO health_plan_type_001_id;
SELECT id from counties where name = 'COUNTY_002' limit 1 INTO county_002_id;
SELECT id from counties where name = 'COUNTY_004' limit 1 INTO county_004_id;

SELECT create_criteria_report(NULL,0,0,0,3,FALSE,FALSE,FALSE,ARRAY[drug_003_id],ARRAY[health_plan_type_001_id],'County',ARRAY[county_002_id,county_004_id],NULL,NULL,NULL,NULL,NULL,NULL) INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;