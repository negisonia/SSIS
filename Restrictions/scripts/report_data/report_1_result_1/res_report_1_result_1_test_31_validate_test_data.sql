CREATE OR REPLACE FUNCTION res_report_1_result_1_test_31_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_rpt_geo_output VARCHAR;
fe_report_1 INTEGER;
drug_1 INTEGER;
drug_2 INTEGER;
indication_1 INTEGER;
pharmacy_benefit_type INTEGER := 1;
county_market_type INTEGER := 1;
state_market_type INTEGER := 2;
msa_market_type INTEGER := 3;
ind1_pa_diagnosis_1 INTEGER;
ind1_pa_clinical_1 INTEGER;
ind1_pa_age_1 INTEGER;
ind1_pa_diagnosis_3 INTEGER;
ind1_pa_ql INTEGER;
ind1_pa_unspecified INTEGER;
ind1_pa_past_custom_option_1 INTEGER;
ind1_pa_st_double_co_1_co_2 INTEGER;
massachusetts_market_id INTEGER;
connecticut_market_id INTEGER;

BEGIN

--RETRIEVE DATA
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_1') INTO ind1_pa_diagnosis_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Clinical','criteria_clinical_1') INTO ind1_pa_clinical_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Age','criteria_age_1') INTO ind1_pa_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_3') INTO ind1_pa_diagnosis_3;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','QL','criteria_ql_1') INTO ind1_pa_ql;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Unspecified','Criteria Unspecified') INTO ind1_pa_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_co_1_co_2;
SELECT common_get_table_id_by_name('states','Massachusetts') INTO massachusetts_market_id;
SELECT common_get_table_id_by_name('states','Connecticut') INTO connecticut_market_id;

--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;

-- Massachusetts
expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","criteria_restriction_short_name":"criteria_diagnosis_1","market_name":"Middlesex","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'
||']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_diagnosis_1, drug_1, state_market_type, massachusetts_market_id, expected_rpt_geo_output);


expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Clinical - criteria_clinical_1","criteria_restriction_short_name":"criteria_clinical_1","market_name":"Middlesex","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_clinical_1, drug_1, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Age - criteria_age_1","criteria_restriction_short_name":"criteria_age_1","market_name":"Middlesex","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_age_1, drug_1, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","criteria_restriction_short_name":"criteria_diagnosis_3","market_name":"Middlesex","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_diagnosis_3, drug_1, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","market_name":"Middlesex","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'
||']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_ql, drug_1, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","market_name":"Middlesex","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_unspecified, drug_1, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","market_name":"Middlesex","drug_name":"drug_1","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_past_custom_option_1, drug_1, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","criteria_restriction_short_name":"criteria_diagnosis_1","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_diagnosis_1, drug_2, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA/ST - Single - custom_option_1","criteria_restriction_short_name":"custom_option_1","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_past_custom_option_1, drug_2, state_market_type, massachusetts_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2","criteria_restriction_short_name":"custom_option_1 AND  custom_option_2","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":200,"total_medical_lives":0,"total_health_plan_count":2,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_st_double_co_1_co_2, drug_2, state_market_type, massachusetts_market_id, expected_rpt_geo_output);


-- Connecticut
expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_unspecified, drug_2, state_market_type, connecticut_market_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(fe_report_1, pharmacy_benefit_type, county_market_type, ind1_pa_ql, drug_2, state_market_type, connecticut_market_id, expected_rpt_geo_output);


success:=true;
return success;
END
$$ LANGUAGE plpgsql;