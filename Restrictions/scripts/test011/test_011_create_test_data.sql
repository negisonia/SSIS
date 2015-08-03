CREATE OR REPLACE FUNCTION restrictions_test_011_create_test_data() --DATA ENTRY DB
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
indication_1_id INTEGER;
indication_2_id INTEGER;
indication_3_id INTEGER;
indication_4_id INTEGER;
indication_5_id INTEGER;

criteria_1_id INTEGER;
criteria_2_id INTEGER;
criteria_3_id INTEGER;
criteria_4_id INTEGER;
criteria_5_id INTEGER;
criteria_6_id INTEGER;
criteria_7_id INTEGER;
criteria_8_id INTEGER;
criteria_9_id INTEGER;
criteria_10_id INTEGER;
criteria_11_id INTEGER;
criteria_12_id INTEGER;
criteria_13_id INTEGER;

restriction_1_id INTEGER;
restriction_2_id INTEGER;
restriction_3_id INTEGER;
restriction_4_id INTEGER;
restriction_5_id INTEGER;
restriction_6_id INTEGER;
restriction_7_id INTEGER;
restriction_8_id INTEGER;
restriction_9_id INTEGER;
restriction_10_id INTEGER;
restriction_11_id INTEGER;
restriction_12_id INTEGER;
restriction_13_id INTEGER;

provider_1_id INTEGER;

commercial_health_plan_type_id INTEGER;
hix_health_plan_type_id INTEGER;

drug_1_id INTEGER;
drug_2_id INTEGER;
drug_3_id INTEGER;
drug_4_id INTEGER;
drug_5_id INTEGER;
drug_6_id INTEGER;
drug_7_id INTEGER;

data_entry_1_id INTEGER;
data_entry_2_id INTEGER;
data_entry_3_id INTEGER;
data_entry_4_id INTEGER;
data_entry_5_id INTEGER;
data_entry_6_id INTEGER;
data_entry_7_id INTEGER;
data_entry_8_id INTEGER;
data_entry_9_id INTEGER;
data_entry_10_id INTEGER;
data_entry_11_id INTEGER;
data_entry_12_id INTEGER;
data_entry_13_id INTEGER;
data_entry_14_id INTEGER;
data_entry_15_id INTEGER;

prior_authorization_1_id INTEGER;
prior_authorization_2_id INTEGER;
prior_authorization_3_id INTEGER;
prior_authorization_4_id INTEGER;
prior_authorization_5_id INTEGER;
prior_authorization_6_id INTEGER;
prior_authorization_7_id INTEGER;
prior_authorization_8_id INTEGER;
prior_authorization_9_id INTEGER;

medical_1_id INTEGER;
medical_2_id INTEGER;
medical_3_id INTEGER;

quantity_limit_1_id INTEGER;
quantity_limit_2_id INTEGER;

BEGIN

--RETRIEVE INDICATIONS IDS
SELECT i.id INTO indication_1_id FROM indications i WHERE i.name='restrictions_indication_1' and abbreviation = 'Ind1';
SELECT i.id INTO indication_2_id FROM indications i WHERE i.name='restrictions_indication_2' and abbreviation = 'Ind2';
SELECT i.id INTO indication_3_id FROM indications i WHERE i.name='restrictions_indication_3' and abbreviation = 'Ind3';
SELECT i.id INTO indication_4_id FROM indications i WHERE i.name='restrictions_indication_4' and abbreviation = 'Ind4';
SELECT i.id INTO indication_5_id FROM indications i WHERE i.name='restrictions_indication_5' and abbreviation = 'Ind5';


--RETRIEVE PROVIDER IDS
SELECT p.id INTO provider_1_id FROM ff.providers_import p WHERE p.name='restrictions_provider_1';

