CREATE OR REPLACE FUNCTION test_data_indication_step_custom_options() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

indication_1_id INTEGER;
indication_2_id INTEGER;
indication_3_id INTEGER;
indication_4_id INTEGER;
indication_5_id INTEGER;

custom_option_1 INTEGER;
custom_option_2 INTEGER;
custom_option_3 INTEGER;
custom_option_4 INTEGER;

drug_8 INTEGER;

drug_class_4 INTEGER;
drug_class_5 INTEGER;

step_custom_option_id INTEGER;

BEGIN

--RETRIEVE INDICATIONS
SELECT i.id from indications i WHERE i.name='indication_1' INTO indication_1_id;
SELECT i.id from indications i WHERE i.name='indication_2' INTO indication_2_id;
SELECT i.id from indications i WHERE i.name='indication_3' INTO indication_3_id;
SELECT i.id from indications i WHERE i.name='indication_4' INTO indication_4_id;
SELECT i.id from indications i WHERE i.name='indication_5' INTO indication_5_id;

SELECT co.id INTO custom_option_1 FROM custom_options co WHERE co.name='custom_option_1');
SELECT co.id INTO custom_option_2 FROM custom_options co WHERE co.name='custom_option_2');
SELECT co.id INTO custom_option_3 FROM custom_options co WHERE co.name='custom_option_3');
SELECT co.id INTO custom_option_4 FROM custom_options co WHERE co.name='custom_option_4');

--RETRIEVE DRUG IDS
SELECT d.id INTO drug_8 FROM ff.drugs_import d WHERE d.name='drug_8';

--RETRIEVE DRUG CLASS
SELECT dc.id INTO drug_class_4 FROM ff.drug_classes_import dc WHERE dc.name = 'drug_class_4';
SELECT dc.id INTO drug_class_5 FROM ff.drug_classes_import dc WHERE dc.name = 'drug_class_5';

SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_1 and sco.customizable_type='CustomOption';
PERFORM common_create_indications_step_custom_options(indication_1_id,step_custom_option_id);

SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_2 and sco.customizable_type='CustomOption';
PERFORM common_create_indications_step_custom_options(indication_1_id,step_custom_option_id);

SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_3 and sco.customizable_type='CustomOption';
PERFORM common_create_indications_step_custom_options(indication_2_id,step_custom_option_id);
PERFORM common_create_indications_step_custom_options(indication_3_id,step_custom_option_id);

SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=custom_option_4 and sco.customizable_type='CustomOption';
PERFORM common_create_indications_step_custom_options(indication_3_id,step_custom_option_id);

SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=drug_8 and sco.customizable_type='Drug';
PERFORM common_create_indications_step_custom_options(indication_2_id,step_custom_option_id);

SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=drug_class_4 and sco.customizable_type='DrugClass';
PERFORM common_create_indications_step_custom_options(indication_3_id,step_custom_option_id);

SELECT sco.id INTO  step_custom_option_id FROM step_custom_options sco WHERE sco.customizable_id=drug_class_5 and sco.customizable_type='DrugClass';
PERFORM common_create_indications_step_custom_options(indication_3_id,step_custom_option_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;