CREATE OR REPLACE FUNCTION res_result_7_test_143_validate_test_data() -- REPORT FRONT END
RETURNS boolean AS $$
DECLARE
  success BOOLEAN DEFAULT FALSE;
  criteria_report_id INTEGER;
BEGIN
--REPORT#1
SELECT res_create_result_7_criteria_report() INTO criteria_report_id;
PERFORM res_common_result_7_rpt_provider_notes(criteria_report_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;


--/**
--review data for summary table  drug 1  pharmacy pa/st
--we have pa/st  for commercial and employer Health plans
--
--we added 100 lives from HLI LIVES  for employer hot as there is no commercial plan type associated to a commercial hpt so we look for provider 11 middlesex hi lives and add this lives to the 500 total
--
--
--medical st  drug 1  100  is not coming in summary table and it should come
--
--
--pharmacy  drugs table:
--
--first line difference should be 200
--commercial drug 1  indications 1 provider 1 : single custom option one
--employer single drug 3 drug 1 provider 11 indication 1
--**/