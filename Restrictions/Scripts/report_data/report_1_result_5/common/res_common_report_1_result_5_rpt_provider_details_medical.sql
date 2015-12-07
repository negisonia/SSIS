CREATE OR REPLACE FUNCTION res_common_report_1_result_5_rpt_provider_details_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_provider_details_table_output VARCHAR;
BEGIN

expected_provider_details_table_output= null;
PERFORM res_rpt_provider_details_validate_data(report_id, medical_view, expected_provider_details_table_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;