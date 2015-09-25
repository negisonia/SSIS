CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_provider_test_009_016_create_fe_data() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(ARRAY['STATE_001','STATE_002'],ARRAY['HEALTH_PLAN_TYPE_002'],ARRAY['DRUG_002','DRUG_003'],'State','DRUG_CLASS_001') INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;
