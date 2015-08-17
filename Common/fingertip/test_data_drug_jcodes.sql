CREATE OR REPLACE FUNCTION test_data_drug_jcodes() --FF NEW DB
RETURNS boolean AS $$
DECLARE
drug_jcode_j9678 INTEGER;
drug_jcode_j675 INTEGER;
success BOOLEAN:=FALSE;
intValue INTEGER;
BEGIN


--RETRIEVE JCODES
SELECT j.id FROM jcodes j WHERE j.name='J9678' INTO drug_jcode_j9678;
SELECT j.id FROM jcodes j WHERE j.name='J675' INTO drug_jcode_j675;

SELECT d.id into intValue FROM drug d WHERE d.name='drug_2';
PERFORM common_create_drug_jcodes(intValue,drug_jcode_j9678);

SELECT d.id into intValue FROM drug d WHERE d.name='drug_6';
PERFORM common_create_drug_jcodes(intValue,drug_jcode_j675);



success=true;
return success;
END
$$ LANGUAGE plpgsql;