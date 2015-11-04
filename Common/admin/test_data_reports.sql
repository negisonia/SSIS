CREATE OR REPLACE FUNCTION  test_data_reports()--ADMIN DB
RETURNS BOOLEAN AS $$
DECLARE

client_1 INTEGER;
client_2 INTEGER;
client_3 INTEGER;
client_4 INTEGER;

rep_1_group_1 INTEGER;
rep_1_group_2 INTEGER;
rep_1_group_3 INTEGER;
rep_1_group_single INTEGER;
rep_1_group_all INTEGER;
rep_1_group_both INTEGER;
rep_1_group_steps INTEGER;
rep_3_group_1 INTEGER;
rep_3_group_2_ind_1 INTEGER;
rep_3_group_2_ind_3 INTEGER;
rep_4_group_1 INTEGER;

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
ind1_m_criteria_unspecified INTEGER;
ind1_m_criteria_age_1 INTEGER;
ind1_m_st_single_c2 INTEGER;
ind3_m_criteria_lab_3 INTEGER;
ind1_m_criteria_criteria_diagnosis_3 INTEGER;
ind3_pa_criteria_clinical_3 INTEGER;
ind3_pa_criteria_clinical_1 INTEGER;
ind3_pa_criteria_age_1 INTEGER;
ind3_m_criteria_age_1 INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;
drug_3 INTEGER;
drug_4 INTEGER;
drug_5 INTEGER;
drug_6 INTEGER;
drug_7 INTEGER;
drug_8 INTEGER;
drug_9 INTEGER;

indication_1 INTEGER;
indication_2 INTEGER;
indication_3 INTEGER;

report_1 INTEGER;
report_2 INTEGER;
report_3 INTEGER;
report_4 INTEGER;

success BOOLEAN DEFAULT FALSE;
BEGIN

--RETRIEVE CLIENT IDS
SELECT c.id INTO client_1 FROM clients c WHERE c.name='client_1';
SELECT c.id INTO client_2 FROM clients c WHERE c.name='client_2';
SELECT c.id INTO client_3 FROM clients c WHERE c.name='client_3';
SELECT c.id INTO client_4 FROM clients c WHERE c.name='client_4';

--RETRIEVE CUSTOM GROUP IDS
SELECT ccg.id INTO rep_1_group_1 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_1' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_2 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_2' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_3 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_3' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_single FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_single' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_all FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_all' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_both FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_both' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_steps FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_steps' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_3_group_1 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_3_group_1' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_3_group_2_ind_1 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_3_group_2' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_3_group_2_ind_3 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_3_group_2' and ccg.indication_field_name='indication_3';
SELECT ccg.id INTO rep_4_group_1 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_4_group_1' and ccg.indication_field_name='indication_1';


--RETRIEVE DRUGS
SELECT di.drug_id INTO drug_1 FROM drug_indications di WHERE di.drug_name='drug_1' LIMIT 1;
SELECT di.drug_id INTO drug_2 FROM drug_indications di WHERE di.drug_name='drug_2' LIMIT 1;
SELECT di.drug_id INTO drug_3 FROM drug_indications di WHERE di.drug_name='drug_3' LIMIT 1;
SELECT di.drug_id INTO drug_4 FROM drug_indications di WHERE di.drug_name='drug_4' LIMIT 1;
SELECT di.drug_id INTO drug_5 FROM drug_indications di WHERE di.drug_name='drug_5'LIMIT 1;
SELECT di.drug_id INTO drug_6 FROM drug_indications di WHERE di.drug_name='drug_6' LIMIT 1;
SELECT di.drug_id INTO drug_7 FROM drug_indications di WHERE di.drug_name='drug_7' LIMIT 1;
SELECT di.drug_id INTO drug_8 FROM drug_indications di WHERE di.drug_name='drug_8' LIMIT 1;
SELECT di.drug_id INTO drug_9 FROM drug_indications di WHERE di.drug_name='drug_9' LIMIT 1;


--RETRIEVE INDICATIONS
SELECT di.indication_id INTO indication_1 FROM drug_indications di WHERE di.indication_name='indication_1' LIMIT 1;
SELECT di.indication_id INTO indication_2 FROM drug_indications di WHERE di.indication_name='indication_2' LIMIT 1;
SELECT di.indication_id INTO indication_3 FROM drug_indications di WHERE di.indication_name='indication_3' LIMIT 1;

