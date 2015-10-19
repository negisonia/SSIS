CREATE OR REPLACE FUNCTION get_current_month()--ANALYTICS FRONT END
RETURNS INTEGER AS $$
DECLARE
current_month integer;
BEGIN

  SELECT extract(month from date_trunc('month', current_date)) INTO current_month;

RETURN current_month;
END
$$ LANGUAGE plpgsql;