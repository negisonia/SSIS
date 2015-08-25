CREATE OR REPLACE FUNCTION ca_etl_test_1() --Data Warehouse
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT FALSE;
  custom_account_id INTEGER;
  id_column CONSTANT VARCHAR:='id';
  custom_account_table_name CONSTANT VARCHAR:='admin.custom_accounts';
  health_plan_table_name CONSTANT VARCHAR:='ff.health_plans';
  client_table_name CONSTANT VARCHAR:='admin.clients';
  provider_table_name CONSTANT VARCHAR:='ff.providers';
BEGIN

 SELECT ca_etl_validate_custom_account('Custom_Account_1', 'client_1', custom_account_table_name, client_table_name, id_column) INTO custom_account_id;
 PERFORM ca_etl_validate_custom_account_criteria(custom_account_id, ARRAY['provider_1'], ARRAY['health_plan_comm','health_plan_comm_1'], health_plan_table_name, provider_table_name);

 SELECT ca_etl_validate_custom_account('Custom_Account_2', 'client_2', custom_account_table_name, client_table_name, id_column) INTO custom_account_id;
 PERFORM ca_etl_validate_custom_account_criteria(custom_account_id, ARRAY['provider_1'], ARRAY['health_plan_comm','health_plan_hix'], health_plan_table_name, provider_table_name); 

 SELECT ca_etl_validate_custom_account('Custom_Account_3', 'client_1', custom_account_table_name, client_table_name, id_column) INTO custom_account_id;
 PERFORM ca_etl_validate_custom_account_criteria(custom_account_id, ARRAY['provider_1','provider_7'], ARRAY['health_plan_comm','health_plan_bcbs'], health_plan_table_name, provider_table_name);  

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;
