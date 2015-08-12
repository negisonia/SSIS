CREATE OR REPLACE FUNCTION clear_test_data()--DATA ENTRY
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

	--CLEAR TABLES
  TRUNCATE TABLE indications CASCADE;
  TRUNCATE TABLE indications_step_custom_options CASCADE;
  TRUNCATE TABLE drug_indications CASCADE;
  TRUNCATE TABLE drugclass_indications CASCADE;
  TRUNCATE TABLE restrictions CASCADE;
  TRUNCATE TABLE criteria CASCADE;
  TRUNCATE TABLE criteria_indications CASCADE;
  TRUNCATE TABLE criteria_other_restrictions CASCADE;
  TRUNCATE TABLE criteria_restrictions CASCADE;
  TRUNCATE TABLE custom_options CASCADE;
  TRUNCATE TABLE data_entries CASCADE;
  TRUNCATE TABLE medical_criteria CASCADE;
  TRUNCATE TABLE medicals CASCADE;
  TRUNCATE TABLE notes CASCADE;
  TRUNCATE TABLE prior_authorization_criteria CASCADE;
  TRUNCATE TABLE prior_authorizations CASCADE;
  TRUNCATE TABLE quantity_limit_criteria CASCADE;
  TRUNCATE TABLE quantity_limits CASCADE;
  TRUNCATE TABLE step_custom_options CASCADE;
  TRUNCATE TABLE atomic_steps CASCADE;
  TRUNCATE TABLE atomic_steps_notes CASCADE;
  TRUNCATE TABLE step_therapies CASCADE;


	--CLEAR SEQUENCES
  ALTER SEQUENCE indications_id_seq RESTART;
  ALTER SEQUENCE restrictions_id_seq RESTART;
  ALTER SEQUENCE criteria_id_seq RESTART;
  ALTER SEQUENCE criteria_other_restrictions_id_seq RESTART;
  ALTER SEQUENCE custom_options_id_seq RESTART;
  ALTER SEQUENCE data_entries_id_seq RESTART;
  ALTER SEQUENCE medical_criteria_id_seq RESTART;
  ALTER SEQUENCE medicals_id_seq RESTART;
  ALTER SEQUENCE notes_id_seq RESTART;
  ALTER SEQUENCE prior_authorization_criteria_id_seq RESTART;
  ALTER SEQUENCE prior_authorizations_id_seq RESTART;
  ALTER SEQUENCE quantity_limit_criteria_id_seq RESTART;
  ALTER SEQUENCE quantity_limits_id_seq RESTART;
  ALTER SEQUENCE step_custom_options_id_seq RESTART;
  ALTER SEQUENCE atomic_steps_id_seq RESTART;
  ALTER SEQUENCE step_custom_options_id_seq RESTART;
  ALTER SEQUENCE step_therapies_id_seq RESTART;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
