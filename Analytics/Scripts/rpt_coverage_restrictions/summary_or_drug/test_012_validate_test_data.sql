CREATE OR REPLACE FUNCTION ana_rpt_coverage_restrictions_drug_test_012_validate_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value varchar;
BEGIN

expected_value = '';

PERFORM ana_rpt_coverage_restrictions_drug_calculate_report_row(expected_value,'012', 'DRUG_003', 'PA');

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
