CREATE OR REPLACE FUNCTION clear_test_data()--ADMIN
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

	--CLEAR TABLES
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

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
