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
ind1_m_criteria_lab_3 INTEGER;
ind3_m_criteria_lab_3 INTEGER;
ind3_pa_criteria_clinical_3 INTEGER;

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
SELECT hpt.id INTO commercial_hpt FROM health_plan_types hpt WHERE hpt.name='commercial';
SELECT hpt.id INTO hix_hpt FROM health_plan_types hpt WHERE hpt.name='hix';
SELECT hpt.id INTO commercial_bcbs_hpt FROM health_plan_types hpt WHERE hpt.name='commercial_bcbs';
SELECT hpt.id INTO employer_hpt FROM health_plan_types hpt WHERE hpt.name='employer';
SELECT hpt.id INTO medicare_ma_hpt FROM health_plan_types hpt WHERE hpt.name='medicare_ma';
SELECT hpt.id INTO medicare_sn_hpt FROM health_plan_types hpt WHERE hpt.name='medicare_sn';
SELECT hpt.id INTO medicare_pdp_hpt FROM health_plan_types hpt WHERE hpt.name='medicare_pdp';
SELECT hpt.id INTO state_medicare_hpt FROM health_plan_types hpt WHERE hpt.name='state_medicare';
SELECT hpt.id INTO dpp_hpt FROM health_plan_types hpt WHERE hpt.name='dpp';
SELECT hpt.id INTO commercial_medicaid_hpt FROM health_plan_types hpt WHERE hpt.name='commercial_medicaid';
SELECT hpt.id INTO union_hpt FROM health_plan_types hpt WHERE hpt.name='union';
SELECT hpt.id INTO municipal_plan_hpt FROM health_plan_types hpt WHERE hpt.name='municipal_plan';
SELECT hpt.id INTO pbm_hpt FROM health_plan_types hpt WHERE hpt.name='pbm';
SELECT hpt.id INTO health_plan_type_001 FROM health_plan_types hpt WHERE hpt.name='HEALTH_PLAN_TYPE_001';
SELECT hpt.id INTO health_plan_type_002 FROM health_plan_types hpt WHERE hpt.name='HEALTH_PLAN_TYPE_002';
SELECT hpt.id INTO health_plan_type_003 FROM health_plan_types hpt WHERE hpt.name='HEALTH_PLAN_TYPE_003';

--RETRIEVE REPORTS
SELECT ccr.report_id INTO report1 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_1';
SELECT ccr.report_id INTO report3 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_3';
SELECT ccr.report_id INTO report4 FROM criteria_restriction_reports ccr WHERE ccr.report_name='report_4';

--RETRIEVE INDICATIONS
SELECT i.id INTO indication_1 FROM indications i WHERE i.name='indication_1';
SELECT i.id INTO indication_2 FROM indications i WHERE i.name='indication_2';
SELECT i.id INTO indication_3 FROM indications i WHERE i.name='indication_3';
SELECT i.id INTO indication_4 FROM indications i WHERE i.name='indication_4';

--RETRIEVE DRUGS
SELECT d.id INTO drug_1 FROM drugs d WHERE d.name='drug_1';
SELECT d.id INTO drug_2 FROM drugs d WHERE d.name='drug_2';
SELECT d.id INTO drug_3 FROM drugs d WHERE d.name='drug_3';
SELECT d.id INTO drug_4 FROM drugs d WHERE d.name='drug_4';
SELECT d.id INTO drug_5 FROM drugs d WHERE d.name='drug_5';
SELECT d.id INTO drug_6 FROM drugs d WHERE d.name='drug_6';
SELECT d.id INTO drug_7 FROM drugs d WHERE d.name='drug_7';
SELECT d.id INTO drug_8 FROM drugs d WHERE d.name='drug_8';
SELECT d.id INTO drug_9 FROM drugs d WHERE d.name='drug_9';

--RETRIEVE DRUG CLASSES
SELECT dc.id INTO drug_class_1 FROM drug_classes dc WHERE dc.name='drug_class_1';
SELECT dc.id INTO drug_class_2 FROM drug_classes dc WHERE dc.name='drug_class_2';
SELECT dc.id INTO drug_class_3 FROM drug_classes dc WHERE dc.name='drug_class_3';
SELECT dc.id INTO drug_class_4 FROM drug_classes dc WHERE dc.name='drug_class_4';
SELECT dc.id INTO drug_class_5 FROM drug_classes dc WHERE dc.name='drug_class_5';

