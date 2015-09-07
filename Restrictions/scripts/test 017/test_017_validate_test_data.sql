CREATE OR REPLACE FUNCTION restrictions_test_017_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

indication_1 INTEGER;
indication_2 INTEGER;
indication_3 INTEGER;
indication_4 INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;
drug_3 INTEGER;
drug_4 INTEGER;
drug_5 INTEGER;
drug_6 INTEGER;
drug_7 INTEGER;
drug_8 INTEGER;
drug_9 INTEGER;

drug_class_1 INTEGER;
drug_class_2 INTEGER;
drug_class_3 INTEGER;
drug_class_4 INTEGER;
drug_class_5 INTEGER;

ind1_pa_diagnosis_1 INTEGER;
ind1_pa_diagnosis_3 INTEGER;
ind1_pa_clinical_1 INTEGER;
ind1_pa_unspecified INTEGER;
ind1_pa_ql INTEGER;
ind1_pa_age_1 INTEGER;
ind1_pa_st_custom_option_1 INTEGER;
ind1_pa_past_custom_option_1 INTEGER;
ind1_pa_st_double_co_1_co_2 INTEGER;
ind1_pa_past_co_1_co_2 INTEGER;
ind1_m_unspecified INTEGER;
ind1_m_age_1 INTEGER;
ind1_m_st_custom_option_2 INTEGER;
ind1_rep_1_group_single INTEGER;
ind1_rep_1_group_all INTEGER;
ind1_rep_1_group_both INTEGER;
ind3_m_criteria_lab_3 INTEGER;
ind3_pa_criteria_clinical_3 INTEGER;
ind1_rep_1_group_steps INTEGER;

drugs_array INTEGER[];
health_plan_types_array INTEGER[];
restrictions_array INTEGER[];
empty_array INTEGER[];

report1 INTEGER;
report3 INTEGER;
report4 INTEGER;

criteria_report_type CONSTANT INTEGER:=1;
step_report_type CONSTANT INTEGER:=2;

user_id CONSTANT INTEGER:=1;

commercial_hpt INTEGER;
hix_hpt INTEGER;
commercial_bcbs_hpt INTEGER;
employer_hpt INTEGER;
medicare_ma_hpt INTEGER;
medicare_sn_hpt INTEGER;
medicare_pdp_hpt INTEGER;
state_medicare_hpt INTEGER;
dpp_hpt INTEGER;
commercial_medicaid_hpt INTEGER;
union_hpt INTEGER;
municipal_plan_hpt INTEGER;
pbm_hpt INTEGER;
health_plan_type_001 INTEGER;
health_plan_type_002 INTEGER;
health_plan_type_003 INTEGER;

fe_report_1 INTEGER;
fe_report_2 INTEGER;
fe_report_3 INTEGER;
fe_report_4 INTEGER;
summary_table_output VARCHAR;
expected_summary_table_output VARCHAR;

BEGIN



--RETRIEVE HEALTH PLAN TYPES
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;
SELECT common_get_table_id_by_name('health_plan_types','commercial_bcbs') INTO commercial_bcbs_hpt;
SELECT common_get_table_id_by_name('health_plan_types','employer') INTO employer_hpt;
SELECT common_get_table_id_by_name('health_plan_types','medicare_ma') INTO medicare_ma_hpt;
SELECT common_get_table_id_by_name('health_plan_types','medicare_sn') INTO medicare_sn_hpt;
SELECT common_get_table_id_by_name('health_plan_types','medicare_pdp') INTO medicare_pdp_hpt;
SELECT common_get_table_id_by_name('health_plan_types','state_medicare') INTO state_medicare_hpt;
SELECT common_get_table_id_by_name('health_plan_types','dpp') INTO dpp_hpt;
SELECT common_get_table_id_by_name('health_plan_types','commercial_medicaid') INTO commercial_medicaid_hpt;
SELECT common_get_table_id_by_name('health_plan_types','union') INTO union_hpt;
SELECT common_get_table_id_by_name('health_plan_types','municipal_plan') INTO municipal_plan_hpt;
SELECT common_get_table_id_by_name('health_plan_types','pbm') INTO pbm_hpt;
SELECT common_get_table_id_by_name('health_plan_types','HEALTH_PLAN_TYPE_001') INTO health_plan_type_001;
SELECT common_get_table_id_by_name('health_plan_types','HEALTH_PLAN_TYPE_002') INTO health_plan_type_002;
SELECT common_get_table_id_by_name('health_plan_types','HEALTH_PLAN_TYPE_003') INTO health_plan_type_003;


--RETRIEVE REPORTS
SELECT ccr.report_id INTO report1 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_1';
SELECT ccr.report_id INTO report3 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_3';
SELECT ccr.report_id INTO report4 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_4';

--RETRIEVE INDICATIONS
SELECT common_get_table_id_by_name('indications','indication_1') INTO indication_1;
SELECT common_get_table_id_by_name('indications','indication_2') INTO indication_2;
SELECT common_get_table_id_by_name('indications','indication_3') INTO indication_3;
SELECT common_get_table_id_by_name('indications','indication_4') INTO indication_4;


