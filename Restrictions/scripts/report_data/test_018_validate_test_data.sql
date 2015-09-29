CREATE OR REPLACE FUNCTION restrictions_test_018_validate_test_data() --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
fe_report_1 INTEGER;
pharmacy_view CONSTANT integer:=1;
medical_view CONSTANT integer:=2;
expected_rpt_drug_output VARCHAR;
BEGIN

--REPORT#1
SELECT util_report_1_generate() INTO fe_report_1;

--VALIDATE RPT_DRUG pharmacy
expected_rpt_drug_output= format('['||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Age - criteria_age_1","restriction_name":"PA - Age","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Clinical - criteria_clinical_1","restriction_name":"PA - Clinical","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","restriction_name":"PA - Diagnosis","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_3","restriction_name":"PA - Diagnosis","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA/ST - Single - custom_option_1","restriction_name":"PA/ST - Single","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","restriction_name":"PA - Unspecified","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_1","benefit_name":"Pharmacy","criteria_restriction_name":"QL - criteria_ql_1","restriction_name":"QL","dim_restriction_type_id":4,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Diagnosis - criteria_diagnosis_1","restriction_name":"PA - Diagnosis","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"PA/ST - Single - custom_option_1","restriction_name":"PA/ST - Single","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"PA - Unspecified - Criteria Unspecified","restriction_name":"PA - Unspecified","dim_restriction_type_id":1,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"QL - criteria_ql_1","restriction_name":"QL","dim_restriction_type_id":4,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0},'||
    '{"criteria_report_id":%1$s,"indication_name":"indication_1","drug_name":"drug_2","benefit_name":"Pharmacy","criteria_restriction_name":"ST - Double - custom_option_1 AND  custom_option_2","restriction_name":"ST - Double","dim_restriction_type_id":3,"lives":100,"total_pharmacy_lives":300,"health_plan_count":1,"total_health_plan_count":3,"total_medical_lives":0,"provider_count":0,"total_provider_count":0}'||
    ']',fe_report_1);

PERFORM res_rpt_drug_validate_data(fe_report_1, 1 ,expected_rpt_drug_output);

success=true;
return success;
END
$$ LANGUAGE plpgsql;