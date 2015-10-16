CREATE OR REPLACE FUNCTION res_rpt_health_plan_notes_validate_data(admin_report_id INTEGER, provider_id INTEGER, health_plan_type_id INTEGER, drug_id INTEGER, dim_restriction_type_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
actual_json VARCHAR;
BEGIN

SELECT  array_to_json(array_agg(row_to_json(t))) from (select indication_name, dim_criterion_type_id, criterion_name, note_position, notes from rpt_health_plan_notes(admin_report_id, provider_id, health_plan_type_id, drug_id, dim_restriction_type_id) order by indication_name, dim_criterion_type_id, criterion_name) t INTO actual_json;

IF actual_json IS DISTINCT FROM expected_json THEN
  RAISE NOTICE 'ACTUAL: %s' , actual_json;
  RAISE NOTICE 'EXPECTED: %s', expected_json;
 SELECT throw_error('rpt_health_plan_notes: Table Output Mismatch');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql; 
