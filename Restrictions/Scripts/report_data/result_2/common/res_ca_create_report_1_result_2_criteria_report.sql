CREATE OR REPLACE FUNCTION res_ca_create_report_1_result_2_criteria_report() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

indication_1 INTEGER;

criteria_report_type CONSTANT INTEGER:=1;
county_geo_type_id CONSTANT INTEGER:=1;

drug_1_id INTEGER;
drug_2_id INTEGER;
criteria_report_id INTEGER;

new_report_id INTEGER;
existing_client_id INTEGER;
existing_custom_account_id INTEGER;

ind1_m_unspecified INTEGER;
ind1_m_age_1 INTEGER;
ind1_m_st_custom_option_2 INTEGER;
ind1_m_criteria_diagnosis_3 INTEGER;

restrictions_array INTEGER[];

drugs CONSTANT VARCHAR:='drugs';
massachusetts_state_id INTEGER;
county_ids INTEGER[];

BEGIN

--GET the input data

--RETRIEVE INDICATIONS
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

--RETRIEVE DRUGS
SELECT common_get_table_id_by_name(drugs, 'drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name(drugs, 'drug_2') INTO drug_2_id;

--RETRIEVE RESTRICTIONS
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Unspecified','Criteria Unspecified') INTO ind1_m_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Age','criteria_age_1') INTO ind1_m_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Diagnosis','criteria_diagnosis_3') INTO ind1_m_criteria_diagnosis_3;

restrictions_array:= ARRAY[ind1_m_unspecified, ind1_m_age_1, ind1_m_st_custom_option_2, ind1_m_criteria_diagnosis_3];

SELECT report_id from criteria_restriction_reports where report_name = 'report_1' INTO new_report_id;
SELECT common_get_table_id_by_name('clients', 'client_2') INTO existing_client_id;
SELECT custom_account_id from custom_accounts where name = 'Custom_Account_2' and client_id = existing_client_id INTO existing_custom_account_id;

SELECT common_get_table_id_by_name('states','Massachusetts') INTO massachusetts_state_id;
SELECT array(select id from counties where state_id=massachusetts_state_id) INTO county_ids;

SELECT create_criteria_report(new_report_id,0,criteria_report_type,0,county_geo_type_id,FALSE,FALSE,FALSE,ARRAY[drug_1_id,drug_2_id],ARRAY[]::integer[],'County',ARRAY[]::integer[],existing_custom_account_id,restrictions_array,NULL,NULL,county_ids) INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;