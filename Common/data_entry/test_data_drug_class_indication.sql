CREATE OR REPLACE FUNCTION test_data_drug_class_indication() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

indication_1_id INTEGER;
indication_2_id INTEGER;
indication_3_id INTEGER;
indication_4_id INTEGER;

drug_class_1 INTEGER;
drug_class_2 INTEGER;
drug_class_3 INTEGER;

BEGIN

--RETRIEVE INDICATIONS
SELECT i.id from indications i WHERE i.name='indication_1' INTO indication_1_id;
SELECT i.id from indications i WHERE i.name='indication_2' INTO indication_2_id;
SELECT i.id from indications i WHERE i.name='indication_3' INTO indication_3_id;
SELECT i.id from indications i WHERE i.name='indication_4' INTO indication_4_id;

--RETRIEVE DRUG CLASSES
SELECT dc.id INTO drug_class_1 FROM ff.drug_classes_import dc WHERE dc.name = 'drug_class_1';
SELECT dc.id INTO drug_class_2 FROM ff.drug_classes_import dc WHERE dc.name = 'drug_class_2';
SELECT dc.id INTO drug_class_3 FROM ff.drug_classes_import dc WHERE dc.name = 'drug_class_3';

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