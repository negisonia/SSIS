CREATE OR REPLACE FUNCTION test_data_atomic_step_notes() --DATA ENTRY
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
employeer_health_plan_type INTEGER;
medicare_ma_health_plan_type INTEGER;

data_entry_id INTEGER;
st_id INTEGER;
step_custom_option_id INTEGER;

custom_option_1 INTEGER;
custom_option_2 INTEGER;
custom_option_3 INTEGER;
custom_option_4 INTEGER;

provider_1_id INTEGER;
provider_11_id INTEGER;

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
SELECT p.id INTO provider_1_id FROM ff.providers_import p WHERE p.name='provider_1' ;
SELECT p.id INTO provider_11_id FROM ff.providers_import p WHERE p.name='provider_11';

--RETRIEVE HEALTH PLAN TYPE ID
SELECT hpt.id INTO commercial_health_plan_type FROM ff.health_plan_types_import hpt WHERE hpt.name='commercial';
SELECT hpt.id INTO hix_health_plan_type FROM ff.health_plan_types_import hpt WHERE hpt.name='hix';
SELECT hpt.id INTO employeer_health_plan_type FROM ff.health_plan_types_import hpt WHERE hpt.name='employer';
SELECT hpt.id INTO medicare_ma_health_plan_type FROM ff.health_plan_types_import hpt WHERE hpt.name='medicare_ma';

--RETRIEVE CUSTOM OPTIONS
SELECT co.id INTO custom_option_1 FROM custom_options co WHERE co.name='custom_option_1';
SELECT co.id INTO custom_option_2 FROM custom_options co WHERE co.name='custom_option_2';
SELECT co.id INTO custom_option_3 FROM custom_options co WHERE co.name='custom_option_3';
SELECT co.id INTO custom_option_4 FROM custom_options co WHERE co.name='custom_option_4';



-----INSERTS-----
--RETRIEVE DATA ENTRY
	SELECT common_create_data_entry(indication_1, provider_1_id, hix_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
	--RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    PERFORM common_create_atomic_step_notes(data_entry_id, 'PA','custom_option_1', 1, step_custom_option_id, 'Drug1 notes: notes for drug 1');

--RETRIEVE DATA ENTRY
	SELECT common_create_data_entry(indication_1, provider_1_id, hix_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
	--RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    PERFORM common_create_atomic_step_notes(data_entry_id, 'ST','custom_option_1', 1, step_custom_option_id, 'Drug1 notes: notes for drug 1');

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1_id, hix_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_2 and sco.customizable_type='CustomOption';

    PERFORM common_create_atomic_step_notes(data_entry_id, 'ST','custom_option_2', 2, step_custom_option_id, 'Drug2 notes: notes for drug 2');

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1_id, hix_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_2 and sco.customizable_type='CustomOption';

    PERFORM common_create_atomic_step_notes(data_entry_id, 'Medical','custom_option_2', 1, step_custom_option_id, null);

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1_id, hix_health_plan_type, drug_4) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    PERFORM common_create_atomic_step_notes(data_entry_id, 'ST','custom_option_1', 1, step_custom_option_id, null);

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1_id, commercial_health_plan_type, drug_1) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    PERFORM common_create_atomic_step_notes(data_entry_id, 'PA','custom_option_1', 1, step_custom_option_id, 'Drug1 notes: long message 500 characters');

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1_id, hix_health_plan_type, drug_4) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    PERFORM common_create_atomic_step_notes(data_entry_id, 'PA','custom_option_1', 1, step_custom_option_id, NULL);

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1_id, hix_health_plan_type, drug_4) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_2 and sco.customizable_type='CustomOption';
    PERFORM common_create_atomic_step_notes(data_entry_id, 'PA','custom_option_2', 1, step_custom_option_id, NULL);

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_11_id, employeer_health_plan_type, drug_1) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=drug_3 and sco.customizable_type='Drug';
    PERFORM common_create_atomic_step_notes(data_entry_id, 'PA','drug_3', 1, step_custom_option_id, 'Drug_1 notes: use Drug _3 first');


--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_11_id, medicare_ma_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';
    PERFORM common_create_atomic_step_notes(data_entry_id, 'PA','custom_option_1', 1, step_custom_option_id, 'Drug_1 notes: notes for drug 1');

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_11_id, medicare_ma_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_2 and sco.customizable_type='CustomOption';
    PERFORM common_create_atomic_step_notes(data_entry_id, 'PA','custom_option_2', 1, step_custom_option_id, 'Drug_2 notes: notes for drug 2');

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_11_id, medicare_ma_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=drug_3 and sco.customizable_type='Drug';
    PERFORM common_create_atomic_step_notes(data_entry_id, 'ST','drug_3', 1, step_custom_option_id, 'Drug_1 notes: notes for drug 3');
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';
    PERFORM common_create_atomic_step_notes(data_entry_id, 'ST','custom_option_1', 1, step_custom_option_id, 'Drug_2 notes: notes for custom option 1');

success=true;
return success;
END
$$ LANGUAGE plpgsql;