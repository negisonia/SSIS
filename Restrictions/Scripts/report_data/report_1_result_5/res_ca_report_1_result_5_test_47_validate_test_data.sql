 -- Summary Table, Pharmacy and Medical - Report 2
CREATE OR REPLACE FUNCTION res_ca_report_1_result_5_test_47_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  criteria_report_id INTEGER;
BEGIN

-- Create Criteria Report Id
SELECT res_ca_create_report_1_result_5_criteria_report() INTO criteria_report_id;
PERFORM res_report_1_result_5_rpt_healthplan_type_pharmacy(criteria_report_id);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;