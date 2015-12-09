CREATE OR REPLACE FUNCTION res_report_1_result_3_geo_medical_drill(report_id INTEGER) --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_rpt_geo_output VARCHAR;
fe_report_1 INTEGER;
drug_2 INTEGER;
indication_1 INTEGER;
county_market_type INTEGER := 1;
state_market_type INTEGER := 2;
medical_benefit_type INTEGER := 2;
massachusetts_market_id INTEGER;
rep_1_group_1_m INTEGER;
rep_1_group_3_m INTEGER;

BEGIN

--RETRIEVE DATA
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_table_id_by_name('states','Massachusetts') INTO massachusetts_market_id;
SELECT common_get_custom_dim_criteria(indication_1, 'Medical', 'rep_1_group_1', 'rep_1_group_1',2,3) INTO rep_1_group_1_m;
SELECT common_get_custom_dim_criteria(indication_1, 'Medical', 'rep_1_group_3', 'rep_1_group_3',2,3) INTO rep_1_group_3_m;


expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"indication_1","benefit_name":"Medical","criteria_restriction_name":"rep_1_group_1","criteria_restriction_short_name":"rep_1_group_1","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(report_id, medical_benefit_type, county_market_type, rep_1_group_1_m, drug_2, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"indication_1","benefit_name":"Medical","criteria_restriction_name":"rep_1_group_3","criteria_restriction_short_name":"rep_1_group_3","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(report_id, medical_benefit_type, county_market_type, rep_1_group_3_m, drug_2, state_market_type, massachusetts_market_id, expected_rpt_geo_output);


success:=true;
return success;
END
$$ LANGUAGE plpgsql;