CREATE OR REPLACE FUNCTION restrictions_test_009_create_test_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE
indication_1_id INTEGER;
indication_2_id INTEGER;
indication_3_id INTEGER;
indication_4_id INTEGER;
indication_5_id INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;
drug_3 INTEGER;
drug_4 INTEGER;
drug_5 INTEGER;
drug_6 INTEGER;
drug_7 INTEGER;
drug_8 INTEGER;
drug_9 INTEGER;
drug_10 INTEGER;
drug_11 INTEGER;

drug_class_1 INTEGER;
drug_class_2 INTEGER;
drug_class_3 INTEGER;
drug_class_4 INTEGER;
drug_class_5 INTEGER;

success BOOLEAN DEFAULT FALSE;
BEGIN

--RETRIEVE DRUG IDS
SELECT d.id INTO drug_1 FROM ff.drugs_import d WHERE d.name='restrictions_drug_1';
SELECT d.id INTO drug_2 FROM ff.drugs_import d WHERE d.name='restrictions_drug_2';
SELECT d.id INTO drug_3 FROM ff.drugs_import d WHERE d.name='restrictions_drug_3';
SELECT d.id INTO drug_4 FROM ff.drugs_import d WHERE d.name='restrictions_drug_4';
SELECT d.id INTO drug_5 FROM ff.drugs_import d WHERE d.name='restrictions_drug_5';
SELECT d.id INTO drug_6 FROM ff.drugs_import d WHERE d.name='restrictions_drug_6';
SELECT d.id INTO drug_7 FROM ff.drugs_import d WHERE d.name='restrictions_drug_7';
SELECT d.id INTO drug_8 FROM ff.drugs_import d WHERE d.name='restrictions_drug_8';
SELECT d.id INTO drug_9 FROM ff.drugs_import d WHERE d.name='restrictions_drug_9';
SELECT d.id INTO drug_10 FROM ff.drugs_import d WHERE d.name='restrictions_drug_10';
SELECT d.id INTO drug_11 FROM ff.drugs_import d WHERE d.name='restrictions_drug_11';

--RETRIEVE DRUG CLASSES
SELECT dc.id INTO drug_class_1 FROM ff.drug_classes_import dc WHERE dc.name = 'restrictions_drug_class_1';
SELECT dc.id INTO drug_class_2 FROM ff.drug_classes_import dc WHERE dc.name = 'restrictions_drug_class_2';
SELECT dc.id INTO drug_class_3 FROM ff.drug_classes_import dc WHERE dc.name = 'restrictions_drug_class_3';

--CREATE INDICATION 1
SELECT common_create_indication('restrictions_indication_1', 'Ind1') INTO indication_1_id;
SELECT common_create_indication('restrictions_indication_2', 'Ind2') INTO indication_2_id;
SELECT common_create_indication('restrictions_indication_3', 'Ind3') INTO indication_3_id;
SELECT common_create_indication('restrictions_indication_4', 'Ind4') INTO indication_4_id;
SELECT common_create_indication('restrictions_indication_5', 'Ind5') INTO indication_5_id;

--CREATE DRUG INDICATIONS
--indication # 1
PERFORM common_create_drug_indication(indication_1_id,drug_1);
PERFORM common_create_drug_indication(indication_1_id,drug_2);
PERFORM common_create_drug_indication(indication_1_id,drug_3);
PERFORM common_create_drug_indication(indication_1_id,drug_4);

--indication # 2
PERFORM common_create_drug_indication(indication_2_id,drug_5);
PERFORM common_create_drug_indication(indication_2_id,drug_6);
PERFORM common_create_drug_indication(indication_2_id,drug_7);

--indication # 3
PERFORM common_create_drug_indication(indication_3_id,drug_1);
PERFORM common_create_drug_indication(indication_3_id,drug_2);
PERFORM common_create_drug_indication(indication_3_id,drug_9);

--CREATE DRUG CLASS INDICATIONS
PERFORM common_create_drug_class_indication(indication_1_id,drug_class_1);
PERFORM common_create_drug_class_indication(indication_2_id,drug_class_2);
PERFORM common_create_drug_class_indication(indication_3_id,drug_class_1);
PERFORM common_create_drug_class_indication(indication_3_id,drug_class_3);
PERFORM common_create_drug_class_indication(indication_4_id,drug_class_1);

success=true;
return success;
END
$$ LANGUAGE plpgsql;