--RETRIEVE HEALTH PLAN TYPE ID
SELECT hpt.id INTO commercial_health_plan_type_id FROM health_plan_types_import hpt WHERE hpt.name='restrictions_test_commercial';
SELECT hpt.id INTO hix_health_plan_type_id FROM health_plan_types_import hpt WHERE hpt.name='restrictions_test_hix';

--RETRIEVE DRUG IDS
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='restrictions_drug_1';
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='restrictions_drug_2';
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='restrictions_drug_3';
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='restrictions_drug_4';
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='restrictions_drug_5';
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='restrictions_drug_6';
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='restrictions_drug_7';

--CREATE CRITERIAS
SELECT common_create_criteria('restrictions_criteria_diagnosis_1',FALSE,TRUE) INTO criteria_1_id;
SELECT common_create_criteria('restrictions_criteria_diagnosis_2',FALSE,TRUE) INTO criteria_2_id;
SELECT common_create_criteria('restrictions_criteria_diagnosis_3',FALSE,TRUE) INTO criteria_3_id;
SELECT common_create_criteria('restrictions_criteria_unspecified',FALSE,TRUE) INTO criteria_4_id;
SELECT common_create_criteria('restrictions_criteria_exclusion_1',TRUE,TRUE) INTO criteria_5_id;
SELECT common_create_criteria('restrictions_criteria_clinical_1',FALSE,TRUE) INTO criteria_6_id;
SELECT common_create_criteria('restrictions_criteria_clinical_2',FALSE,TRUE) INTO criteria_7_id;
SELECT common_create_criteria('restrictions_criteria_clinical_3',FALSE,TRUE) INTO criteria_8_id;
SELECT common_create_criteria('restrictions_criteria_lab_1',FALSE,TRUE) INTO criteria_9_id;
SELECT common_create_criteria('restrictions_criteria_lab_2',TRUE,TRUE) INTO criteria_10_id;
SELECT common_create_criteria('restrictions_criteria_lab_3',FALSE,TRUE) INTO criteria_11_id;
SELECT common_create_criteria('restrictions_criteria_age_1',TRUE,TRUE) INTO criteria_12_id;
SELECT common_create_criteria('restrictions_criteria_ql_1',TRUE,TRUE) INTO criteria_13_id;

--CREATE RESTRICTIONS
SELECT common_create_restriction('Diagnosis','PA') INTO restriction_1_id;
SELECT common_create_restriction('Diagnosis','Medical') INTO restriction_2_id;
SELECT common_create_restriction('Unspecified','PA') INTO restriction_3_id;
SELECT common_create_restriction('Unspecified','Medical') INTO restriction_4_id;
SELECT common_create_restriction('Exclusion','PA') INTO restriction_5_id;
SELECT common_create_restriction('Exclusion','Medical') INTO restriction_6_id;
SELECT common_create_restriction('Clinical','PA') INTO restriction_7_id;
SELECT common_create_restriction('Clinical','Medical') INTO restriction_8_id;
SELECT common_create_restriction('Labs','PA') INTO restriction_9_id;
SELECT common_create_restriction('Labs','Medical') INTO restriction_10_id;
SELECT common_create_restriction('Age','PA') INTO restriction_11_id;
SELECT common_create_restriction('Age','Medical') INTO restriction_12_id;
SELECT common_create_restriction('QL','PA') INTO restriction_13_id;

