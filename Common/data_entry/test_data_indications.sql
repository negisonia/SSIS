CREATE OR REPLACE FUNCTION test_data_indications() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE INDICATIONS
PERFORM common_create_indication('indication_1', 'Ind1');
PERFORM common_create_indication('indication_2', 'Ind2');
PERFORM common_create_indication('indication_3', 'Ind3');
PERFORM common_create_indication('indication_4', 'Ind4');
PERFORM common_create_indication('indication_5', 'Ind5');



success=true;
return success;
END
$$ LANGUAGE plpgsql;