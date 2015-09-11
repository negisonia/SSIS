CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_001_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'001', 'DRUG_001', 'ST');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
