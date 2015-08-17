CREATE OR REPLACE FUNCTION test_data_steps_custom_options() --DATA ENTRY
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
custom_option_1 INTEGER;
custom_option_2 INTEGER;
custom_option_3 INTEGER;
custom_option_4 INTEGER;

drug_8 INTEGER;

drug_class_4 INTEGER;
drug_class_5 INTEGER;

BEGIN

--RETRIEVE CUSTOM OPTIONS
SELECT co.id INTO custom_option_1 FROM custom_options co WHERE co.name='custom_option_1';
SELECT co.id INTO custom_option_2 FROM custom_options co WHERE co.name='custom_option_2';
SELECT co.id INTO custom_option_3 FROM custom_options co WHERE co.name='custom_option_3';
SELECT co.id INTO custom_option_4 FROM custom_options co WHERE co.name='custom_option_4';

--RETRIEVE DRUG IDS
SELECT d.id INTO drug_8 FROM ff.drugs_import d WHERE d.name='drug_8';

--RETRIEVE DRUG CLASS
SELECT dc.id INTO drug_class_4 FROM ff.drug_classes_import dc WHERE dc.name = 'drug_class_4';
SELECT dc.id INTO drug_class_5 FROM ff.drug_classes_import dc WHERE dc.name = 'drug_class_5';

PERFORM common_create_step_custom_option(custom_option_1,'CustomOption');
PERFORM common_create_step_custom_option(custom_option_2,'CustomOption');
PERFORM common_create_step_custom_option(custom_option_3,'CustomOption');
PERFORM common_create_step_custom_option(custom_option_4,'CustomOption');
PERFORM common_create_step_custom_option(drug_8,'Drug');
PERFORM common_create_step_custom_option(drug_class_4,'DrugClass');
PERFORM common_create_step_custom_option(drug_class_5,'DrugClass');

success=true;
return success;
END
$$ LANGUAGE plpgsql;