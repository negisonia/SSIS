CREATE OR REPLACE FUNCTION res_ca_create_report_1_result_3_criteria_report() --FRONT END
RETURNS INTEGER AS $$
DECLARE

indication_1 INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;

rep_1_group_1_pa INTEGER;
rep_1_group_3_pa INTEGER;
rep_1_group_1_m INTEGER;
rep_1_group_3_m INTEGER;

drugs_array INTEGER[];
health_plan_types_array INTEGER[];
restrictions_array INTEGER[];
empty_array INTEGER[];

report1 INTEGER;
fe_report_1 INTEGER;
existing_client_id INTEGER;
existing_custom_account_id INTEGER;

criteria_report_type CONSTANT INTEGER:=1;
state_geo_type_id CONSTANT INTEGER:=2;

user_id CONSTANT INTEGER:=1;

commercial_hpt INTEGER;
hix_hpt INTEGER;

state_ids INTEGER[];

BEGIN

--RETRIEVE HEALTH PLAN TYPES
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;

--RETRIEVE REPORTS
SELECT ccr.report_id INTO report1 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_1';

--RETRIEVE INDICATIONS
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;

--RETRIEVE DRUGS
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;

SELECT array(select distinct s.id FROM states s WHERE s.is_active=true) INTO state_ids;

--RETRIEVE RESTRICTIONS

SELECT common_get_custom_dim_criteria(indication_1, 'Pharmacy', 'rep_1_group_1', 'rep_1_group_1',6,3) INTO rep_1_group_1_pa;
SELECT common_get_custom_dim_criteria(indication_1, 'Pharmacy', 'rep_1_group_3', 'rep_1_group_3',6,3) INTO rep_1_group_3_pa;
SELECT common_get_custom_dim_criteria(indication_1, 'Medical', 'rep_1_group_1', 'rep_1_group_1',2,3) INTO rep_1_group_1_m;
SELECT common_get_custom_dim_criteria(indication_1, 'Medical', 'rep_1_group_3', 'rep_1_group_3',2,3) INTO rep_1_group_3_m;

SELECT common_get_table_id_by_name('clients', 'client_2') INTO existing_client_id;
SELECT custom_account_id from custom_accounts where name = 'Custom_Account_2' and client_id = existing_client_id INTO existing_custom_account_id;

--REPORT#1
drugs_array:= ARRAY[drug_1,drug_2];
restrictions_array:= ARRAY[rep_1_group_1_pa,rep_1_group_3_pa,rep_1_group_1_m,rep_1_group_3_m];
empty_array:= ARRAY[]::integer[];

SELECT create_criteria_report( report1, user_id ,criteria_report_type, NULL, state_geo_type_id, TRUE, FALSE, FALSE, drugs_array, empty_array, 'State', empty_array, existing_custom_account_id, restrictions_array, state_ids, NULL, NULL) INTO fe_report_1;
return fe_report_1;
END
$$ LANGUAGE plpgsql;