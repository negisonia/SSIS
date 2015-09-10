CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_009_014_create_fe_data()
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(ARRAY['STATE_002'],ARRAY['HEALTH_PLAN_TYPE_001','HEALTH_PLAN_TYPE_002'],ARRAY['DRUG_003'],'State') INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;