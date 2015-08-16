CREATE OR REPLACE FUNCTION test_data_medicals() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

indication_1 INTEGER;
indication_2 INTEGER;
indication_3 INTEGER;
indication_4 INTEGER;
indication_5 INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;
drug_3 INTEGER;
drug_4 INTEGER;
drug_5 INTEGER;
drug_6 INTEGER;
drug_7 INTEGER;
drug_8 INTEGER;
drug_9 INTEGER;
drug_10 INTEGER;
drug_11 INTEGER;

criteria_diagnosis_1 INTEGER;
criteria_diagnosis_2 INTEGER;
criteria_diagnosis_3 INTEGER;
criteria_unspecified INTEGER;
criteria_exclusion_1 INTEGER;
criteria_clinical_1 INTEGER;
criteria_clinical_2 INTEGER;
criteria_clinical_3 INTEGER;
criteria_lab_1  INTEGER;
criteria_lab_2 INTEGER;
criteria_lab_3 INTEGER;
criteria_age_1 INTEGER;
criteria_ql_1 INTEGER;

commercial_health_plan_type INTEGER;
hix_health_plan_type INTEGER;

data_entry_id INTEGER;
medical_id INTEGER;
atomic_step_id INTEGER;

provider_1_id INTEGER;
BEGIN

--RETRIEVE INDICATIONS
SELECT i.id from indications i WHERE i.name='indication_1' INTO indication_1;
SELECT i.id from indications i WHERE i.name='indication_2' INTO indication_2;
SELECT i.id from indications i WHERE i.name='indication_3' INTO indication_3;
SELECT i.id from indications i WHERE i.name='indication_4' INTO indication_4;
SELECT i.id from indications i WHERE i.name='indication_5' INTO indication_5;


--RETRIEVE DRUG IDS
SELECT d.id INTO drug_1 FROM ff.drugs_import d WHERE d.name='drug_1';
SELECT d.id INTO drug_2 FROM ff.drugs_import d WHERE d.name='drug_2';
SELECT d.id INTO drug_3 FROM ff.drugs_import d WHERE d.name='drug_3';
SELECT d.id INTO drug_4 FROM ff.drugs_import d WHERE d.name='drug_4';
SELECT d.id INTO drug_5 FROM ff.drugs_import d WHERE d.name='drug_5';
SELECT d.id INTO drug_6 FROM ff.drugs_import d WHERE d.name='drug_6';
SELECT d.id INTO drug_7 FROM ff.drugs_import d WHERE d.name='drug_7';
SELECT d.id INTO drug_8 FROM ff.drugs_import d WHERE d.name='drug_8';
SELECT d.id INTO drug_9 FROM ff.drugs_import d WHERE d.name='drug_9';
SELECT d.id INTO drug_10 FROM ff.drugs_import d WHERE d.name='drug_10_inactive';
SELECT d.id INTO drug_11 FROM ff.drugs_import d WHERE d.name='drug_11_inactive';

--RETRIEVE CRITERIAS
SELECT c.id INTO criteria_diagnosis_1 FROM criteria c WHERE c.name='criteria_diagnosis_1';
SELECT c.id INTO criteria_diagnosis_2 FROM criteria c WHERE c.name='criteria_diagnosis_2';
SELECT c.id INTO criteria_diagnosis_3 FROM criteria c WHERE c.name='criteria_diagnosis_3';
SELECT c.id INTO criteria_unspecified FROM criteria c WHERE c.name='criteria_unspecified';
SELECT c.id INTO criteria_exclusion_1 FROM criteria c WHERE c.name='criteria_exclusion_1';
SELECT c.id INTO criteria_clinical_1 FROM criteria c WHERE c.name='criteria_clinical_1';
SELECT c.id INTO criteria_clinical_2 FROM criteria c WHERE c.name='criteria_clinical_2';
SELECT c.id INTO criteria_clinical_3 FROM criteria c WHERE c.name='criteria_clinical_3';
SELECT c.id INTO criteria_lab_1 FROM criteria c WHERE c.name='criteria_lab_1';
SELECT c.id INTO criteria_lab_2 FROM criteria c WHERE c.name='criteria_lab_2';
SELECT c.id INTO criteria_lab_3 FROM criteria c WHERE c.name='criteria_lab_3';
SELECT c.id INTO criteria_age_1 FROM criteria c WHERE c.name='criteria_age_1';
SELECT c.id INTO criteria_ql_1 FROM criteria c WHERE c.name='criteria_ql_1';

--RETRIEVE PROVIDERS
SELECT p.id INTO provider_1_id FROM ff.providers_import p WHERE p.name='provider_1';

--RETRIEVE HEALTH PLAN TYPE ID
SELECT hpt.id INTO commercial_health_plan_type FROM ff.health_plan_types_import hpt WHERE hpt.name='commercial';
SELECT hpt.id INTO hix_health_plan_type FROM ff.health_plan_types_import hpt WHERE hpt.name='hix';

--INSERT MEDICALS LIMITS---
    --INSERT DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1_id, hix_health_plan_type, drug_2) INTO data_entry_id;--already exists returns existing id
    --INSERT ATOMIC STEPS
    SELECT common_create_atomic_steps('custom_option_2', '2', 1, 'PA/Medical', 'custom_option_2^1 ') INTO atomic_step_id ;
    --INSERT MEDICAL
    SELECT  common_create_medical(data_entry_id,TRUE,atomic_step_id) INTO medical_id;
    --INSERT MEDICAL CRITERIA
    PERFORM common_create_medical_criteria(medical_id, criteria_diagnosis_3, TRUE);
    PERFORM common_update_data_entry(data_entry_id, NULL, NULL, NULL, NULL, medical_id);

    --INSERT DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1_id, commercial_health_plan_type, drug_2) INTO data_entry_id;
    --INSERT MEDICAL
    SELECT common_create_medical(data_entry_id,TRUE,NULL) INTO medical_id;
    --INSERT MEDICAL CRITERIA
    PERFORM common_create_medical_criteria(medical_id, criteria_unspecified, TRUE);

     --INSERT DATA ENTRY
    SELECT common_create_data_entry(indication_2, provider_1_id, commercial_health_plan_type, drug_5) INTO data_entry_id;
    --INSERT MEDICAL
    SELECT common_create_medical(data_entry_id,TRUE,NULL) INTO medical_id;
    --INSERT MEDICAL CRITERIA
    PERFORM common_create_medical_criteria(medical_id, criteria_age_1, TRUE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;