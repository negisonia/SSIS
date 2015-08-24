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

PERFORM common_create_test_data_functions('test_data_client',1);
PERFORM common_create_test_data_functions('test_data_custom_accounts',2);

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
