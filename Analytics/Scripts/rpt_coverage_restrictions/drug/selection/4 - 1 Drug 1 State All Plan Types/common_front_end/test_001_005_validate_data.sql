CREATE OR REPLACE FUNCTION ana_rpt_cov_restr_drg_selection_4_test_01_05_validate_data(expected_value varchar, test_number varchar, drug_name varchar, qualifier_name varchar)
RETURNS INTEGER AS $$
DECLARE

criteria_report_id INTEGER;

BEGIN

SELECT ana_rpt_create_criteria_report_fe_data(ARRAY['STATE_001'],ARRAY['HEALTH_PLAN_TYPE_001','HEALTH_PLAN_TYPE_002','HEALTH_PLAN_TYPE_003'],ARRAY['DRUG_001'],'State') INTO criteria_report_id;
PERFORM ana_rpt_coverage_restrictions_drug_validate_report_row(expected_value, test_number, drug_name, qualifier_name, criteria_report_id);


RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;