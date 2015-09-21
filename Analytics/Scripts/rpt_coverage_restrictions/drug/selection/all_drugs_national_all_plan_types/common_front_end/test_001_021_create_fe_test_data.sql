-- Analytics rpt_coverage_restrictions_drug All drugs All states All health plan types
CREATE OR REPLACE FUNCTION ana_rpt_cov_res_drug_all_national_test_001_021_create_fe_data()
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(ARRAY[]::varchar[],ARRAY['HEALTH_PLAN_TYPE_001','HEALTH_PLAN_TYPE_002','HEALTH_PLAN_TYPE_003'],ARRAY['DRUG_001','DRUG_002','DRUG_003','DRUG_004'],'National') INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;