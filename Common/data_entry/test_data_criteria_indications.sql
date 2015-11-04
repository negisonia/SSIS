CREATE OR REPLACE FUNCTION test_data_criteria_indications() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

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

indication_1_id INTEGER;
indication_2_id INTEGER;
indication_3_id INTEGER;
indication_4_id INTEGER;
indication_5_id INTEGER;

BEGIN

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

--RETRIEVE INDICATIONS
SELECT i.id INTO indication_1_id from indications i WHERE i.name='indication_1';
SELECT i.id INTO indication_2_id from indications i WHERE i.name='indication_2';
SELECT i.id INTO indication_3_id from indications i WHERE i.name='indication_3';
SELECT i.id INTO indication_4_id from indications i WHERE i.name='indication_4' ;
SELECT i.id INTO indication_5_id from indications i WHERE i.name='indication_5';

PERFORM common_create_criteria_indication(criteria_diagnosis_1,indication_1_id);
PERFORM common_create_criteria_indication(criteria_diagnosis_1,indication_3_id);

PERFORM common_create_criteria_indication(criteria_diagnosis_2,indication_2_id);
PERFORM common_create_criteria_indication(criteria_diagnosis_2,indication_3_id);

PERFORM common_create_criteria_indication(criteria_diagnosis_3,indication_1_id);
PERFORM common_create_criteria_indication(criteria_diagnosis_3,indication_3_id);

PERFORM common_create_criteria_indication(criteria_unspecified,indication_1_id);
PERFORM common_create_criteria_indication(criteria_unspecified,indication_2_id);
PERFORM common_create_criteria_indication(criteria_unspecified,indication_3_id);

PERFORM common_create_criteria_indication(criteria_exclusion_1,indication_2_id);

PERFORM common_create_criteria_indication(criteria_clinical_1,indication_1_id);
PERFORM common_create_criteria_indication(criteria_clinical_1,indication_3_id);

PERFORM common_create_criteria_indication(criteria_clinical_2,indication_2_id);

PERFORM common_create_criteria_indication(criteria_clinical_3,indication_2_id);
PERFORM common_create_criteria_indication(criteria_clinical_3,indication_3_id);

PERFORM common_create_criteria_indication(criteria_lab_1,indication_2_id);

PERFORM common_create_criteria_indication(criteria_lab_2,indication_2_id);
PERFORM common_create_criteria_indication(criteria_lab_2,indication_3_id);

PERFORM common_create_criteria_indication(criteria_lab_3,indication_1_id);
PERFORM common_create_criteria_indication(criteria_lab_3,indication_3_id);

PERFORM common_create_criteria_indication(criteria_age_1,indication_1_id);
PERFORM common_create_criteria_indication(criteria_age_1,indication_2_id);
PERFORM common_create_criteria_indication(criteria_age_1,indication_3_id);

PERFORM common_create_criteria_indication(criteria_ql_1,indication_1_id);
PERFORM common_create_criteria_indication(criteria_ql_1,indication_2_id);
PERFORM common_create_criteria_indication(criteria_ql_1,indication_3_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;