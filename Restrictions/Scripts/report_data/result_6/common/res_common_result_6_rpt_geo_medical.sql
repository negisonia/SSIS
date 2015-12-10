CREATE OR REPLACE FUNCTION res_common_result_6_rpt_geo_medical(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

market_type INTEGER := 2;
medical_benefit_type INTEGER := 2;
expected_output VARCHAR;
drug_1_id INTEGER;
drug_2_id INTEGER;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
--MARKET TYPES : 1 COUNTIES , 2 STATES , 3 MSA

--MEDICAL GEO
expected_output= '';
PERFORM res_rpt_geo_validate_data(report_id, medical_benefit_type, market_type, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;