--RETRIEVE CRITERIA RESTRICTIONS
SELECT cr.id INTO ind1_pa_diagnosis_1 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='criteria_diagnosis_1';
SELECT cr.id INTO ind1_pa_diagnosis_3 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='criteria_diagnosis_3';
SELECT cr.id INTO ind1_pa_clinical_1 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='criteria_clinical_1';
SELECT cr.id INTO ind1_pa_unspecified FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='Criteria Unspecified';
SELECT cr.id INTO ind1_pa_ql FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='criteria_ql_1';
SELECT cr.id INTO ind1_pa_age_1 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='criteria_age_1';
SELECT cr.id INTO ind1_pa_past_single_c1 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='custom_option_1' and cr.criteria_restriction_name='PA/ST - Single - custom_option_1' and cr.restriction_name='PA/ST - Single';
SELECT cr.id INTO ind1_pa_past_single_c1_c2 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='Fail any one: custom_option_1, custom_option_2' and cr.criteria_restriction_name='PA/ST - Single - Fail any one: custom_option_1, custom_option_2' and cr.restriction_name='PA/ST - Single';
SELECT cr.id INTO ind1_pa_st_single_c1 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='custom_option_1' and cr.criteria_restriction_name='ST - Single - custom_option_1' and cr.restriction_name='ST - Single';
SELECT cr.id INTO ind1_pa_st_double_c1_c2 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='custom_option_1 AND  custom_option_2' AND cr.criteria_restriction_name='ST - Double - custom_option_1 AND  custom_option_2' and cr.restriction_name='ST - Double';
SELECT cr.id INTO ind1_m_criteria_unspecified FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Medical' AND cr.criteria_restriction_short_name='Criteria Unspecified';
SELECT cr.id INTO ind1_m_criteria_age_1 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Medical' AND cr.criteria_restriction_short_name='criteria_age_1';
SELECT cr.id INTO ind1_m_st_single_c2 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Medical' AND  cr.criteria_restriction_short_name='custom_option_2' AND cr.criteria_restriction_name='ST - Single - custom_option_2' and cr.restriction_name='ST - Single';
SELECT cr.id INTO ind3_m_criteria_lab_3 FROM criteria_restriction cr WHERE cr.indication_id=indication_3 AND cr.benefit_name='Medical' AND cr.criteria_restriction_short_name='criteria_lab_3';
SELECT cr.id INTO ind1_m_criteria_criteria_diagnosis_3 FROM criteria_restriction cr WHERE cr.indication_id=indication_1 AND cr.benefit_name='Medical' AND cr.criteria_restriction_short_name='criteria_diagnosis_3';
SELECT cr.id INTO ind3_pa_criteria_clinical_3 FROM criteria_restriction cr WHERE cr.indication_id=indication_3 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='criteria_clinical_3';
SELECT cr.id INTO ind3_pa_criteria_clinical_1 FROM criteria_restriction cr WHERE cr.indication_id=indication_3 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='criteria_clinical_1';
SELECT cr.id INTO ind3_pa_criteria_age_1 FROM criteria_restriction cr WHERE cr.indication_id=indication_3 AND cr.benefit_name='Pharmacy' AND cr.criteria_restriction_short_name='criteria_age_1';
SELECT cr.id INTO ind3_m_criteria_age_1 FROM criteria_restriction cr WHERE cr.indication_id=indication_3 AND cr.benefit_name='Medical' AND cr.criteria_restriction_short_name='criteria_age_1';


--CREATE REPORT#1
SELECT create_report('report_1','report_1',TRUE) INTO report_1;
SELECT create_report('report_2','report_2',TRUE) INTO report_2;
SELECT create_report('report_3','report_3',TRUE) INTO report_3;
SELECT create_report('report_4','report_4',TRUE) INTO report_4;

-------CREATE REPORT_DRUGS
--DRUGS REPORT #1
PERFORM common_create_report_drug(report_1, indication_1, drug_1);
PERFORM common_create_report_drug(report_1, indication_1, drug_2);
PERFORM common_create_report_drug(report_1, indication_1, drug_3);
PERFORM common_create_report_drug(report_1, indication_1, drug_4);

--DRUGS REPORT #2
PERFORM common_create_report_drug(report_2, indication_2, drug_5);
PERFORM common_create_report_drug(report_2, indication_2, drug_6);
PERFORM common_create_report_drug(report_2, indication_2, drug_7);

--DRUGS REPORT #3
PERFORM common_create_report_drug(report_3, indication_1, drug_1);
PERFORM common_create_report_drug(report_3, indication_1, drug_2);
PERFORM common_create_report_drug(report_3, indication_1, drug_3);
PERFORM common_create_report_drug(report_3, indication_1, drug_3);
PERFORM common_create_report_drug(report_3, indication_3, drug_9);
PERFORM common_create_report_drug(report_3, indication_3, drug_1);
PERFORM common_create_report_drug(report_3, indication_3, drug_2);
PERFORM common_create_report_drug(report_3, indication_3, drug_3);


--DRUGS REPORT #4
PERFORM common_create_report_drug(report_4, indication_1, drug_1);
PERFORM common_create_report_drug(report_4, indication_1, drug_2);

-------CREATE REPORT CLIENTS
--CLIENTS REPORT #1
PERFORM common_create_report_client(report_1, client_1);
PERFORM common_create_report_client(report_1, client_2);

--CLIENTS REPORT #2
PERFORM common_create_report_client(report_2, client_2);

--CLIENTS REPORT #3
PERFORM common_create_report_client(report_3, client_1);
PERFORM common_create_report_client(report_3, client_3);

--CLIENTS REPORT #4
PERFORM common_create_report_client(report_4, client_4);

