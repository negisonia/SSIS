CREATE OR REPLACE FUNCTION ca_etl_test_2() --Front End
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  custom_account_id INTEGER;
  id_column CONSTANT VARCHAR:='custom_account_id';
  custom_account_table_name CONSTANT VARCHAR:='custom_accounts';
  client_table_name CONSTANT VARCHAR:='clients';
BEGIN

 SELECT ca_etl_validate_custom_account('Custom_Account_1', 'client_1', custom_account_table_name, client_table_name, id_column) INTO custom_account_id;
 SELECT ca_etl_validate_custom_account('Custom_Account_2', 'client_2', custom_account_table_name, client_table_name, id_column) INTO custom_account_id;
 SELECT ca_etl_validate_custom_account('Custom_Account_3', 'client_1', custom_account_table_name, client_table_name, id_column) INTO custom_account_id;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
