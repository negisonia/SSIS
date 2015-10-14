CREATE OR REPLACE FUNCTION restrictions_test_022_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

admin_report_1 INTEGER;
health_plan_notes_output VARCHAR;
expected_health_plan_notes_output VARCHAR;

provider_1 INTEGER;
commercial_hpt INTEGER;
hix_hpt INTEGER;
drug_1 INTEGER;
drug_2 INTEGER;
m_dim_criterion_type INTEGER := 2;

BEGIN



--RETRIEVE DRUG_ID
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;

--RETRIEVE PROVIDER ID
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1;
--RETRIEVE HEALTH PLAN TYPE
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_hpt;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_hpt;

--RETRIVE REPORT ID
SELECT  crr.report_id INTO admin_report_1 FROM criteria_restriction_reports crr WHERE crr.report_name='report_1';

--VALIDATE NOTES (DRUG 2, MEDICAL, commercial)
expected_health_plan_notes_output= '['||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_age_1","note_position":1,"notes":""}'||
    ']';
PERFORM rpt_health_plan_notes_validate_data(admin_report_1, provider_1, commercial_hpt, drug_2, m_dim_criterion_type, expected_health_plan_notes_output);

--VALIDATE NOTES (DRUG 2, MEDICAL, hix)
expected_health_plan_notes_output= '['||
    '{"indication_name":"indication_1","dim_criterion_type_id":1,"criterion_name":"criteria_diagnosis_3","note_position":1,"notes":"notes"},'||
    '{"indication_name":"indication_1","dim_criterion_type_id":2,"criterion_name":"ST - Single - custom_option_2^1 ","note_position":1,"notes":""}'||
    ']';
PERFORM rpt_health_plan_notes_validate_data(admin_report_1, provider_1, hix_hpt, drug_2, m_dim_criterion_type, expected_health_plan_notes_output);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;