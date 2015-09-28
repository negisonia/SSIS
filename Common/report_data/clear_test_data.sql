CREATE OR REPLACE FUNCTION clear_test_data()--ANALYTICS FRONT END
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

  --CLEAR SEQUENCES
  ALTER SEQUENCE criteria_reports_id_seq RESTART;
  
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