--RETRIEVE RESTRICTIONS
SELECT  dc.id INTO ind1_pa_diagnosis_1 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='PA - Diagnosis'  AND dc.criteria_restriction_short_name='criteria_diagnosis_1';
SELECT  dc.id INTO ind1_pa_diagnosis_3 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='PA - Diagnosis'  AND dc.criteria_restriction_short_name='criteria_diagnosis_3';
SELECT  dc.id INTO ind1_pa_clinical_1 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='PA - Clinical'  AND dc.criteria_restriction_short_name='criteria_clinical_1';
SELECT  dc.id INTO ind1_pa_unspecified FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='PA - Unspecified' AND dc.criteria_restriction_short_name='Criteria Unspecified';
SELECT  dc.id INTO ind1_pa_ql FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='QL' AND dc.criteria_restriction_short_name='criteria_ql_1';
SELECT  dc.id INTO ind1_pa_age_1 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='PA - Age' AND dc.criteria_restriction_short_name='criteria_age_1';
SELECT  dc.id INTO ind1_pa_st_custom_option_1 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='ST - Single' AND dc.criteria_restriction_short_name='custom_option_1';
SELECT  dc.id INTO ind1_pa_past_co_1_co_2 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='PA/ST - Single' AND dc.criteria_restriction_short_name='Fail any one: custom_option_1, custom_option_2';
SELECT  dc.id INTO ind1_pa_past_custom_option_1 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='PA/ST - Single' AND dc.criteria_restriction_short_name='custom_option_1';
SELECT  dc.id INTO ind1_pa_st_double_co_1_co_2 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='ST - Double' AND dc.criteria_restriction_short_name='custom_option_1 AND  custom_option_2';
SELECT  dc.id INTO ind1_m_unspecified FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Medical' AND dc.restriction_name='Unspecified' AND dc.criteria_restriction_short_name='Criteria Unspecified';
SELECT  dc.id INTO ind1_m_age_1 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Medical' AND dc.restriction_name='Age' AND dc.criteria_restriction_short_name='criteria_age_1';
SELECT  dc.id INTO ind1_m_st_custom_option_2 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Medical' AND dc.restriction_name='ST - Single' AND dc.criteria_restriction_short_name='custom_option_2';
SELECT  dc.id INTO ind1_rep_1_group_single FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='rep_1_group_single' AND dc.criteria_restriction_short_name='rep_1_group_single';
SELECT  dc.id INTO ind1_rep_1_group_all FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='rep_1_group_all' AND dc.criteria_restriction_short_name='rep_1_group_all';
SELECT  dc.id INTO ind1_rep_1_group_both FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='rep_1_group_both' AND dc.criteria_restriction_short_name='rep_1_group_both';
SELECT  dc.id INTO ind1_m_criteria_lab_3 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_1 AND dc.benefit_name='Medical' AND dc.restriction_name='Labs' AND dc.criteria_restriction_short_name='criteria_lab_3';
SELECT  dc.id INTO ind3_m_criteria_lab_3 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_3 AND dc.benefit_name='Medical' AND dc.restriction_name='Labs' AND dc.criteria_restriction_short_name='criteria_lab_3';
SELECT  dc.id INTO ind3_pa_criteria_clinical_3 FROM dim_criteria_restriction dc WHERE dc.indication_id = indication_3 AND dc.benefit_name='Pharmacy' AND dc.restriction_name='PA - Clinical' AND dc.criteria_restriction_short_name='criteria_clinical_3';


--REPORT#1
drugs_array:= ARRAY[drug_1,drug_2];
health_plan_types_array:= ARRAY[commercial_hpt,hix_hpt];
restrictions_array:= ARRAY[ind1_pa_diagnosis_1, ind1_pa_diagnosis_3,ind1_pa_clinical_1, ind1_pa_unspecified, ind1_pa_ql, ind1_pa_age_1, ind1_pa_past_custom_option_1, ind1_pa_past_co_1_co_2, ind1_pa_st_custom_option_1,ind1_pa_st_double_co_1_co_2, ind1_m_unspecified, ind1_m_age_1,ind1_m_st_custom_option_2];
empty_array:= ARRAY[]::integer[];

