CREATE OR REPLACE FUNCTION ana_rpt_cov_tier_drg_selection_2_test_01_10_validate_data(expected_value varchar, test_number varchar, drug_name varchar, dim_tier_name varchar)
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(ARRAY['MSA_001','MSA_002'], ARRAY['HEALTH_PLAN_TYPE_001','HEALTH_PLAN_TYPE_002','HEALTH_PLAN_TYPE_003'], ARRAY['DRUG_001','DRUG_002','DRUG_003'],'MetroStatArea','DRUG_CLASS_001') INTO criteria_report_id;
PERFORM ana_rpt_coverage_tier_drug_validate_report_row(expected_value, test_number, drug_name, dim_tier_name, criteria_report_id);

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;