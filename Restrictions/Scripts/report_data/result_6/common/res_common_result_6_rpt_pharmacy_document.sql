CREATE OR REPLACE FUNCTION res_common_result_6_rpt_pharmacy_document(report_id INTEGER) -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
provider_1_id INTEGER;
commercial_plan_type_id INTEGER;
hix_plan_type_id INTEGER;
drug_1_id INTEGER;
drug_2_id INTEGER;
druglist VARCHAR;
expected_output VARCHAR;
BEGIN

SELECT common_get_table_id_by_name('drugs','drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name('drugs','drug_2') INTO drug_2_id;
SELECT common_get_table_id_by_name('health_plan_types','commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name('health_plan_types','hix') INTO hix_plan_type_id;
SELECT common_get_table_id_by_name('providers','provider_1') INTO provider_1_id;


druglist:= '%1$s,%2$s';

--COMERCIAL
--PA FORMS COMMERCIAL PROVIDER 1
expected_output = format('['||
'{"drug_id":%1$s,"drug_name":"drug_1","pa_policy_form_url":"https://www.provider_1.com/drug_1PAform1.pdf, https://www.provider_1.com/drug_1PAform2.pdf"},'||
'{"drug_id":%2$s,"drug_name":"drug_2","pa_policy_form_url":"https://www.provider_1.com/providerLevelPAform.pdf"}'||
']',drug_1_id,drug_2_id);
PERFORM res_rpt_pa_policy_form_url(report_id, commercial_plan_type_id, provider_1_id, format(druglist,drug_1_id,drug_2_id), expected_output);

--SPECIALTY FORMS
expected_output= format('['||
'{"name":"special_pharmacy_1","drug_id":%1$s,"url":"http://www.special_pharmacy_1.com/drug_1SPEForm.pdf"},'||
'{"name":"special_pharmacy_2","drug_id":%2$s,"url":"http://www.special_pharmacy_2.com/drug_2SPEForm.pdf"}'||
']',drug_1_id,drug_2_id);
PERFORM res_rpt_specialty_pharmacy_form(report_id, commercial_plan_type_id, provider_1_id, expected_output);


--HIX
--PA FORMS COMMERCIAL PROVIDER 1
expected_output = format('['||
'{"drug_id":%1$s,"drug_name":"drug_1","pa_policy_form_url":""},'||
'{"drug_id":%2$s,"drug_name":"drug_2","pa_policy_form_url":"https://www.provider_1.com/drug_2PAform1hix.pdf"}'||
']',drug_1_id,drug_2_id);
PERFORM res_rpt_pa_policy_form_url(report_id, hix_plan_type_id, provider_1_id, format(druglist,drug_1_id,drug_2_id), expected_output);

--SPECIALTY FORMS
expected_output= format('['||
'{"name":"special_pharmacy_3","drug_id":%1$s,"url":"http://www.special_pharmacy_3.com/drug_1SPEForm.pdf"},'||
'{"name":"special_pharmacy_3","drug_id":%2$s,"url":"http://www.special_pharmacy_3.com/drug_2SPEForm.pdf"}'||
']',drug_1_id,drug_2_id);
PERFORM res_rpt_specialty_pharmacy_form(report_id, hix_plan_type_id, provider_1_id, expected_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;