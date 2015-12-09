CREATE OR REPLACE FUNCTION res_ca_report_1_result_1_test_15_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_output varchar;
  report_id INTEGER;
  provider_id INTEGER;
  commercial_plan_type_id INTEGER;
  hix_plan_type_id INTEGER;
  drug_1 INTEGER;
  drug_2 INTEGER;
  health_plan_types VARCHAR:='health_plan_types';
  drugs VARCHAR:='drugs';
  providers VARCHAR:='providers';
  druglist VARCHAR;
BEGIN

-- Create Report Id
SELECT res_ca_create_report_1_result_1_criteria_report() INTO report_id;

-- Get parameter values
SELECT common_get_table_id_by_name(providers,'provider_1') INTO provider_id;
SELECT common_get_table_id_by_name(health_plan_types,'commercial') INTO commercial_plan_type_id;
SELECT common_get_table_id_by_name(health_plan_types,'hix') INTO hix_plan_type_id;
SELECT common_get_table_id_by_name(drugs,'drug_1') INTO drug_1;
SELECT common_get_table_id_by_name(drugs,'drug_2') INTO drug_2;
druglist:= '%1$s,%2$s';

--MEDICAL FORMS
expected_output = '['||
    '{"drug_id":1,"drug_name":"drug_1","medical_policy_form_url":"https://www.provider_1.com/drug_1Medicalform1.pdf,https://www.provider_1.com/drug_1Medicalform2.pdf"},'||
    '{"drug_id":2,"drug_name":"drug_2","medical_policy_form_url":"https://www.provider_1.com/providerLevelMedicalform.pdf"}'||
    ']';
PERFORM res_rpt_medical_policy_form_url(report_id, commercial_plan_type_id, provider_id, format(druglist,drug_1,drug_2), expected_output);

----SPECIALTY FORMS
expected_output='['||
    '{"name":"special_pharmacy_1","drug_id":1,"url":"http://www.special_pharmacy_1.com/drug_1SPEForm.pdf"},'||
    '{"name":"special_pharmacy_2","drug_id":2,"url":"http://www.special_pharmacy_2.com/drug_2SPEForm.pdf"}'||
    ']';
PERFORM res_rpt_specialty_pharmacy_form(report_id, commercial_plan_type_id, provider_id, expected_output);

--MEDICAL FORMS
expected_output = '['||
    '{"drug_id":1,"drug_name":"drug_1","medical_policy_form_url":""},'||
    '{"drug_id":2,"drug_name":"drug_2","medical_policy_form_url":"https://www.provider_1.com/drug_2hixMedicalform1.pdf"}'||
    ']';
PERFORM res_rpt_medical_policy_form_url(report_id, hix_plan_type_id, provider_id, format(druglist,drug_1,drug_2), expected_output);

--SPECIALTY FORMS
expected_output='['||
    '{"name":"special_pharmacy_3","drug_id":1,"url":"http://www.special_pharmacy_3.com/drug_1SPEForm.pdf"},'||
    '{"name":"special_pharmacy_3","drug_id":2,"url":"http://www.special_pharmacy_3.com/drug_2SPEForm.pdf"}'||
    ']';
PERFORM res_rpt_specialty_pharmacy_form(report_id, hix_plan_type_id, provider_id, expected_output);


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;