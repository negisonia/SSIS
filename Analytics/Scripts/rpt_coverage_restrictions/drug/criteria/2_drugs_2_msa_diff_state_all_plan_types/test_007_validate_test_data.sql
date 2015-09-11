CREATE OR REPLACE FUNCTION ana_rpt_cov_restric_drug_msa_diff_state_test_007_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'007', 'DRUG_002', 'PA');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
