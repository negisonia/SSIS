CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_plan_test002_validate_tier_id_and_name(dim_tier_id integer, dim_tier_name varchar, health_plan_names varchar[]) --FF NEW DB
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  expected_value double precision;
  expected_value_varchar varchar;
  actual_value INTEGER;
  actual_value_varchar varchar;
  criteria_report_id INTEGER;
  current_month_int INTEGER;
  plan_name varchar;
BEGIN

SELECT get_current_month() INTO current_month_int;
-- Create Criteria Report Id
SELECT ana_rpt_coverage_tier_plan_test_001_010_create_fe_data() INTO criteria_report_id;

FOREACH plan_name IN ARRAY health_plan_names
  LOOP  
    --GET the input data
    SELECT calculate_report_value('dim_tier_id', get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'health_plan_name=''' || plan_name || '''') INTO actual_value;
    --expected_value = dim_tier_id;

    PERFORM validate_comparison_values(actual_value, dim_tier_id,'ana_rpt_coverage_tier_plan_test_002_validate_data-error: EXPECTED dim_tier_id TO BE ');

    SELECT calculate_report_value_varchar('dim_tier_name', get_report_name_call('rpt_coverage_tier_plan', ARRAY[criteria_report_id,current_month_int]),'health_plan_name=''' || plan_name || '''') INTO actual_value_varchar;
    --expected_value_varchar = dim_tier_name;

    PERFORM validate_comparison_values_varchar(actual_value_varchar, dim_tier_name,'ana_rpt_coverage_tier_plan_test_002_validate_data-error: EXPECTED dim_tier_name TO BE ');
END LOOP;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;