--RETRIEVE DRUGS
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;
SELECT common_get_table_id_by_name('drugs','drug_3') INTO drug_3;
SELECT common_get_table_id_by_name('drugs','drug_4') INTO drug_4;
SELECT common_get_table_id_by_name('drugs','drug_5') INTO drug_5;
SELECT common_get_table_id_by_name('drugs','drug_6') INTO drug_6;
SELECT common_get_table_id_by_name('drugs','drug_7') INTO drug_7;
SELECT common_get_table_id_by_name('drugs','drug_8') INTO drug_8;
SELECT common_get_table_id_by_name('drugs','drug_9') INTO drug_9;


--RETRIEVE DRUG CLASSES
SELECT common_get_table_id_by_name('drug_classes','drug_class_1') INTO drug_class_1;
SELECT common_get_table_id_by_name('drug_classes','drug_class_2') INTO drug_class_2;
SELECT common_get_table_id_by_name('drug_classes','drug_class_3') INTO drug_class_3;
SELECT common_get_table_id_by_name('drug_classes','drug_class_4') INTO drug_class_4;
SELECT common_get_table_id_by_name('drug_classes','drug_class_5') INTO drug_class_5;


--RETRIEVE RESTRICTIONS
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Diagnosis','criteria_diagnosis_3') INTO ind1_pa_diagnosis_3;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Clinical','criteria_clinical_1') INTO ind1_pa_clinical_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Unspecified','Criteria Unspecified') INTO ind1_pa_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','QL','criteria_ql_1') INTO ind1_pa_ql;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA - Age','criteria_age_1') INTO ind1_pa_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Single','custom_option_1') INTO ind1_pa_st_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','Fail any one: custom_option_1, custom_option_2') INTO ind1_pa_past_co_1_co_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','PA/ST - Single','custom_option_1') INTO ind1_pa_past_custom_option_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','ST - Double','custom_option_1 AND  custom_option_2') INTO ind1_pa_st_double_co_1_co_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Unspecified','Criteria Unspecified') INTO ind1_m_unspecified;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','Age','criteria_age_1') INTO ind1_m_age_1;
SELECT common_get_dim_criteria_restriction(indication_1,'Medical','ST - Single','custom_option_2') INTO ind1_m_st_custom_option_2;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','rep_1_group_single','rep_1_group_single') INTO ind1_rep_1_group_single;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','rep_1_group_all','rep_1_group_all') INTO ind1_rep_1_group_all;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','rep_1_group_both','rep_1_group_both') INTO ind1_rep_1_group_both;
SELECT common_get_dim_criteria_restriction(indication_1,'Pharmacy','rep_1_group_steps','rep_1_group_steps') INTO ind1_rep_1_group_steps;
SELECT common_get_dim_criteria_restriction(indication_3,'Medical','Labs','criteria_lab_3') INTO ind3_m_criteria_lab_3;
SELECT common_get_dim_criteria_restriction(indication_3,'Pharmacy','PA - Clinical','criteria_clinical_3') INTO ind3_pa_criteria_clinical_3;




--REPORT#1
drugs_array:= ARRAY[drug_1,drug_2];
health_plan_types_array:= ARRAY[commercial_hpt,hix_hpt];
restrictions_array:= ARRAY[ind1_pa_diagnosis_1, ind1_pa_diagnosis_3,ind1_pa_clinical_1, ind1_pa_unspecified, ind1_pa_ql, ind1_pa_age_1, ind1_pa_past_custom_option_1, ind1_pa_past_co_1_co_2, ind1_pa_st_custom_option_1,ind1_pa_st_double_co_1_co_2, ind1_m_unspecified, ind1_m_age_1,ind1_m_st_custom_option_2,ind1_rep_1_group_steps];
empty_array:= ARRAY[]::integer[];

SELECT create_criteria_report( report1,user_id , criteria_report_type , NULL, NULL, NULL, NULL, NULL,drugs_array, health_plan_types_array, NULL, empty_array, NULL, 'national',restrictions_array, NULL, NULL, NULL) INTO fe_report_1;

--VALIDATE SUMMARY TABLE
--expected_summary_table_output= format('[{"criteria_report_id":%1$s,"drug_id":%2$s,"lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"QL","benefit_name":"Pharmacy","drug_name":"drug_1"},{"criteria_report_id":%1$s,"drug_id":%2$s,"lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","drug_name":"drug_1"},{"criteria_report_id":%1$s,"drug_id":%2$s,"lives":200,"health_plan_count":2,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"PA","benefit_name":"Pharmacy","drug_name":"drug_1"},{"criteria_report_id":%1$s,"drug_id":%2$s,"lives":300,"health_plan_count":3,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","drug_name":"drug_1"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"QL","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":200,"health_plan_count":2,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"ST","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":200,"health_plan_count":2,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":200,"health_plan_count":2,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"PA","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":300,"health_plan_count":3,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":null,"lives":null,"health_plan_count":null,"provider_count":null,"total_pharmacy_lives":300,"total_medical_lives":null,"total_health_plan_count":3,"total_provider_count":null,"benefit_restriction_name":null,"benefit_name":"Pharmacy","drug_name":null},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":50,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":2,"benefit_restriction_name":"ST","benefit_name":"Medical","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":100,"health_plan_count":0,"provider_count":2,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":2,"benefit_restriction_name":"Medical","benefit_name":"Medical","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":null,"lives":null,"health_plan_count":null,"provider_count":null,"total_pharmacy_lives":null,"total_medical_lives":100,"total_health_plan_count":null,"total_provider_count":2,"benefit_restriction_name":null,"benefit_name":"Medical","drug_name":null}]',fe_report_1, drug_1,drug_2);
--PERFORM res_rpt_summary_table_validate_data(fe_report_1,expected_summary_table_output);

