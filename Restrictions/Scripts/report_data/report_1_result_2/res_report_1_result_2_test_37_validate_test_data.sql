CREATE OR REPLACE FUNCTION res_report_1_result_2_test_37_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
fe_report_1 INTEGER;
pharmacy_view CONSTANT integer:=1;
medical_view CONSTANT integer:=2;
expected_pharmacy_summary_table_output VARCHAR;
expected_medical_summary_table_output VARCHAR;
BEGIN
--REPORT#1
SELECT res_create_report_1_result_2_criteria_report() INTO fe_report_1;
PERFORM res_common_report_1_result_2_rpt_drugs_table_pharmacy(fe_report_1);

success=true;
return success;
END
$$ LANGUAGE plpgsql;