CREATE OR REPLACE FUNCTION res_common_report_1_result_2_rpt_provider_details_pa(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
pharmacy_view CONSTANT integer:=1;
expected_provider_details_table_output VARCHAR;
BEGIN

expected_provider_details_table_output= null;
PERFORM res_rpt_provider_details_validate_data(report_id, pharmacy_view, expected_provider_details_table_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;