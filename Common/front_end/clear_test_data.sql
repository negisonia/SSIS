CREATE OR REPLACE FUNCTION clear_test_data()--ANALYTICS FRONT END
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

  --CLEAR TABLES
  TRUNCATE TABLE counties_criteria_reports CASCADE;
  TRUNCATE TABLE criteria_reports_drugs CASCADE;
  TRUNCATE TABLE criteria_reports_health_plan_types CASCADE;
  TRUNCATE TABLE criteria_reports_markets CASCADE;
  TRUNCATE TABLE criteria_reports_metro_stat_areas CASCADE;
  TRUNCATE TABLE criteria_reports CASCADE;
  TRUNCATE TABLE criteria_reports_states CASCADE;
  TRUNCATE TABLE report_selections CASCADE;
  TRUNCATE TABLE criteria_reports_dim_criteria_restriction CASCADE;
  
  --CLEAR SEQUENCES
  ALTER SEQUENCE criteria_reports_id_seq RESTART;
  
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
