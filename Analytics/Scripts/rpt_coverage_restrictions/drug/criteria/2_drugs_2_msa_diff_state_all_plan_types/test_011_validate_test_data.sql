CREATE OR REPLACE FUNCTION ana_rpt_cov_restric_drug_msa_diff_state_test_011_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'011', 'DRUG_002', 'Any');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
