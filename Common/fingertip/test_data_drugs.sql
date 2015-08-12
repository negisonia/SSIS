CREATE OR REPLACE FUNCTION test_data_drugs() --FF NEW DB
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE DRUGS
PERFORM common_create_drug(TRUE,TRUE,'drug_1');
PERFORM common_create_drug(TRUE,TRUE,'drug_2');
PERFORM common_create_drug(TRUE,TRUE,'drug_3');
PERFORM common_create_drug(TRUE,TRUE,'drug_4');
PERFORM common_create_drug(TRUE,TRUE,'drug_5');
PERFORM common_create_drug(TRUE,TRUE,'drug_6');
PERFORM common_create_drug(TRUE,TRUE,'drug_7');
PERFORM common_create_drug(TRUE,TRUE,'drug_8');
PERFORM common_create_drug(TRUE,TRUE,'drug_9');
PERFORM common_create_drug(FALSE,TRUE,'drug_10_inactive');
PERFORM common_create_drug(FALSE,TRUE,'drug_11_inactive');


success=true;
return success;
END
$$ LANGUAGE plpgsql;