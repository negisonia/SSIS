CREATE OR REPLACE FUNCTION restrictions_test_003_create_test_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE

jcode1 INTEGER;
jcode2 INTEGER;

drug_class_1 INTEGER;
drug_class_2 INTEGER;
drug_class_3 INTEGER;

drug_names VARCHAR[] := ARRAY['drug_1','drug_2','drug_3','drug_4','drug_5','drug_6','drug_7','drug_8','drug_9','drug_10','drug_11'];
success BOOLEAN:=FALSE;

textValue VARCHAR;
intValue INTEGER;
BEGIN


--CREATE JCODES
SELECT common_create_jcode('J9678') INTO jcode1;
SELECT common_create_jcode('J675') INTO jcode2;

--CREATE DRUG CLASSES
SELECT common_create_drugclass(TRUE,'drug_class_1') INTO drug_class_1;
SELECT common_create_drugclass(TRUE,'drug_class_2') INTO drug_class_2;
SELECT common_create_drugclass(TRUE,'drug_class_3') INTO drug_class_3;

--ITERATE DRUGS NAMES
FOREACH textValue IN ARRAY drug_names
LOOP
	CASE textValue 
		WHEN 'drug_1' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_1);
		WHEN 'drug_2' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;	
			PERFORM common_create_drug_jcodes(intValue,jcode1);
			PERFORM common_create_drug_drug_class(intValue,drug_class_1);
		WHEN 'drug_3' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_1);
		WHEN 'drug_4' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_1);
		WHEN 'drug_5' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_2);
		WHEN 'drug_6' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_jcodes(intValue,jcode2);
			PERFORM common_create_drug_drug_class(intValue,drug_class_2);
		WHEN 'drug_7' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_2);
		WHEN 'drug_8' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_2);
		WHEN 'drug_9' THEN
			SELECT common_create_drug(TRUE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_3);
		WHEN 'drug_10' THEN
			SELECT common_create_drug(FALSE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_1);
		WHEN 'drug_11' THEN
			SELECT common_create_drug(FALSE,TRUE,textValue) INTO intValue;
			PERFORM common_create_drug_drug_class(intValue,drug_class_1);
		ELSE
			RAISE NOTICE 'ELSE CASE';
	END CASE;
	
	
END LOOP;

success=true;
return success;
END
$$ LANGUAGE plpgsql;