 -- Summary Table, Pharmacy and Medical - Report 2
CREATE OR REPLACE FUNCTION res_ca_report_1_result_5_test_46_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  criteria_report_id INTEGER;
BEGIN

-- Create Criteria Report Id
SELECT res_ca_create_report_1_result_5_criteria_report() INTO criteria_report_id;
PERFORM res_report_1_result_5_geo_pharmacy_drill(criteria_report_id);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;