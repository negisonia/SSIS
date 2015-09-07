CREATE OR REPLACE FUNCTION get_report_id_by_criteria_report_id(criteria_report_id INTEGER)
RETURNS INTEGER AS $$
DECLARE

id_value INTEGER;

BEGIN

  SELECT report_id FROM criteria_reports WHERE id=criteria_report_id INTO id_value;

  IF id_value IS NULL THEN
    SELECT throw_error('CANNOT FIND REPORT ID FOR CRITERIA REPORT ID '|| criteria_report_id);
  ELSE
    RETURN id_value;
  END IF; 

END
$$ LANGUAGE plpgsql;