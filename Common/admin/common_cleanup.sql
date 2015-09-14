CREATE OR REPLACE FUNCTION clear_test_data()--ANALYTICS FRONT END
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

  --CLEAR TABLES
  TRUNCATE TABLE custom_accounts CASCADE;
  TRUNCATE TABLE custom_account_providers CASCADE;
  TRUNCATE TABLE custom_account_provider_plan_types CASCADE;
  TRUNCATE TABLE custom_account_health_plans CASCADE;
  TRUNCATE TABLE clients CASCADE;
  TRUNCATE TABLE reports CASCADE;
  TRUNCATE TABLE report_clients CASCADE;
  TRUNCATE TABLE report_criterias CASCADE;
  TRUNCATE TABLE report_drugs CASCADE;
  TRUNCATE TABLE custom_criteria_groups CASCADE;
  TRUNCATE TABLE custom_criteria_group_criterias CASCADE;
  TRUNCATE TABLE client_custom_criteria_groups CASCADE;

  --CLEAR SEQUENCES
  ALTER SEQUENCE custom_accounts_id_seq RESTART;
  ALTER SEQUENCE clients_id_seq RESTART;
  ALTER SEQUENCE report_clients_id_seq RESTART;
  ALTER SEQUENCE custom_criteria_groups_id_seq RESTART;
  ALTER SEQUENCE report_business_id_seq RESTART;
  ALTER SEQUENCE reports_id_seq RESTART;

  
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
