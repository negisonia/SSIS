CREATE OR REPLACE FUNCTION res_rpt_provider_notes_validate_data(report_id INTEGER, provider_id INTEGER, health_plan_type_id INTEGER, drug_id INTEGER, dim_criteria_restriction_id INTEGER, expected_json VARCHAR) --FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
rpt_provider_notes_output VARCHAR;
BEGIN

--VALIDATE RPT PROVIDER DETAILS
SELECT  array_to_json(array_agg(row_to_json(t))) from (select indication_name, indication_abbre, dim_criterion_type_id, criterion_name, note_position, notes from rpt_provider_notes(report_id,provider_id,health_plan_type_id,drug_id,dim_criteria_restriction_id) order by indication_name, indication_abbre, dim_criterion_type_id, criterion_name, note_position, notes) t  INTO rpt_provider_notes_output;

IF rpt_provider_notes_output IS DISTINCT FROM expected_json THEN
RAISE NOTICE 'ACTUAL: %s' , rpt_provider_notes_output;
RAISE NOTICE 'EXPECTED: %s', expected_json;
SELECT throw_error('rpt_provider_notes_output_data : REPORT PROVIDER NOTES OUTPUT MISMATCH');
END IF;

success=true;
return success;
END
$$ LANGUAGE plpgsql;


