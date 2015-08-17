CREATE OR REPLACE FUNCTION test_data_criteria_restrictions() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

pa_diagnosis_id INTEGER;
medical_diagnosis_id INTEGER;
pa_unspecified_id INTEGER;
medical_unspecified_id INTEGER;
pa_exclusion_id INTEGER;
medical_exclusion_id INTEGER;
pa_clinical_id INTEGER;
medical_clinical_id INTEGER;
pa_labs_id INTEGER;
medical_labs_id INTEGER;
pa_age_id INTEGER;
medical_age_id INTEGER;
ql_ql_id INTEGER;
pa_pa_id INTEGER;
medical_medical_id INTEGER;

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

BEGIN

--RETRIEVE RESTRICTIONS
SELECT r.id INTO pa_diagnosis_id  WHERE r.name='Diagnosis' and r.category ='PA';
SELECT r.id INTO medical_diagnosis_id  WHERE r.name='Diagnosis' and r.category ='Medical';
SELECT r.id INTO pa_unspecified_id  WHERE r.name='Unspecified' and r.category ='PA';
SELECT r.id INTO medical_unspecified_id  WHERE r.name='Unspecified' and r.category ='Medical';
SELECT r.id INTO pa_exclusion_id  WHERE r.name='Exclusion' and r.category ='PA';
SELECT r.id INTO medical_exclusion_id  WHERE r.name='Exclusion' and r.category ='Medical';
SELECT r.id INTO pa_clinical_id  WHERE r.name='Clinical' and r.category ='PA';
SELECT r.id INTO medical_clinical_id  WHERE r.name='Clinical' and r.category ='Medical';
SELECT r.id INTO pa_labs_id  WHERE r.name='Labs' and r.category ='PA';
SELECT r.id INTO medical_labs_id  WHERE r.name='Labs' and r.category ='Medical';
SELECT r.id INTO pa_age_id  WHERE r.name='Age' and r.category ='PA';
SELECT r.id INTO medical_age_id  WHERE r.name='Age' and r.category ='Medical';
SELECT r.id INTO ql_ql_id  WHERE r.name='QL' and r.category ='QL';
SELECT r.id INTO pa_pa_id  WHERE r.name='PA' and r.category ='PA';
SELECT r.id INTO medical_medical_id  WHERE r.name='Medical' and r.category ='Medical';

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

--INSERT CRITERIA RESTRICTION
PERFORM common_create_criteria_restriction(criteria_diagnosis_1,pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_1,pa_diagnosis_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_2,medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_2,medical_diagnosis_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_2,pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_2,pa_diagnosis_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_3,pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_3,pa_diagnosis_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_3,medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_diagnosis_3,medical_diagnosis_id);
PERFORM common_create_criteria_restriction(criteria_unspecified, pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_unspecified, pa_unspecified_id);
PERFORM common_create_criteria_restriction(criteria_unspecified, medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_unspecified, medical_unspecified_id);
PERFORM common_create_criteria_restriction(criteria_exclusion_1, pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_exclusion_1, pa_exclusion_id);
PERFORM common_create_criteria_restriction(criteria_exclusion_1, medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_exclusion_1, medical_exclusion_id);
PERFORM common_create_criteria_restriction(criteria_clinical_1, pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_clinical_1, pa_clinical_id);
PERFORM common_create_criteria_restriction(criteria_clinical_2, medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_clinical_2, medical_clinical_id);
PERFORM common_create_criteria_restriction(criteria_clinical_3, medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_clinical_3, medical_clinical_id);
PERFORM common_create_criteria_restriction(criteria_clinical_3, pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_clinical_3, pa_clinical_id);
PERFORM common_create_criteria_restriction(criteria_lab_1, pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_lab_1, pa_labs_id);
PERFORM common_create_criteria_restriction(criteria_lab_1, medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_lab_1, medical_labs_id);
PERFORM common_create_criteria_restriction(criteria_lab_2, pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_lab_2, pa_labs_id);
PERFORM common_create_criteria_restriction(criteria_lab_2, medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_lab_2, medical_labs_id);
PERFORM common_create_criteria_restriction(criteria_lab_3, medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_lab_3, medical_labs_id);
PERFORM common_create_criteria_restriction(criteria_age_1, pa_pa_id);
PERFORM common_create_criteria_restriction(criteria_age_1, pa_age_id);
PERFORM common_create_criteria_restriction(criteria_age_1, medical_medical_id);
PERFORM common_create_criteria_restriction(criteria_age_1, medical_age_id);
PERFORM common_create_criteria_restriction(criteria_ql_1, ql_ql_id);


success=true;
return success;
END
$$ LANGUAGE plpgsql;