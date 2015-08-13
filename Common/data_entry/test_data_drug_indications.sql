CREATE OR REPLACE FUNCTION test_data_drug_indications() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
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

BEGIN

--RETRIEVE INDICATIONS
SELECT i.id from indications i WHERE i.name='indication_1' INTO indication_1_id;
SELECT i.id from indications i WHERE i.name='indication_2' INTO indication_2_id;
SELECT i.id from indications i WHERE i.name='indication_3' INTO indication_3_id;
SELECT i.id from indications i WHERE i.name='indication_4' INTO indication_4_id;
SELECT i.id from indications i WHERE i.name='indication_5' INTO indication_5_id;


--RETRIEVE DRUG IDS
SELECT d.id INTO drug_1 FROM ff.drugs_import d WHERE d.name='drug_1';
SELECT d.id INTO drug_2 FROM ff.drugs_import d WHERE d.name='drug_2';
SELECT d.id INTO drug_3 FROM ff.drugs_import d WHERE d.name='drug_3';
SELECT d.id INTO drug_4 FROM ff.drugs_import d WHERE d.name='drug_4';
SELECT d.id INTO drug_5 FROM ff.drugs_import d WHERE d.name='drug_5';
SELECT d.id INTO drug_6 FROM ff.drugs_import d WHERE d.name='drug_6';
SELECT d.id INTO drug_7 FROM ff.drugs_import d WHERE d.name='drug_7';
SELECT d.id INTO drug_8 FROM ff.drugs_import d WHERE d.name='drug_8';
SELECT d.id INTO drug_9 FROM ff.drugs_import d WHERE d.name='drug_9';
SELECT d.id INTO drug_10 FROM ff.drugs_import d WHERE d.name='drug_10_inactive';
SELECT d.id INTO drug_11 FROM ff.drugs_import d WHERE d.name='drug_11_inactive';

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

success=true;
return success;
END
$$ LANGUAGE plpgsql;