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

data_entry_id INTEGER;
st_id INTEGER;
step_custom_option_id INTEGER;

custom_option_1 INTEGER;
custom_option_2 INTEGER;
custom_option_3 INTEGER;
custom_option_4 INTEGER;


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
SELECT p.id FROM provider p WHERE p.name='provider_1' INTO provider_1_id;

--RETRIEVE HEALTH PLAN TYPE ID
SELECT hpt.id INTO commercial_health_plan_type FROM ff.health_plan_types_import hpt WHERE hpt.name='health_plan_comm';
SELECT hpt.id INTO hix_health_plan_type FROM ff.health_plan_types_import hpt WHERE hpt.name='health_plan_hix';

--RETRIEVE CUSTOM OPTIONS
SELECT co.id INTO custom_option_1 FROM custom_options co WHERE co.name='custom_option_1');
SELECT co.id INTO custom_option_2 FROM custom_options co WHERE co.name='custom_option_2');
SELECT co.id INTO custom_option_3 FROM custom_options co WHERE co.name='custom_option_3');
SELECT co.id INTO custom_option_4 FROM custom_options co WHERE co.name='custom_option_4');



-----INSERTS-----
--RETRIEVE DATA ENTRY
	SELECT common_create_data_entry(indication_1, provider_1, hix_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
	--RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    SELECT common_create_atomic_step_notes(data_entry_id, 'custom_option_1','PA/Medical', 1, step_custom_option_id, 'Drug1 notes: notes for drug 1') --DATA ENTRY

--RETRIEVE DATA ENTRY
	SELECT common_create_data_entry(indication_1, provider_1, hix_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
	--RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    SELECT common_create_atomic_step_notes(data_entry_id, 'custom_option_1','ST', 1, step_custom_option_id, 'Drug1 notes: notes for drug 1') --DATA ENTRY

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1, hix_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_2 and sco.customizable_type='CustomOption';

    SELECT common_create_atomic_step_notes(data_entry_id, 'custom_option_2','ST', 1, step_custom_option_id, 'Drug2 notes: notes for drug 1') --DATA ENTRY

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1, hix_health_plan_type, drug_2) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    SELECT common_create_atomic_step_notes(data_entry_id, 'custom_option_2','PA/Medical', 1, step_custom_option_id, null) --DATA ENTRY

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1, hix_health_plan_type, drug_4) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    SELECT common_create_atomic_step_notes(data_entry_id, 'custom_option_1','ST', 1, step_custom_option_id, null) --DATA ENTRY

--RETRIEVE DATA ENTRY
    SELECT common_create_data_entry(indication_1, provider_1, hix_health_plan_type, drug_4) INTO data_entry_id; -- already exists returns existing id
    --RETRIEVE StepCustomOptions
    SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';

    SELECT common_create_atomic_step_notes(data_entry_id, 'custom_option_1','ST', 1, step_custom_option_id, null) --DATA ENTRY

success=true;
return success;
END
$$ LANGUAGE plpgsql;