CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_geo_test_015_016_create_fe_data() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

health_plan_type_001_id INTEGER;
drug_003_id INTEGER;
county_002_id INTEGER;
county_004_id INTEGER;
criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(ARRAY['COUNTY_002'],ARRAY['HEALTH_PLAN_TYPE_001'],ARRAY['DRUG_003'],'County') INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;
