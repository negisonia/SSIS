CREATE OR REPLACE FUNCTION res_report_1_result_5_geo_pharmacy_drill(report_id INTEGER) --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_rpt_geo_output VARCHAR;
fe_report_1 INTEGER;
drug_1 INTEGER;
drug_2 INTEGER;
indication_1 INTEGER;
county_market_type INTEGER := 1;
state_market_type INTEGER := 1;
pharmacy_benefit_type INTEGER := 1;
connecticut_market_id INTEGER;

ind1_pa_diagnosis_1 INTEGER;
ind1_pa_diagnosis_3 INTEGER;
ind1_pa_clinical_1 INTEGER;
ind1_pa_unspecified INTEGER;
ind1_pa_ql INTEGER;
ind1_pa_age_1 INTEGER;
ind1_pa_past_single_c1 INTEGER;
ind1_pa_past_single_c1_c2 INTEGER;
ind1_pa_st_single_c1 INTEGER;
ind1_pa_st_double_c1_c2 INTEGER;
ind1_pa_criteria_lab_3 INTEGER;
ind1_pa_d3_c1 INTEGER;

ct_middlesex_id INTEGER;
ct_hartford_id INTEGER;
ct_new_london_id INTEGER;

BEGIN

--RETRIEVE DATA
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_table_id_by_name('states','Connecticut') INTO connecticut_market_id;
SELECT c.id from counties c where c.state_id=connecticut_market_id and c.name='Middlesex' INTO ct_middlesex_id;
SELECT c.id from counties c where c.state_id=connecticut_market_id and c.name='Hartford' INTO ct_hartford_id;
SELECT c.id from counties c where c.state_id=connecticut_market_id and c.name='New London' INTO ct_new_london_id;

--RETRIEVE RESTRICTIONS
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_1') INTO ind1_pa_diagnosis_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_3') INTO ind1_pa_diagnosis_3;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Clinical','criteria_clinical_1') INTO ind1_pa_clinical_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Unspecified','Criteria Unspecified') INTO ind1_pa_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','QL','criteria_ql_1') INTO ind1_pa_ql;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Age','criteria_age_1') INTO ind1_pa_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_single_c1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','Fail any one: custom_option_1, custom_option_2') INTO ind1_pa_past_single_c1_c2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Single','custom_option_1') INTO ind1_pa_st_single_c1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_c1_c2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Labs','criteria_lab_3') INTO ind1_pa_criteria_lab_3;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Double','drug_3 and custom_option_1') INTO ind1_pa_d3_c1;


--Drill down to Middlesex, CT
expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","criteria_restriction_short_name":"Criteria Unspecified","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_unspecified, drug_2, county_market_type, ct_middlesex_id, expected_rpt_geo_output);

expected_rpt_geo_output='['||
'{"indication_name":"indication_1","indication_abbre":"Ind1","benefit_name":"Pharmacy","criteria_restriction_name":"QL - criteria_ql_1","criteria_restriction_short_name":"criteria_ql_1","market_name":"Middlesex","drug_name":"drug_2","lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":100,"total_medical_lives":0,"total_health_plan_count":1,"total_provider_count":0}'||
']';
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_ql, drug_2, county_market_type, ct_middlesex_id, expected_rpt_geo_output);

--Drill down to Hartford, CT
expected_rpt_geo_output=NULL;
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_diagnosis_3, drug_1, county_market_type, ct_hartford_id, expected_rpt_geo_output);

expected_rpt_geo_output=NULL;
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_age_1, drug_1, county_market_type, ct_hartford_id, expected_rpt_geo_output);

expected_rpt_geo_output=NULL;
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_criteria_lab_3, drug_1, county_market_type, ct_hartford_id, expected_rpt_geo_output);

expected_rpt_geo_output=NULL;
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_d3_c1, drug_2, county_market_type, ct_hartford_id, expected_rpt_geo_output);

--Drill down to New London, CT
expected_rpt_geo_output=NULL;
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_diagnosis_3, drug_1, county_market_type, ct_new_london_id, expected_rpt_geo_output);

expected_rpt_geo_output=NULL;
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_age_1, drug_1, county_market_type, ct_new_london_id, expected_rpt_geo_output);

expected_rpt_geo_output=NULL;
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_criteria_lab_3, drug_1, county_market_type, ct_new_london_id, expected_rpt_geo_output);

expected_rpt_geo_output=NULL;
PERFORM res_rpt_geo_drill_state_validate_data(report_id, pharmacy_benefit_type, county_market_type, ind1_pa_criteria_lab_3, drug_2, county_market_type, ct_new_london_id, expected_rpt_geo_output);


success:=true;
return success;
END
$$ LANGUAGE plpgsql;