-------CREATE REPORT CRITERIAS
--CRITERIAS REPORT #1
PERFORM common_create_report_criteria(report_1, ind1_pa_diagnosis_1);
PERFORM common_create_report_criteria(report_1, ind1_pa_diagnosis_3);
PERFORM common_create_report_criteria(report_1, ind1_pa_clinical_1);
PERFORM common_create_report_criteria(report_1, ind1_pa_unspecified);
PERFORM common_create_report_criteria(report_1, ind1_pa_ql);
PERFORM common_create_report_criteria(report_1, ind1_pa_age_1);
PERFORM common_create_report_criteria(report_1, ind1_pa_past_single_c1);
PERFORM common_create_report_criteria(report_1, ind1_pa_past_single_c1_c2);
PERFORM common_create_report_criteria(report_1, ind1_pa_st_single_c1);
PERFORM common_create_report_criteria(report_1, ind1_pa_st_double_c1_c2);
PERFORM common_create_report_criteria(report_1, ind1_m_criteria_unspecified);
PERFORM common_create_report_criteria(report_1, ind1_m_criteria_age_1);
PERFORM common_create_report_criteria(report_1, ind1_m_st_single_c2);
PERFORM common_create_report_criteria(report_1, ind1_m_criteria_criteria_diagnosis_3);

--CRITERIAS REPORT #3
PERFORM common_create_report_criteria(report_3, ind3_m_criteria_lab_3);
PERFORM common_create_report_criteria(report_3, ind3_pa_criteria_clinical_3);
PERFORM common_create_report_criteria(report_3, ind1_pa_clinical_1);
PERFORM common_create_report_criteria(report_3, ind1_pa_unspecified);
PERFORM common_create_report_criteria(report_3, ind1_pa_ql);
PERFORM common_create_report_criteria(report_3, ind1_pa_age_1);

--CRITERIAS REPORT #4
PERFORM common_create_report_criteria(report_4, ind1_pa_diagnosis_1);
PERFORM common_create_report_criteria(report_4, ind1_pa_clinical_1);
PERFORM common_create_report_criteria(report_4, ind1_pa_ql);
PERFORM common_create_report_criteria(report_4, ind1_pa_unspecified);
PERFORM common_create_report_criteria(report_4, ind1_m_criteria_unspecified);
PERFORM common_create_report_criteria(report_4, ind1_m_criteria_age_1);


-------CREATE REPORT CUSTOM CRITERIA GROUPS
--REPORT # 1
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_1,ind1_pa_diagnosis_1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_1,ind1_pa_diagnosis_3);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_1,ind1_pa_clinical_1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_1,ind1_pa_unspecified);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_1,ind1_pa_ql);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_1,ind1_pa_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_1,ind1_m_criteria_unspecified);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_1,ind1_m_criteria_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_2,ind1_pa_unspecified);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_2,ind1_m_criteria_unspecified);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_3,ind1_pa_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_3,ind1_pa_ql);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_3,ind1_m_criteria_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_single,ind1_pa_past_single_c1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_single,ind1_pa_past_single_c1_c2);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_single,ind1_pa_st_single_c1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_all,ind1_pa_st_single_c1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_all,ind1_pa_st_double_c1_c2);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_all,ind1_m_st_single_c2);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_pa_unspecified);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_pa_ql);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_pa_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_pa_past_single_c1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_pa_past_single_c1_c2);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_pa_st_single_c1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_m_criteria_unspecified);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_m_criteria_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_both,ind1_m_st_single_c2);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_steps,ind1_pa_past_single_c1);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_steps,ind1_pa_past_single_c1_c2);
PERFORM common_create_custom_criteria_group_criterias(rep_1_group_steps,ind1_pa_st_double_c1_c2);

--REPORT # 3
PERFORM common_create_custom_criteria_group_criterias(rep_3_group_1,ind3_m_criteria_lab_3);
PERFORM common_create_custom_criteria_group_criterias(rep_3_group_1,ind3_pa_criteria_clinical_3);
PERFORM common_create_custom_criteria_group_criterias(rep_3_group_2_ind_1,ind1_pa_clinical_1);
PERFORM common_create_custom_criteria_group_criterias(rep_3_group_2_ind_1,ind1_pa_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_3_group_2_ind_1,ind1_m_criteria_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_3_group_2_ind_3,ind3_pa_criteria_clinical_1);
PERFORM common_create_custom_criteria_group_criterias(rep_3_group_2_ind_3,ind3_pa_criteria_age_1);
PERFORM common_create_custom_criteria_group_criterias(rep_3_group_2_ind_3,ind3_m_criteria_age_1);

--REPORT # 4
PERFORM common_create_custom_criteria_group_criterias(rep_4_group_1,ind1_pa_unspecified);
PERFORM common_create_custom_criteria_group_criterias(rep_4_group_1,ind1_pa_ql);
PERFORM common_create_custom_criteria_group_criterias(rep_4_group_1,ind1_m_criteria_unspecified);
PERFORM common_create_custom_criteria_group_criterias(rep_4_group_1,ind1_m_criteria_age_1);

success:= TRUE;
RETURN success;

END
$$ LANGUAGE plpgsql;

