CREATE OR REPLACE FUNCTION res_create_report_1_result_5_criteria_report() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

indication_1 INTEGER;

criteria_report_type CONSTANT INTEGER:=1;
msa_geo_type_id CONSTANT INTEGER:=3;

drug_1_id INTEGER;
drug_2_id INTEGER;
criteria_report_id INTEGER;

new_report_id INTEGER;
existing_client_id INTEGER;
existing_custom_account_id INTEGER;

ind1_pa_diagnosis_1 INTEGER;
ind1_pa_diagnosis_3 INTEGER;
ind1_pa_clinical_1 INTEGER;
ind1_pa_unspecified INTEGER;
ind1_pa_ql_1 INTEGER;
ind1_pa_age_1 INTEGER;
ind1_pa_st_custom_option_1 INTEGER;
ind1_pa_past_custom_option_1 INTEGER;
ind1_pa_st_double_co_1_co_2 INTEGER;
ind1_pa_past_co_1_co_2 INTEGER;

restrictions_array INTEGER[];
health_plan_types_array INTEGER[];

commercial_hpt INTEGER;
hix_hpt INTEGER;

drugs CONSTANT VARCHAR:='drugs';
connecticut_state_id INTEGER;
msa_ids INTEGER[];

BEGIN

--GET the input data
--RETRIEVE HEALTH PLAN TYPES
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;


--RETRIEVE INDICATIONS
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

--RETRIEVE DRUGS
SELECT common_get_table_id_by_name(drugs, 'drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name(drugs, 'drug_2') INTO drug_2_id;

--RETRIEVE RESTRICTIONS
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_1') INTO ind1_pa_diagnosis_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_3') INTO ind1_pa_diagnosis_3;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Clinical','criteria_clinical_1') INTO ind1_pa_clinical_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Unspecified','Criteria Unspecified') INTO ind1_pa_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','QL','criteria_ql_1') INTO ind1_pa_ql_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Age','criteria_age_1') INTO ind1_pa_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Single','custom_option_1') INTO ind1_pa_st_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','Fail any one: custom_option_1, custom_option_2') INTO ind1_pa_past_co_1_co_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_co_1_co_2;

restrictions_array:= ARRAY[ind1_pa_diagnosis_1, ind1_pa_diagnosis_3, ind1_pa_clinical_1, ind1_pa_unspecified, ind1_pa_ql_1, ind1_pa_age_1, ind1_pa_st_custom_option_1, ind1_pa_past_co_1_co_2, ind1_pa_past_custom_option_1, ind1_pa_st_double_co_1_co_2];

SELECT report_id from criteria_restriction_reports where report_name = 'report_1' INTO new_report_id;
SELECT common_get_table_id_by_name('clients', 'client_2') INTO existing_client_id;
SELECT custom_account_id from custom_accounts where name = 'Custom_Account_2' and client_id = existing_client_id INTO existing_custom_account_id;

health_plan_types_array:= ARRAY[commercial_hpt,hix_hpt];

SELECT common_get_table_id_by_name('states','Connecticut') INTO connecticut_state_id;
SELECT array(select distinct(metro_stat_area_id) from counties where state_id=connecticut_state_id) INTO msa_ids;

SELECT create_criteria_report(new_report_id,0,criteria_report_type,0,msa_geo_type_id,FALSE,FALSE,FALSE,ARRAY[drug_1_id,drug_2_id],health_plan_types_array,'MetroStatArea',ARRAY[]::integer[],NULL,restrictions_array,NULL,msa_ids,NULL) INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;