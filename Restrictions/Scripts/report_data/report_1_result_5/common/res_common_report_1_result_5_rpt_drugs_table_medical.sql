CREATE OR REPLACE FUNCTION res_common_report_1_result_5_rpt_drugs_table_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
medical_view CONSTANT integer:=2;
expected_rpt_drug_output VARCHAR;
BEGIN

--VALIDATE SUMMARY TABLE
expected_rpt_drug_output= null;
PERFORM res_rpt_drug_validate_data(report_id, medical_view ,expected_rpt_drug_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;