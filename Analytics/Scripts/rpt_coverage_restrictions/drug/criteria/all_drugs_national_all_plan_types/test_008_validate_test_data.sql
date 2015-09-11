CREATE OR REPLACE FUNCTION ana_rpt_cov_restric_drug_all_national_test_008_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'008', 'DRUG_002', 'PA or ST');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
