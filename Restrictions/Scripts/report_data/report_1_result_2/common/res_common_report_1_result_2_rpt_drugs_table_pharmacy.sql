CREATE OR REPLACE FUNCTION res_common_report_1_result_2_rpt_drugs_table_pharmacy(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
pharmacy_view CONSTANT integer:=1;
expected_rpt_drug_output VARCHAR;
BEGIN

--VALIDATE RPT_DRUG pharmacy
expected_rpt_drug_output= format('%1$s',report_id);

PERFORM res_rpt_drug_validate_data(report_id, pharmacy_view ,expected_rpt_drug_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;