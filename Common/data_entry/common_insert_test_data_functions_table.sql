CREATE OR REPLACE FUNCTION common_insert_test_data_functions_table()--ADMIN
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
BEGIN

DROP TABLE IF EXISTS test_data_functions;
CREATE TABLE test_data_functions
(
  id serial primary key,
  name varchar(255) NOT NULL,
  order_id integer NOT NULL
);

PERFORM common_create_test_data_functions('test_data_criteria',1);
PERFORM common_create_test_data_functions('test_data_indications',2);
PERFORM common_create_test_data_functions('test_data_custom_options',3);
PERFORM common_create_test_data_functions('test_data_restrictions',4);
PERFORM common_create_test_data_functions('test_data_criteria_restrictions',5);
PERFORM common_create_test_data_functions('test_data_criteria_indications',6);
PERFORM common_create_test_data_functions('test_data_drug_class_indication',7);
PERFORM common_create_test_data_functions('test_data_drug_indications',8);
PERFORM common_create_test_data_functions('test_data_steps_custom_options',9);
PERFORM common_create_test_data_functions('test_data_indication_step_custom_options',10);
PERFORM common_create_test_data_functions('test_data_medicals',11);
PERFORM common_create_test_data_functions('test_data_prior_authorizations',12);
PERFORM common_create_test_data_functions('test_data_quantity_limits',13);
PERFORM common_create_test_data_functions('test_data_step_therapies',14);


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
