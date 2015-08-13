CREATE OR REPLACE FUNCTION test_011_create_test_data() --DATA ENTRY DB
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

prior_authorization_1_id INTEGER;
prior_authorization_2_id INTEGER;
prior_authorization_3_id INTEGER;
prior_authorization_4_id INTEGER;
prior_authorization_5_id INTEGER;

medical_1_id INTEGER;
medical_2_id INTEGER;
medical_3_id INTEGER;

quantity_limit_1_id INTEGER;
quantity_limit_2_id INTEGER;

custom_option_1_id  INTEGER;
custom_option_2_id  INTEGER;
custom_option_3_id  INTEGER;
custom_option_4_id  INTEGER;
custom_option_5_id  INTEGER;
custom_option_6_id  INTEGER;
custom_option_7_id  INTEGER;

step_custom_option_id_1 INTEGER;
step_custom_option_id_2 INTEGER;
step_custom_option_id_3 INTEGER;
step_custom_option_id_4 INTEGER;
step_custom_option_id_5 INTEGER;
step_custom_option_id_6 INTEGER;
step_custom_option_id_7 INTEGER;

atomic_step_id_1 INTEGER;
atomic_step_id_2 INTEGER;
atomic_step_id_3 INTEGER;
atomic_step_id_4 INTEGER;
atomic_step_id_5 INTEGER;
atomic_step_id_6 INTEGER;

BEGIN

--RETRIEVE INDICATIONS IDS
SELECT i.id INTO indication_1_id FROM indications i WHERE i.name='indication_1' and abbreviation = 'Ind1';
SELECT i.id INTO indication_2_id FROM indications i WHERE i.name='indication_2' and abbreviation = 'Ind2';
SELECT i.id INTO indication_3_id FROM indications i WHERE i.name='indication_3' and abbreviation = 'Ind3';
SELECT i.id INTO indication_4_id FROM indications i WHERE i.name='indication_4' and abbreviation = 'Ind4';
SELECT i.id INTO indication_5_id FROM indications i WHERE i.name='indication_5' and abbreviation = 'Ind5';


--RETRIEVE PROVIDER IDS
SELECT p.id INTO provider_1_id FROM ff.providers_import p WHERE p.name='provider_1';

--RETRIEVE HEALTH PLAN TYPE ID
SELECT hpt.id INTO commercial_health_plan_type_id FROM ff.health_plan_types_import hpt WHERE hpt.name='health_plan_comm';
SELECT hpt.id INTO hix_health_plan_type_id FROM ff.health_plan_types_import hpt WHERE hpt.name='health_plan_hix';

--RETRIEVE DRUG IDS
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='drug_1';
SELECT d.id INTO drug_2_id FROM ff.drugs_import d WHERE d.name='drug_2';
SELECT d.id INTO drug_3_id FROM ff.drugs_import d WHERE d.name='drug_3';
SELECT d.id INTO drug_4_id FROM ff.drugs_import d WHERE d.name='drug_4';
SELECT d.id INTO drug_5_id FROM ff.drugs_import d WHERE d.name='drug_5';
SELECT d.id INTO drug_6_id FROM ff.drugs_import d WHERE d.name='drug_6';
SELECT d.id INTO drug_7_id FROM ff.drugs_import d WHERE d.name='drug_7';

--CREATE CRITERIAS
--SELECT common_create_criteria('criteria_diagnosis_1',FALSE,TRUE) INTO criteria_1_id;

--CREATE RESTRICTIONS
--SELECT common_create_restriction('Diagnosis','PA') INTO restriction_1_id;

--CREATE CRITERIA RESTRICTIONS
--PERFORM common_create_criteria_restriction(criteria_1_id,restriction_1_id);--criteria_diagnosis_1  - pa diagnosis

--CREATE CRITERIA INDICATIONS
--PERFORM common_create_criteria_indication(criteria_1_id,indication_1_id);

--CREATE DATA ENTRIES
SELECT common_create_data_entry(indication_1_id,provider_1_id,commercial_health_plan_type_id,drug_1_id) INTO data_entry_1_id;

--CREATE PRIOR AUTHORIZATIONS
--SELECT common_create_prior_authorization(data_entry_1_id, TRUE) INTO prior_authorization_1_id;

--CREATE PRIOR AUTHORIZATION CRITERIA
--PERFORM common_create_prior_authorization_criteria(prior_authorization_1_id,criteria_1_id,TRUE);

--CREATE MEDICALS
--SELECT common_create_medical(data_entry_2_id,TRUE) INTO medical_1_id;

--CREATE MEDICALS CRITERIA
--PERFORM common_create_medical_criteria(medical_1_id,criteria_3_id,TRUE);

--CREATE QUANTITY LIMITS
--SELECT common_create_quantity_limits(data_entry_5_id,TRUE) INTO  quantity_limit_1_id;

--CREATE QUANTITY LIMITS CRITERIA
--PERFORM common_create_quantity_limit_criteria(quantity_limit_1_id,criteria_13_id,TRUE,2,10,'tabs','week');


--CREATE CUSTOM OPTIONS
--SELECT common_create_custom_option('restriction_custom_option_1') INTO custom_option_1_id;

--CREATE STEP CUSTOM OPTIONS
SELECT common_create_step_custom_option(drug_1_id,'Drug') INTO  step_custom_option_id_1;

--CREATE ATOMIC STEPS (new key = step_custom_option_id_1 ) confirmar
SELECT common_create_atomic_steps(NULL,NULL, 0, 'ST', NULL) INTO atomic_step_id_1;

--CREATE STEP THERAPIES
--PERFORM  common_create_step_therapies(data_entry_1_id,NULL,TRUE,atomic_step_id_1);


--CREATE STEP NOTES
--PERFORM common_create_atomic_step_notes(data_entry_1_id,'ST','drug_4',1,step_custom_option_id_1,  'Drug4 notes: notes for drug 4');



success=true;
return success;
END
$$ LANGUAGE plpgsql;