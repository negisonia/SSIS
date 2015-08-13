CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_geo_test_011_014_create_fe_data() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

health_plan_type_001_id INTEGER;
health_plan_type_002_id INTEGER;
drug_003_id INTEGER;
metro_stat_area_001_id INTEGER;
criteria_report_id INTEGER;

BEGIN

--GET the input data
SELECT id from drugs where name = 'DRUG_003' limit 1 INTO drug_003_id;
SELECT id from health_plan_types where name = 'HEALTH_PLAN_TYPE_001' limit 1 INTO health_plan_type_001_id;
SELECT id from health_plan_types where name = 'HEALTH_PLAN_TYPE_002' limit 1 INTO health_plan_type_002_id;
SELECT id from metro_stat_areas where name = 'MSA_001' limit 1 INTO metro_stat_area_001_id;

SELECT create_criteria_report(0,0,0,0,4,FALSE,FALSE,FALSE,ARRAY[drug_003_id],ARRAY[health_plan_type_001_id,health_plan_type_002_id],'MetroStatArea',ARRAY[metro_stat_area_001_id]) INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;