SELECT create_criteria_report( report1,user_id , criteria_report_type , NULL, NULL, NULL, NULL, NULL,drugs_array, health_plan_types_array, NULL, empty_array, NULL, 'national',restrictions_array, NULL, NULL, NULL) INTO fe_report_1;

--VALIDATE SUMMARY TABLE
expected_summary_table_output= format('[ { "criteria_report_id": %1$s, "drug_id": %2$s, "lives": 100, "health_plan_count": 1, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "QL", "benefit_name": "Pharmacy", "drug_name": "drug_1" }, { "criteria_report_id": %1$s, "drug_id": %2$s, "lives": 100, "health_plan_count": 1, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "PA/ST", "benefit_name": "Pharmacy", "drug_name": "drug_1" }, { "criteria_report_id": %1$s, "drug_id": %2$s, "lives": 200, "health_plan_count": 2, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "PA", "benefit_name": "Pharmacy", "drug_name": "drug_1" }, { "criteria_report_id": %1$s, "drug_id": %2$s, "lives": 300, "health_plan_count": 3, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "Pharmacy", "benefit_name": "Pharmacy", "drug_name": "drug_1" }, { "criteria_report_id": %1$s, "drug_id": %3$s, "lives": 100, "health_plan_count": 1, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "QL", "benefit_name": "Pharmacy", "drug_name": "drug_2" }, { "criteria_report_id": %1$s, "drug_id": %3$s, "lives": 200, "health_plan_count": 2, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "ST", "benefit_name": "Pharmacy", "drug_name": "drug_2" }, { "criteria_report_id": %1$s, "drug_id": %3$s, "lives": 200, "health_plan_count": 2, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "PA/ST", "benefit_name": "Pharmacy", "drug_name": "drug_2" }, { "criteria_report_id": %1$s, "drug_id": %3$s, "lives": 200, "health_plan_count": 2, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "PA", "benefit_name": "Pharmacy", "drug_name": "drug_2" }, { "criteria_report_id": %1$s, "drug_id": %3$s, "lives": 300, "health_plan_count": 3, "provider_count": 0, "total_pharmacy_lives": 300, "total_medical_lives": 0, "total_health_plan_count": 3, "total_provider_count": 0, "benefit_restriction_name": "Pharmacy", "benefit_name": "Pharmacy", "drug_name": "drug_2" }, { "criteria_report_id": %1$s, "drug_id": null, "lives": null, "health_plan_count": null, "provider_count": null, "total_pharmacy_lives": 300, "total_medical_lives": null, "total_health_plan_count": 3, "total_provider_count": null, "benefit_restriction_name": null, "benefit_name": "Pharmacy", "drug_name": null }, { "criteria_report_id": %1$s, "drug_id": %3$s, "lives": 50, "health_plan_count": 0, "provider_count": 1, "total_pharmacy_lives": 0, "total_medical_lives": 100, "total_health_plan_count": 0, "total_provider_count": 2, "benefit_restriction_name": "ST", "benefit_name": "Medical", "drug_name": "drug_2" }, { "criteria_report_id": %1$s, "drug_id": %3$s, "lives": 100, "health_plan_count": 0, "provider_count": 2, "total_pharmacy_lives": 0, "total_medical_lives": 100, "total_health_plan_count": 0, "total_provider_count": 2, "benefit_restriction_name": "Medical", "benefit_name": "Medical", "drug_name": "drug_2" }, { "criteria_report_id": %1$s, "drug_id": null, "lives": null, "health_plan_count": null, "provider_count": null, "total_pharmacy_lives": null, "total_medical_lives": 100, "total_health_plan_count": null, "total_provider_count": 2, "benefit_restriction_name": null, "benefit_name": "Medical", "drug_name": null } ]',fe_report_1, drug_1,drug_2);
PERFORM validate_summary_table(fe_report_1,expected_summary_table_output);

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