expected_summary_table_output= format('[{"criteria_report_id":%1$s,"drug_id":%2$s,"lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"QL","benefit_name":"Pharmacy","drug_name":"drug_1"},{"criteria_report_id":%1$s,"drug_id":%2$s,"lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","drug_name":"drug_1"},{"criteria_report_id":%1$s,"drug_id":%2$s,"lives":200,"health_plan_count":2,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"PA","benefit_name":"Pharmacy","drug_name":"drug_1"},{"criteria_report_id":%1$s,"drug_id":%2$s,"lives":300,"health_plan_count":3,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","drug_name":"drug_1"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"QL","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":200,"health_plan_count":2,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"ST","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":100,"health_plan_count":1,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"PA/ST","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":200,"health_plan_count":2,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"PA","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":300,"health_plan_count":3,"provider_count":0,"total_pharmacy_lives":300,"total_medical_lives":0,"total_health_plan_count":3,"total_provider_count":0,"benefit_restriction_name":"Pharmacy","benefit_name":"Pharmacy","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":null,"lives":null,"health_plan_count":null,"provider_count":null,"total_pharmacy_lives":300,"total_medical_lives":null,"total_health_plan_count":3,"total_provider_count":null,"benefit_restriction_name":null,"benefit_name":"Pharmacy","drug_name":null},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":100,"health_plan_count":0,"provider_count":1,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":2,"benefit_restriction_name":"ST","benefit_name":"Medical","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":%3$s,"lives":100,"health_plan_count":0,"provider_count":2,"total_pharmacy_lives":0,"total_medical_lives":100,"total_health_plan_count":0,"total_provider_count":2,"benefit_restriction_name":"Medical","benefit_name":"Medical","drug_name":"drug_2"},{"criteria_report_id":%1$s,"drug_id":null,"lives":null,"health_plan_count":null,"provider_count":null,"total_pharmacy_lives":null,"total_medical_lives":100,"total_health_plan_count":null,"total_provider_count":2,"benefit_restriction_name":null,"benefit_name":"Medical","drug_name":null}]',fe_report_1, drug_1,drug_2);
PERFORM res_rpt_summary_table_validate_data(fe_report_1,expected_summary_table_output);

--REPORT#2
health_plan_types_array:= ARRAY[commercial_hpt,hix_hpt,commercial_bcbs_hpt,employer_hpt,medicare_ma_hpt,medicare_sn_hpt,medicare_pdp_hpt,state_medicare_hpt,dpp_hpt,commercial_medicaid_hpt,union_hpt,municipal_plan_hpt,pbm_hpt,health_plan_type_001,health_plan_type_002,health_plan_type_003];
restrictions_array:= ARRAY[ind1_pa_diagnosis_1,ind1_pa_clinical_1, ind1_pa_unspecified, ind1_pa_ql, ind1_m_unspecified, ind1_m_age_1];
SELECT create_criteria_report( report1,user_id , criteria_report_type , NULL, NULL, NULL, NULL, NULL,drugs_array, health_plan_types_array, NULL, empty_array, NULL, 'national', restrictions_array, NULL, NULL, NULL) INTO fe_report_2;

--REPORT#3 --
restrictions_array:= ARRAY[ind1_rep_1_group_single,ind1_rep_1_group_all,ind1_rep_1_group_both];
SELECT create_criteria_report( report1,user_id , criteria_report_type , NULL, NULL, NULL, NULL, NULL,drugs_array, health_plan_types_array,NULL, empty_array, NULL, 'national', restrictions_array, NULL, NULL, NULL) INTO fe_report_3;

--REPORT#4
drugs_array:= ARRAY[drug_1,drug_2,drug_9,drug_3];
health_plan_types_array:= ARRAY[commercial_hpt,commercial_bcbs_hpt, commercial_medicaid_hpt];
restrictions_array:= ARRAY[ind3_pa_criteria_clinical_3,ind3_m_criteria_lab_3, ind1_pa_clinical_1, ind1_pa_unspecified, ind1_pa_ql,ind1_pa_age_1];
SELECT create_criteria_report( report3, user_id , criteria_report_type , NULL, NULL, NULL, NULL, NULL,drugs_array, health_plan_types_array, NULL, empty_array, NULL, 'national',restrictions_array, NULL, NULL, NULL) INTO fe_report_4;


success=true;
return success;
END
$$ LANGUAGE plpgsql;