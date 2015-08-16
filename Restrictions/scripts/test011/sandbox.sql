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

drug_class_1 integer;

BEGIN

--CREATE CRITERIAS
PERFORM common_create_restriction('Diagnosis','PA');
PERFORM common_create_restriction('Diagnosis','Medical');
PERFORM common_create_restriction('Unspecified','PA');
PERFORM common_create_restriction('Unspecified','Medical');
PERFORM common_create_restriction('Exclusion','PA');
PERFORM common_create_restriction('Exclusion','Medical');
PERFORM common_create_restriction('Clinical','PA');
PERFORM common_create_restriction('Clinical','Medical');
PERFORM common_create_restriction('Labs','PA');
PERFORM common_create_restriction('Labs','Medical');
PERFORM common_create_restriction('Age','PA');
PERFORM common_create_restriction('Age','Medical');
PERFORM common_create_restriction('QL','QL');
PERFORM common_create_restriction('PA','PA');
PERFORM common_create_restriction('Medical','Medical');

select common_create_indication('indication_1', 'Ind1') INTO indication_1_id;
select common_create_indication('indication_2', 'Ind2')INTO indication_2_id;
select common_create_indication('indication_3', 'Ind3') INTO indication_3_id;
select common_create_indication('indication_4', 'Ind4') INTO indication_4_id;
select common_create_indication('indication_5', 'Ind5') INTO indication_5_id;


--RETRIEVE PROVIDER IDS
SELECT p.id INTO provider_1_id FROM ff.providers_import p WHERE p.name='provider_1';

--RETRIEVE HEALTH PLAN TYPE ID
SELECT hpt.id INTO commercial_health_plan_type_id FROM ff.health_plan_types_import hpt WHERE hpt.name='commercial';
SELECT hpt.id INTO hix_health_plan_type_id FROM ff.health_plan_types_import hpt WHERE hpt.name='hix';

--RETRIEVE DRUG IDS
SELECT d.id INTO drug_1_id FROM ff.drugs_import d WHERE d.name='drug_1';
SELECT d.id INTO drug_2_id FROM ff.drugs_import d WHERE d.name='drug_2';
SELECT d.id INTO drug_3_id FROM ff.drugs_import d WHERE d.name='drug_3';
SELECT d.id INTO drug_4_id FROM ff.drugs_import d WHERE d.name='drug_4';
SELECT d.id INTO drug_5_id FROM ff.drugs_import d WHERE d.name='drug_5';
SELECT d.id INTO drug_6_id FROM ff.drugs_import d WHERE d.name='drug_6';
SELECT d.id INTO drug_7_id FROM ff.drugs_import d WHERE d.name='drug_7';

SELECT dc.id INTO drug_class_1 FROM ff.drug_classes_import dc WHERE dc.name = 'drug_class_1';

PERFORM common_create_drug_indication(indication_1_id,drug_1_id);
PERFORM common_create_drug_class_indication(indication_1_id,drug_class_1);

SELECT common_create_data_entry(indication_1_id,provider_1_id,commercial_health_plan_type_id,drug_1_id) INTO data_entry_1_id;

--SELECT common_create_custom_option('custom_option_1') INTO custom_option_1_id;

SELECT common_create_step_custom_option(drug_1_id,'Drug') INTO step_custom_option_id_1;

--CREATE ATOMIC STEPS (new key = step_custom_option_id_1 ) confirmar
SELECT common_create_atomic_steps('drug_1','1', 1, 'PA/Medical', 'drug_1^1') INTO atomic_step_id_1;

--CREATE STEP NOTES
PERFORM common_create_atomic_step_notes(data_entry_1_id,'PA/Medical','drug_1',1,step_custom_option_id_1,  'notes');

PERFORM common_create_indications_step_custom_options(indication_1_id,step_custom_option_id_1);


--CREATE PRIOR AUTHORIZATIONS
SELECT common_create_prior_authorization(data_entry_1_id, TRUE,atomic_step_id_1) INTO prior_authorization_1_id;



success=true;
return success;
END
$$ LANGUAGE plpgsql;