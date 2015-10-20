-- Plan details - Report 1 Result 2
CREATE OR REPLACE FUNCTION res_report_1_result_2_test_38_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  criteria_report_id INTEGER;
BEGIN

-- Create Criteria Report Id
SELECT res_create_report_1_result_2_criteria_report() INTO criteria_report_id;
PERFORM res_common_report_1_result_2_rpt_health_plan_type_medical(criteria_report_id);
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;