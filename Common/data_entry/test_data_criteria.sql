CREATE OR REPLACE FUNCTION test_data_criteria() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE CRITERIAS
PERFORM common_create_criteria(1,'criteria_diagnosis_1', FALSE, TRUE);
PERFORM common_create_criteria(2,'criteria_unspecified', FALSE, TRUE);
PERFORM common_create_criteria(3,'criteria_diagnosis_2', FALSE, TRUE);
PERFORM common_create_criteria(4,'criteria_diagnosis_3', FALSE, TRUE);
PERFORM common_create_criteria(5,'criteria_exclusion_1', TRUE, TRUE);
PERFORM common_create_criteria(6,'criteria_clinical_1', FALSE, TRUE);
PERFORM common_create_criteria(7,'criteria_clinical_2', FALSE, TRUE);
PERFORM common_create_criteria(8,'criteria_clinical_3', FALSE, TRUE);
PERFORM common_create_criteria(9,'criteria_lab_1', FALSE, TRUE);
PERFORM common_create_criteria(10,'criteria_lab_2', TRUE, FALSE);
PERFORM common_create_criteria(11,'criteria_lab_3', FALSE, TRUE);
PERFORM common_create_criteria(12,'criteria_age_1', TRUE, TRUE);
PERFORM common_create_criteria(13,'criteria_ql_1', TRUE, TRUE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;