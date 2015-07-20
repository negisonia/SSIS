CREATE OR REPLACE FUNCTION test_001_006_create_fe_test_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE

health_plan_type_001_id INTEGER;
drug_001_id INTEGER;
state_001_id INTEGER;
success BOOLEAN:=FALSE;

BEGIN

--GET the input data
SELECT id from drugs where name = 'DRUG_001' limit 1 INTO drug_001_id;
SELECT id from health_plan_types where name = 'HEALTH_PLAN_TYPE_001' limit 1 INTO health_plan_type_001_id;
SELECT id from states where name = 'STATE_001' limit 1 INTO state_001_id;

PERFORM create_criteria_report(0,0,0,0,2,FALSE,FALSE,FALSE,ARRAY[drug_001_id],ARRAY[health_plan_001_id],'State',ARRAY[state_001_id]);

success=true;
return success;
END
$$ LANGUAGE plpgsql;
