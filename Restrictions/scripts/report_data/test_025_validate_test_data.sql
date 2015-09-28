CREATE OR REPLACE FUNCTION restrictions_test_025_validate_test_data() --REPORT FRONT END
RETURNS boolean AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
BEGIN

success:=true;
return success;
END
$$ LANGUAGE plpgsql;