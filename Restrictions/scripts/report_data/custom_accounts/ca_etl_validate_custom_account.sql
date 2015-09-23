CREATE OR REPLACE FUNCTION ca_etl_validate_custom_account(custom_account_name varchar, client_name varchar, custom_accounts_table_name varchar, client_table_name varchar, id_colum varchar) --Data Warehouse
RETURNS INTEGER AS $$
DECLARE
  ca_id INTEGER;
  client_id INTEGER;
BEGIN

  SELECT common_get_table_id_by_name(client_table_name, client_name) INTO client_id;
  EXECUTE 'SELECT ' || id_colum || ' from ' || custom_accounts_table_name || ' ca where ca.name = ''' || custom_account_name || ''' AND ca.client_id = ''' || client_id || ''' limit 1' INTO ca_id;
  IF ca_id IS NULL THEN
    select throw_error('ca_etl_test-error: EXPECTED Custom acccount named: ' || custom_account_name || ' and client name: ' || client_name);
  END IF;

  RETURN ca_id;
END
$$ LANGUAGE plpgsql;
