CREATE OR REPLACE FUNCTION test_data_drug_drug_classes() --FF NEW DB
RETURNS boolean AS $$
DECLARE

drug_class_1 INTEGER;
drug_class_2 INTEGER;
drug_class_3 INTEGER;
drug_class_001 INTEGER;
drug_class_002 INTEGER;

drug VARCHAR:='drug';
drug_class VARCHAR:='drugclass';

success BOOLEAN:=FALSE;
intValue INTEGER;
BEGIN

--RETRIEVE DRUG CLASSES
SELECT common_get_table_id_by_name(drug_class, 'drug_class_1') INTO drug_class_1;
SELECT common_get_table_id_by_name(drug_class, 'drug_class_2') INTO drug_class_2;
SELECT common_get_table_id_by_name(drug_class, 'drug_class_3') INTO drug_class_3;
SELECT common_get_table_id_by_name(drug_class, 'DRUG_CLASS_001') INTO drug_class_001;
SELECT common_get_table_id_by_name(drug_class, 'DRUG_CLASS_002') INTO drug_class_002;

--CREATE DRUG DRUG CLASSES
--Drug1
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_1'),drug_class_1);
--Drug2
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_2'),drug_class_1);
--Drug3
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_3'),drug_class_1);
--Drug4
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_4'),drug_class_1);
--Drug5
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_5'),drug_class_2);
--Drug6
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_6'),drug_class_2);
--Drug7
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_7'),drug_class_2);
--Drug8
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_8'),drug_class_2);
--Drug9
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_9'),drug_class_3);
--Drug10
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_10_inactive'),drug_class_1);
--Drug11
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'drug_11_inactive'), drug_class_1);

PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'DRUG_001') , drug_class_001);
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'DRUG_002') , drug_class_001);
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'DRUG_003') , drug_class_001);
PERFORM common_create_drug_drug_class(common_get_table_id_by_name(drug, 'DRUG_004') , drug_class_001);


success=true;
return success;
END
$$ LANGUAGE plpgsql;