--CREATE CRITERIA RESTRICTIONS
PERFORM common_create_criteria_restriction(criteria_1_id,restriction_1_id);
PERFORM common_create_criteria_restriction(criteria_2_id,restriction_2_id);
PERFORM common_create_criteria_restriction(criteria_2_id,restriction_1_id);
PERFORM common_create_criteria_restriction(criteria_3_id,criteria_1_id);
PERFORM common_create_criteria_restriction(criteria_4_id,restriction_3_id);
PERFORM common_create_criteria_restriction(criteria_4_id,restriction_4_id);
PERFORM common_create_criteria_restriction(criteria_5_id,restriction_5_id);
PERFORM common_create_criteria_restriction(criteria_5_id,restriction_6_id);
PERFORM common_create_criteria_restriction(criteria_6_id,restriction_7_id);
PERFORM common_create_criteria_restriction(criteria_7_id,restriction_8_id);
PERFORM common_create_criteria_restriction(criteria_8_id,restriction_8_id);
PERFORM common_create_criteria_restriction(criteria_8_id,restriction_7_id);
PERFORM common_create_criteria_restriction(criteria_9_id,restriction_9_id);
PERFORM common_create_criteria_restriction(criteria_9_id,restriction_10_id);
PERFORM common_create_criteria_restriction(criteria_10_id,restriction_9_id);
PERFORM common_create_criteria_restriction(criteria_10_id,restriction_10_id);
PERFORM common_create_criteria_restriction(criteria_11_id,restriction_10_id);
PERFORM common_create_criteria_restriction(criteria_12_id,restriction_11_id);
PERFORM common_create_criteria_restriction(criteria_12_id,restriction_12_id);
PERFORM common_create_criteria_restriction(criteria_13_id,restriction_13_id);

--CREATE CRITERIA INDICATIONS
PERFORM common_create_criteria_indication(criteria_1_id,indication_1_id);
PERFORM common_create_criteria_indication(criteria_1_id,indication_3_id);
PERFORM common_create_criteria_indication(criteria_2_id,indication_2_id);
PERFORM common_create_criteria_indication(criteria_2_id,indication_3_id);
PERFORM common_create_criteria_indication(criteria_3_id,indication_1_id);
PERFORM common_create_criteria_indication(criteria_4_id,indication_1_id);
PERFORM common_create_criteria_indication(criteria_4_id,indication_2_id);
PERFORM common_create_criteria_indication(criteria_5_id,indication_2_id);
PERFORM common_create_criteria_indication(criteria_6_id,indication_1_id);
PERFORM common_create_criteria_indication(criteria_7_id,indication_2_id);
PERFORM common_create_criteria_indication(criteria_8_id,indication_2_id);
PERFORM common_create_criteria_indication(criteria_8_id,indication_3_id);
PERFORM common_create_criteria_indication(criteria_9_id,indication_2_id);
PERFORM common_create_criteria_indication(criteria_10_id,indication_2_id);
PERFORM common_create_criteria_indication(criteria_10_id,indication_3_id);
PERFORM common_create_criteria_indication(criteria_11_id,indication_3_id);
PERFORM common_create_criteria_indication(criteria_12_id,indication_1_id);
PERFORM common_create_criteria_indication(criteria_12_id,indication_2_id);
PERFORM common_create_criteria_indication(criteria_13_id,indication_1_id);
PERFORM common_create_criteria_indication(criteria_13_id,indication_2_id);

--CREATE DATA ENTRIES
SELECT common_create_data_entry(indication_1_id,provider_1_id,commercial_health_plan_type_id,drug_1_id) INTO data_entry_1_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,hix_health_plan_type_id,drug_2_id) INTO data_entry_2_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,hix_health_plan_type_id,drug_2_id) INTO data_entry_3_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,commercial_health_plan_type_id,drug_2_id) INTO data_entry_4_id;
SELECT common_create_data_entry(indication_2_id,provider_1_id,commercial_health_plan_type_id,drug_5_id) INTO data_entry_5_id;
SELECT common_create_data_entry(indication_2_id,provider_1_id,commercial_health_plan_type_id,drug_6_id) INTO data_entry_6_id;
SELECT common_create_data_entry(indication_2_id,provider_1_id,commercial_health_plan_type_id,drug_7_id) INTO data_entry_7_id;
SELECT common_create_data_entry(indication_2_id,provider_1_id,commercial_health_plan_type_id,drug_6_id) INTO data_entry_8_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,hix_health_plan_type_id,drug_1_id) INTO data_entry_9_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,hix_health_plan_type_id,drug_3_id) INTO data_entry_10_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,hix_health_plan_type_id,drug_4_id) INTO data_entry_11_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,commercial_health_plan_type_id,drug_1_id) INTO data_entry_12_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,commercial_health_plan_type_id,drug_1_id) INTO data_entry_13_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,commercial_health_plan_type_id,drug_1_id) INTO data_entry_14_id;
SELECT common_create_data_entry(indication_1_id,provider_1_id,hix_health_plan_type_id,drug_2_id) INTO data_entry_15_id;

