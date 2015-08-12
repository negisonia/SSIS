CREATE OR REPLACE FUNCTION test_data_drug_drug_classes() --FF NEW DB
RETURNS boolean AS $$
DECLARE

drug_class_1 INTEGER;
drug_class_2 INTEGER;
drug_class_3 INTEGER;

success BOOLEAN:=FALSE;
intValue INTEGER;
BEGIN


--RETRIEVE DRUG CLASSES
SELECT dc.id INTO drug_class_1 FROM drugclass dc WHERE dc.name='drug_class_1';
SELECT dc.id INTO drug_class_2 FROM drugclass dc WHERE dc.name='drug_class_2';
SELECT dc.id INTO drug_class_3 FROM drugclass dc WHERE dc.name='drug_class_3';

--CREATE DRUG DRUG CLASSES
--Drug1
SELECT d.id into intValue FROM drug d WHERE d.name='drug_1';
PERFORM common_create_drug_drug_class(intValue,drug_class_1);

--Drug2
SELECT d.id into intValue FROM drug d WHERE d.name='drug_2';
PERFORM common_create_drug_drug_class(intValue,drug_class_1);

--Drug3
SELECT d.id into intValue FROM drug d WHERE d.name='drug_3';
PERFORM common_create_drug_drug_class(intValue,drug_class_1);

--Drug4
SELECT d.id into intValue FROM drug d WHERE d.name='drug_4';
PERFORM common_create_drug_drug_class(intValue,drug_class_1);

--Drug5
SELECT d.id into intValue FROM drug d WHERE d.name='drug_5';
PERFORM common_create_drug_drug_class(intValue,drug_class_2);

--Drug6
SELECT d.id into intValue FROM drug d WHERE d.name='drug_6';
PERFORM common_create_drug_drug_class(intValue,drug_class_2);

--Drug7
SELECT d.id into intValue FROM drug d WHERE d.name='drug_7';
PERFORM common_create_drug_drug_class(intValue,drug_class_2);

--Drug8
SELECT d.id into intValue FROM drug d WHERE d.name='drug_8';
PERFORM common_create_drug_drug_class(intValue,drug_class_2);


--Drug9
SELECT d.id into intValue FROM drug d WHERE d.name='drug_9';
PERFORM common_create_drug_drug_class(intValue,drug_class_3);

--Drug10
SELECT d.id into intValue FROM drug d WHERE d.name='drug_10_inactive';
PERFORM common_create_drug_drug_class(intValue,drug_class_1);

--Drug11
SELECT d.id into intValue FROM drug d WHERE d.name='drug_11_inactive';
PERFORM common_create_drug_drug_class(intValue,drug_class_1);

success=true;
return success;
END
$$ LANGUAGE plpgsql;