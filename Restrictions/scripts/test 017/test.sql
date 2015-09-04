CREATE OR REPLACE FUNCTION test()
RETURNS boolean AS $$
DECLARE
expected_summary_table_output VARCHAR;
success boolean DEFAULT false;
BEGIN

  expected_summary_table_output= format('{"criteria_report_id":%1$s,"drug_id":%2$s,"drug_id":%3$s',1,1,2);
  RAISE NOTICE ' ouput: %' , expected_summary_table_output;
success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
