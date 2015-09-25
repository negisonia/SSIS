CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_geo_test_011_014_create_fe_data() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(ARRAY['MSA_001'],ARRAY['HEALTH_PLAN_TYPE_001','HEALTH_PLAN_TYPE_002'],ARRAY['DRUG_003'],'MetroStatArea','DRUG_CLASS_001') INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;
