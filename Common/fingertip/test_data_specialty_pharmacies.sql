CREATE OR REPLACE FUNCTION test_data_specialty_pharmacies() --FF NEW
RETURNS boolean AS $$
DECLARE

drug_1_id INTEGER;
drug_2_id INTEGER;

health_plan_hix_id INTEGER;
health_plan_comm_id INTEGER;
health_plan_comm_1_id INTEGER;
health_plan_union_id INTEGER;

specialty_pharmacy_id INTEGER;

health_plan VARCHAR:='healthplan';
drug VARCHAR:='drug';

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE DRUGS
  SELECT common_get_table_id_by_name(drug, 'drug_1') INTO drug_1_id;
  SELECT common_get_table_id_by_name(drug, 'drug_2') INTO drug_2_id;

--RETRIEVE PLANS
  SELECT common_get_table_id_by_name(health_plan, 'health_plan_comm') INTO health_plan_comm_id;
  SELECT common_get_table_id_by_name(health_plan, 'health_plan_comm_1') INTO health_plan_comm_1_id;
  SELECT common_get_table_id_by_name(health_plan, 'health_plan_union') INTO health_plan_union_id;
  SELECT common_get_table_id_by_name(health_plan, 'health_plan_hix') INTO health_plan_hix_id;

  -- special_pharmacy_1
  SELECT common_create_pbm_specialty_pharmacy('special_pharmacy_1',TRUE) INTO specialty_pharmacy_id;
    -- Insert PBM Speciatly Pharmacy Drugs
    PERFORM common_create_pbm_specialty_pharmacy_drugs(specialty_pharmacy_id, health_plan_comm_id, drug_1_id);
    -- Insert PBM Specialty Pharmacy Specialization
    PERFORM common_create_pbm_specialty_pharmacy_specialization(specialty_pharmacy_id, 'Hepatitis, Anemia' ,TRUE);
    -- Insert PBM Specialty Pharmacy Drug
    PERFORM common_create_pbm_specialty_pharmacy_drug_enrollment_urls(specialty_pharmacy_id, drug_1_id, 'http://www.special_pharmacy_1.com/drug_1SPEForm.pdf');
    -- Insert PBM Health Plan Pharmacy
    PERFORM common_create_pbm_healthplan_pharmacy(specialty_pharmacy_id, health_plan_comm_id, TRUE);

  -- special_pharmacy_2
  SELECT common_create_pbm_specialty_pharmacy('special_pharmacy_2',TRUE) INTO specialty_pharmacy_id;
    -- Insert PBM Speciatly Pharmacy Drugs
    PERFORM common_create_pbm_specialty_pharmacy_drugs(specialty_pharmacy_id, health_plan_comm_1_id, drug_2_id);
    -- Insert PBM Specialty Pharmacy Specialization
    PERFORM common_create_pbm_specialty_pharmacy_specialization(specialty_pharmacy_id, 'Hepatitis, Anemia' ,TRUE);
    -- Insert PBM Specialty Pharmacy Drug
    PERFORM common_create_pbm_specialty_pharmacy_drug_enrollment_urls(specialty_pharmacy_id, drug_2_id, 'http://www.special_pharmacy_2.com/drug_2SPEForm.pdf');
    -- Insert PBM Health Plan Pharmacy
    PERFORM common_create_pbm_healthplan_pharmacy(specialty_pharmacy_id, health_plan_comm_1_id, TRUE);

  -- special_pharmacy_3
  SELECT common_create_pbm_specialty_pharmacy('special_pharmacy_3',TRUE) INTO specialty_pharmacy_id;
    -- Insert PBM Speciatly Pharmacy Drugs
    PERFORM common_create_pbm_specialty_pharmacy_drugs(specialty_pharmacy_id, health_plan_hix_id, drug_1_id);
    PERFORM common_create_pbm_specialty_pharmacy_drugs(specialty_pharmacy_id, health_plan_hix_id, drug_2_id);
    PERFORM common_create_pbm_specialty_pharmacy_drugs(specialty_pharmacy_id, health_plan_union_id, drug_1_id);
    -- Insert PBM Specialty Pharmacy Specialization
    PERFORM common_create_pbm_specialty_pharmacy_specialization(specialty_pharmacy_id, 'Hepatitis, Anemia' ,TRUE);
    -- Insert PBM Specialty Pharmacy Drug
    PERFORM common_create_pbm_specialty_pharmacy_drug_enrollment_urls(specialty_pharmacy_id, drug_1_id, 'http://www.special_pharmacy_3.com/drug_1SPEForm.pdf');
    PERFORM common_create_pbm_specialty_pharmacy_drug_enrollment_urls(specialty_pharmacy_id, drug_2_id, 'http://www.special_pharmacy_3.com/drug_2SPEForm.pdf');
     -- Insert PBM Health Plan Pharmacy
    PERFORM common_create_pbm_healthplan_pharmacy(specialty_pharmacy_id, health_plan_hix_id, TRUE);
    PERFORM common_create_pbm_healthplan_pharmacy(specialty_pharmacy_id, health_plan_union_id, TRUE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;