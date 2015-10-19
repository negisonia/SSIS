CREATE OR REPLACE FUNCTION get_report_name_call(report_name VARCHAR, params INTEGER[])--ANALYTICS FRONT END
RETURNS VARCHAR AS $$
DECLARE
BEGIN
  RETURN report_name || '(' || array_to_string(params, ',') || ')';
END
$$ LANGUAGE plpgsql;