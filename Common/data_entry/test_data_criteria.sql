CREATE OR REPLACE FUNCTION test_data_criteria() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE CRITERIAS
PERFORM common_create_criteria('criteria_diagnosis_1', FALSE, TRUE);
PERFORM common_create_criteria('criteria_diagnosis_2', FALSE, TRUE);
PERFORM common_create_criteria('criteria_diagnosis_3', FALSE, TRUE);
PERFORM common_create_criteria('criteria_unspecified', FALSE, TRUE);
PERFORM common_create_criteria('criteria_exclusion_1', TRUE, TRUE);
PERFORM common_create_criteria('criteria_clinical_1', FALSE, TRUE);
PERFORM common_create_criteria('criteria_clinical_2', FALSE, TRUE);
PERFORM common_create_criteria('criteria_clinical_3', FALSE, TRUE);
PERFORM common_create_criteria('criteria_lab_1', FALSE, TRUE);
PERFORM common_create_criteria('criteria_lab_2', TRUE, FALSE);
PERFORM common_create_criteria('criteria_lab_3', FALSE, TRUE);
PERFORM common_create_criteria('criteria_age_1', TRUE, TRUE);
PERFORM common_create_criteria('criteria_ql_1', TRUE, TRUE);


success=true;
return success;
END
$$ LANGUAGE plpgsql;