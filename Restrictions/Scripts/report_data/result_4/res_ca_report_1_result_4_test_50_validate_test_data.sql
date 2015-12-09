-- Summary Table, Pharmacy and Medical - Report 3
CREATE OR REPLACE FUNCTION res_ca_report_1_result_4_test_50_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  criteria_report_id INTEGER;
BEGIN

-- Create Criteria Report Id
SELECT res_ca_create_report_1_result_4_criteria_report() INTO criteria_report_id;
PERFORM res_common_report_1_result_4_rpt_drugs_table_medical(criteria_report_id);
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;