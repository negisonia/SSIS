CREATE OR REPLACE FUNCTION restrictions_test_028_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
expected_source_comments_output VARCHAR;
fe_report_1 INTEGER;
provider_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
drug_1 INTEGER;
drug_2 INTEGER;
druglist VARCHAR;

BEGIN

--RETRIEVE DATA
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;
SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2;

druglist:= '%1$s,%2$s';

--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;

--PA FORMS
expected_source_comments_output = '['||
    '{"drug_id":1,"drug_name":"drug_1","pa_policy_form_url":"https://www.provider_1.com/drug_1PAform1.pdf, https://www.provider_1.com/drug_1PAform2.pdf"},'||
    '{"drug_id":2,"drug_name":"drug_2","pa_policy_form_url":"https://www.provider_1.com/providerLevelPAform.pdf"}'||
    ']';
PERFORM res_rpt_pa_policy_form_url(fe_report_1, commercial_plan_type_id, provider_id, format(druglist,drug_1,drug_2), expected_source_comments_output);

--SPECIALTY FORMS
expected_source_comments_output= '['||
    '{"specialty_pharmacy_id":1,"name":"special_pharmacy_1,special_pharmacy_2","drug_id":1,"url":"http://www.special_pharmacy_1.com/drug_1SPEForm.pdf"},'||
    '{"specialty_pharmacy_id":2,"name":"special_pharmacy_1,special_pharmacy_2","drug_id":2,"url":"http://www.special_pharmacy_2.com/drug_2SPEForm.pdf"}'||
    ']';
PERFORM res_rpt_specialty_pharmacy_form(fe_report_1, commercial_plan_type_id, provider_id, expected_source_comments_output);

--PA FORMS
expected_source_comments_output = '['||
    '{"drug_id":1,"drug_name":"drug_1","pa_policy_form_url":""},'||
    '{"drug_id":2,"drug_name":"drug_2","pa_policy_form_url":"https://www.provider_1.com/drug_2PAform1hix.pdf"}'
    ||']';
PERFORM res_rpt_pa_policy_form_url(fe_report_1, hix_plan_type_id, provider_id, format(druglist,drug_1,drug_2), expected_source_comments_output);

--SPECIALTY FORMS
expected_source_comments_output='['||
    '{"specialty_pharmacy_id":3,"name":"special_pharmacy_3","drug_id":1,"url":"http://www.special_pharmacy_3.com/drug_1SPEForm.pdf"},'||
    '{"specialty_pharmacy_id":3,"name":"special_pharmacy_3","drug_id":2,"url":"http://www.special_pharmacy_3.com/drug_2SPEForm.pdf"}'||
    ']';
PERFORM res_rpt_specialty_pharmacy_form(fe_report_1, hix_plan_type_id, provider_id, expected_source_comments_output);


success:=true;
return success;
END
$$ LANGUAGE plpgsql;