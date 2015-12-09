CREATE OR REPLACE FUNCTION res_report_1_result_3_test_112_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
fe_report_1 INTEGER;
BEGIN
--REPORT#1
SELECT res_create_report_1_result_3_criteria_report() INTO fe_report_1;
PERFORM res_report_1_result_3_geo_pharmacy_drill(fe_report_1);
success:=true;
return success;
END
$$ LANGUAGE plpgsql;