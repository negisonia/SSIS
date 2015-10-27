CREATE OR REPLACE FUNCTION clear_test_data()
RETURNS boolean AS $$
DECLARE
success boolean:= false;
BEGIN

	--CLEAR TABLES
  TRUNCATE TABLE azbusinesscenter CASCADE;
  TRUNCATE TABLE healthplantype CASCADE;
  TRUNCATE TABLE healthplan CASCADE;
  TRUNCATE TABLE jcodes CASCADE;
  TRUNCATE TABLE drug CASCADE;
  TRUNCATE TABLE drugclass CASCADE;
  TRUNCATE TABLE drugs_jcodes CASCADE;
  TRUNCATE TABLE drugdrugclass CASCADE;
  TRUNCATE TABLE parents CASCADE;
  TRUNCATE TABLE provider CASCADE;
  TRUNCATE TABLE formulary CASCADE;
  TRUNCATE TABLE drug CASCADE;
  TRUNCATE TABLE tier CASCADE;
  TRUNCATE TABLE country CASCADE;
  TRUNCATE TABLE state CASCADE;
  TRUNCATE TABLE formularyentry CASCADE;
  TRUNCATE TABLE formularyentryqualifier CASCADE;
  TRUNCATE TABLE healthplan_countylives CASCADE;
  TRUNCATE TABLE qualifier CASCADE;
  TRUNCATE TABLE reasoncode CASCADE;
  TRUNCATE TABLE healthplanstate CASCADE;
  TRUNCATE TABLE metrostatarea CASCADE;
  TRUNCATE TABLE county CASCADE;
  TRUNCATE TABLE healthplancounty CASCADE;
  TRUNCATE TABLE mv_active_formularies CASCADE;
  TRUNCATE TABLE benefitstructure CASCADE;
  TRUNCATE TABLE benefitstructurecopay CASCADE;
  TRUNCATE TABLE benefitstructurecopayvalue CASCADE;
  TRUNCATE TABLE benefitstructurestate CASCADE;
  TRUNCATE TABLE hli_medical_benefit_lives CASCADE;
  TRUNCATE TABLE hli_medical_benefit_designs CASCADE;
  TRUNCATE TABLE qualifier_form_landing_pages_drug CASCADE;
  TRUNCATE TABLE qualifier_form_landing_pages_drug_class CASCADE;
  TRUNCATE TABLE pbm_specialty_pharmacy CASCADE;
  TRUNCATE TABLE pbm_specialty_pharmacy_drug_enrollment_urls CASCADE;
  TRUNCATE TABLE pbm_specialty_pharmacy_drugs CASCADE;
  TRUNCATE TABLE pbm_specialty_pharmacy_specialization CASCADE;
  TRUNCATE TABLE pbm_healthplan_pharmacy CASCADE;

	--CLEAR SEQUENCES
  ALTER SEQUENCE healthplan_id_seq RESTART;
  ALTER SEQUENCE healthplantype_id_seq RESTART;
  ALTER SEQUENCE parents_id_seq RESTART;
  ALTER SEQUENCE provider_id_seq RESTART;
  ALTER SEQUENCE formulary_id_seq RESTART;
  ALTER SEQUENCE formularyentryqualifier_id_seq RESTART;
  ALTER SEQUENCE formularyentry_id_seq RESTART;
  ALTER SEQUENCE drug_id_seq RESTART;
  ALTER SEQUENCE tier_id_seq RESTART;
  ALTER SEQUENCE tier_order_index_id_seq RESTART;
  ALTER SEQUENCE country_id_seq RESTART;
  ALTER SEQUENCE state_id_seq RESTART;
  ALTER SEQUENCE health_plan_display_id_seq RESTART;
  ALTER SEQUENCE health_plan_county_lives_id_seq RESTART;
  ALTER SEQUENCE drug_display_id_seq RESTART;
  ALTER SEQUENCE jcodes_id_seq RESTART;
  ALTER SEQUENCE drug_id_seq RESTART;
  ALTER SEQUENCE drugclass_id_seq RESTART;
  ALTER SEQUENCE drugdrugclass_id_seq RESTART;
  ALTER SEQUENCE drugs_jcodes_id_seq RESTART;
  ALTER SEQUENCE qualifier_id_seq RESTART;
  ALTER SEQUENCE reasoncode_id_seq RESTART;
  ALTER SEQUENCE healthplanstate_id_seq RESTART;
  ALTER SEQUENCE metrostatarea_id_seq RESTART;
  ALTER SEQUENCE county_id_seq RESTART;
  ALTER SEQUENCE healthplancounty_id_seq RESTART;
  ALTER SEQUENCE benefitstructure_id_seq RESTART;
  ALTER SEQUENCE benefitstructurecopay_id_seq RESTART;
  ALTER SEQUENCE benefitstructurecopayvalue_id_seq RESTART;
  ALTER SEQUENCE benefitstructurestate_id_seq RESTART;
  ALTER SEQUENCE hli_medical_benefit_lives_id_seq RESTART;
  ALTER SEQUENCE hli_medical_benefit_designs_id_seq RESTART;
  ALTER SEQUENCE qualifier_form_landing_pages_drug_id_seq RESTART;
  ALTER SEQUENCE qualifier_form_landing_pages_drug_class_id_seq RESTART;
  ALTER SEQUENCE pbm_specialty_pharmacy_id_seq RESTART;
  ALTER SEQUENCE pbm_specialty_pharmacy_drug_enrollment_urls_id_seq RESTART;
  ALTER SEQUENCE pbm_specialty_pharmacy_drugs_id_seq RESTART;
  ALTER SEQUENCE pbm_specialty_pharmacy_specialization_id_seq RESTART;
  ALTER SEQUENCE azbusinesscenter_entityid_seq RESTART;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
