CREATE OR REPLACE FUNCTION res_result_6_geo_medical_drill(report_id INTEGER) --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_rpt_geo_output VARCHAR;
fe_report_1 INTEGER;
drug_1 INTEGER;
drug_2 INTEGER;
indication_1 INTEGER;
county_market_type INTEGER := 3;
state_market_type INTEGER := 1;
medical_benefit_type INTEGER := 2;
connecticut_market_id INTEGER;
massachusetts_market_id INTEGER;


ind1_m_unspecified INTEGER;
ind1_m_criteria_diagnosis_3 INTEGER;
ind1_m_age_1 INTEGER;
ind1_m_st_custom_option_2 INTEGER;

ct_middlesex_id INTEGER;
ma_middlesex_id INTEGER;

BEGIN

--RETRIEVE DATA
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_table_id_by_name('states','Connecticut') INTO connecticut_market_id;
SELECT common_get_table_id_by_name('states','Massachusetts') INTO massachusetts_market_id;
SELECT c.id from counties c where c.state_id=connecticut_market_id and c.name='Middlesex' INTO ct_middlesex_id;
SELECT c.id from counties c where c.state_id=massachusetts_market_id and c.name='Middlesex' INTO ma_middlesex_id;

--RETRIEVE RESTRICTIONS

SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Unspecified','Criteria Unspecified') INTO ind1_m_unspecified;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Diagnosis','criteria_diagnosis_3') INTO ind1_m_criteria_diagnosis_3;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','Age','criteria_age_1') INTO ind1_m_age_1;
SELECT common_get_dim_criteria_restriction_by_name(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;


--Drill down to Middlesex, MA
expected_rpt_geo_output= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","criteria_restriction_name":"Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(report_id, medical_benefit_type, state_market_type, ind1_m_age_1, drug_2, state_market_type, ma_middlesex_id, expected_rpt_geo_output);

expected_rpt_geo_output= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","criteria_restriction_name":"Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(report_id, medical_benefit_type, state_market_type, ind1_m_criteria_diagnosis_3, drug_2, state_market_type, ma_middlesex_id, expected_rpt_geo_output);

expected_rpt_geo_output= '['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Medical","criteria_restriction_name":"ST - Single - custom_option_2","criteria_restriction_short_name":"custom_option_2","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":200,"total_health_plan_count":0,"total_provider_count":2}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(report_id, medical_benefit_type, state_market_type, ind1_m_st_custom_option_2, drug_2, state_market_type, ma_middlesex_id, expected_rpt_geo_output);


success:=true;
return success;
END
$$ LANGUAGE plpgsql;