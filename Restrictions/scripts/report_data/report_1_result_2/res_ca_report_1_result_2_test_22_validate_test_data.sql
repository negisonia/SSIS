-- Summary Table, Pharmacy and Medical - Report 2
CREATE OR REPLACE FUNCTION res_ca_report_1_result_2_test_22_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  criteria_report_id INTEGER;
  expected_summary_pharmacy_table_output VARCHAR;
  expected_summary_medical_table_output VARCHAR;
  pharmacy_view CONSTANT integer:=1;
  medical_view CONSTANT integer:=2;
BEGIN

-- Create Criteria Report Id
SELECT res_ca_etl_test_create_report_2_criteria_report_data() INTO criteria_report_id;

expected_summary_pharmacy_table_output= format('['||
']',criteria_report_id);

PERFORM res_rpt_summary_table_validate_data(criteria_report_id,expected_summary_pharmacy_table_output,pharmacy_view);

expected_summary_medical_table_output= format('['||
']',criteria_report_id);

PERFORM res_rpt_summary_table_validate_data(criteria_report_id,expected_summary_medical_table_output,medical_view);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;