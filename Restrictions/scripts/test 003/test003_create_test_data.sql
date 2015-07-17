CREATE OR REPLACE FUNCTION restrictions_test_003_create_test_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE

jcode1 INTEGER;
jcode2 INTEGER;

drug_class_1 INTEGER;
drug_class_2 INTEGER;
drug_class_3 INTEGER;

drug_names VARCHAR[] := ARRAY['restrictions_drug_1','restrictions_drug_2','restrictions_drug_3','restrictions_drug_4','restrictions_drug_5','restrictions_drug_6','restrictions_drug_7','restrictions_drug_8','restrictions_drug_9','restrictions_drug_10','restrictions_drug_11'];
success BOOLEAN:=FALSE;

textValue VARCHAR;
BEGIN


--CREATE JCODES
SELECT common_create_jcode('J9678') INTO jcode1;
SELECT common_create_jcode('J675') INTO jcode2;

--CREATE DRUG CLASSES
SELECT common_create_drugclass(TRUE,'restrictions_drug_class_1','restrictions_drug_class_1','restrictions_drug_class_1','restrictions_drug_class_1') INTO drug_class_1;
SELECT common_create_drugclass(TRUE,'restrictions_drug_class_2','restrictions_drug_class_2','restrictions_drug_class_2','restrictions_drug_class_2') INTO drug_class_1;
SELECT common_create_drugclass(TRUE,'restrictions_drug_class_3','restrictions_drug_class_3','restrictions_drug_class_3','restrictions_drug_class_3') INTO drug_class_1;



--ITERATE DRUGS NAMES
FOREACH textValue IN ARRAY drug_names
LOOP


	
END LOOP;

success=true;
return success;
END
$$ LANGUAGE plpgsql;