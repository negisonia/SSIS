CREATE OR REPLACE FUNCTION res_report_1_result_1_test_25_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
fe_report_1 INTEGER;
expected_provider_details_output VARCHAR;
pa_benefit_type_id INTEGER :=1;
medical_benefit_type_id INTEGER :=2;
provider_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
BEGIN

SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;

--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;

--VALIDATE SUMMARY TABLE
expected_provider_details_output= format('['||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_1","criteria_restriction_name":"PA - Age - criteria_age_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_1","criteria_restriction_name":"PA - Clinical - criteria_clinical_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_1","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%3$s,"health_plan_type_name":"hix","lives":100,"drug_name":"drug_2","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_1","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_1","criteria_restriction_name":"PA/ST - Single - custom_option_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%3$s,"health_plan_type_name":"hix","lives":100,"drug_name":"drug_2","criteria_restriction_name":"PA/ST - Single - custom_option_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_2","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%3$s,"health_plan_type_name":"hix","lives":100,"drug_name":"drug_1","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_1","criteria_restriction_name":"QL - criteria_ql_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_2","criteria_restriction_name":"QL - criteria_ql_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Pharmacy","health_plan_type_id":%3$s,"health_plan_type_name":"hix","lives":100,"drug_name":"drug_2","criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2"}'||
    ']',provider_id,commercial_plan_type_id,hix_plan_type_id);
PERFORM res_rpt_provider_details_validate_data(fe_report_1, pa_benefit_type_id, expected_provider_details_output);

expected_provider_details_output=format('['||
    '{"provider_id":%1$s,"benefit_name":"Medical","health_plan_type_id":%2$s,"health_plan_type_name":"commercial","lives":200,"drug_name":"drug_2","criteria_restriction_name":"Age - criteria_age_1"},'||
    '{"provider_id":%1$s,"benefit_name":"Medical","health_plan_type_id":%3$s,"health_plan_type_name":"hix","lives":100,"drug_name":"drug_2","criteria_restriction_name":"Diagnosis - criteria_diagnosis_3"},'||
    '{"provider_id":%1$s,"benefit_name":"Medical","health_plan_type_id":%3$s,"health_plan_type_name":"hix","lives":100,"drug_name":"drug_2","criteria_restriction_name":"ST - Single - custom_option_2"}'||
    ']',provider_id,commercial_plan_type_id,hix_plan_type_id);
PERFORM res_rpt_provider_details_validate_data(fe_report_1, medical_benefit_type_id, expected_provider_details_output);

success:=true;
return success;
END
$$ LANGUAGE plpgsql;