--CREATE PRIOR AUTHORIZATIONS
SELECT common_create_prior_authorization(data_entry_1_id, TRUE) INTO prior_authorization_1_id;
SELECT common_create_prior_authorization(data_entry_2_id, FALSE) INTO prior_authorization_2_id;
SELECT common_create_prior_authorization(data_entry_6_id, TRUE) INTO prior_authorization_3_id;
SELECT common_create_prior_authorization(data_entry_9_id, TRUE) INTO prior_authorization_4_id;
SELECT common_create_prior_authorization(data_entry_11_id, TRUE) INTO prior_authorization_5_id;
SELECT common_create_prior_authorization(data_entry_12_id, TRUE) INTO prior_authorization_6_id;
SELECT common_create_prior_authorization(data_entry_13_id, TRUE) INTO prior_authorization_7_id;
SELECT common_create_prior_authorization(data_entry_14_id, TRUE) INTO prior_authorization_8_id;
SELECT common_create_prior_authorization(data_entry_15_id, TRUE) INTO prior_authorization_9_id;

--CREATE PRIOR AUTHORIZATION CRITERIA
PERFORM common_create_prior_authorization_criteria(prior_authorization_1_id,criteria_1_id,TRUE);
PERFORM common_create_prior_authorization_criteria(prior_authorization_2_id,criteria_3_id,TRUE);
PERFORM common_create_prior_authorization_criteria(prior_authorization_3_id,criteria_12_id,TRUE);
PERFORM common_create_prior_authorization_criteria(prior_authorization_4_id,criteria_4_id,TRUE);
PERFORM common_create_prior_authorization_criteria(prior_authorization_5_id,criteria_12_id,TRUE);
PERFORM common_create_prior_authorization_criteria(prior_authorization_6_id,criteria_6_id,TRUE);
PERFORM common_create_prior_authorization_criteria(prior_authorization_7_id,criteria_12_id,TRUE);
PERFORM common_create_prior_authorization_criteria(prior_authorization_8_id,criteria_3_id,TRUE);
PERFORM common_create_prior_authorization_criteria(prior_authorization_9_id,criteria_1_id,TRUE);

--CREATE MEDICALS
SELECT common_create_medical(data_entry_3_id,TRUE) INTO medical_1_id;
SELECT common_create_medical(data_entry_4_id,TRUE) INTO medical_2_id;
SELECT common_create_medical(data_entry_5_id,TRUE) INTO medical_3_id;

--CREATE MEDICALS CRITERIA
PERFORM common_create_medical_criteria(medical_1_id,criteria_3_id,TRUE);
PERFORM common_create_medical_criteria(medical_2_id,criteria_4_id,TRUE);
PERFORM common_create_medical_criteria(medical_3_id,criteria_1_id,TRUE);

--CREATE QUANTITY LIMITS
SELECT common_create_quantity_limits(data_entry_8_id,TRUE) INTO  quantity_limit_1_id;
SELECT common_create_quantity_limits(data_entry_10_id,TRUE) INTO  quantity_limit_2_id;

--CREATE QUANTITY LIMITS CRITERIA
PERFORM common_create_quantity_limit_criteria(quantity_limit_1_id,criteria_13_id,TRUE,2,10,'tabs','week');
PERFORM common_create_quantity_limit_criteria(quantity_limit_2_id,criteria_13_id,TRUE,1,10,'tabs','day');

success=true;
return success;
END
$$ LANGUAGE plpgsql;