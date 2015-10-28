CREATE OR REPLACE FUNCTION test_data_custom_accounts() --FF NEW
RETURNS boolean AS $$
DECLARE
client VARCHAR:='clients';
provider VARCHAR:='provider_import';
health_plan VARCHAR:='health_plan_import';

success BOOLEAN:=FALSE;
BEGIN

--CREATE CUSTOM ACCOUNTS
PERFORM create_custom_account('Custom_Account_1', common_get_table_id_by_name(client, 'client_1'), ARRAY[]::integer[], ARRAY[common_get_table_id_by_name(health_plan, 'health_plan_comm'),common_get_table_id_by_name(health_plan, 'health_plan_comm_1')],false);
PERFORM create_custom_account('Custom_Account_2', common_get_table_id_by_name(client, 'client_2'), ARRAY[]::integer[], ARRAY[common_get_table_id_by_name(health_plan, 'health_plan_comm'),common_get_table_id_by_name(health_plan, 'health_plan_hix'),common_get_table_id_by_name(health_plan, 'health_plan_comm_1')],false);
PERFORM create_custom_account('Custom_Account_3', common_get_table_id_by_name(client, 'client_1'), ARRAY[]::integer[], ARRAY[common_get_table_id_by_name(health_plan, 'health_plan_comm'),common_get_table_id_by_name(health_plan, 'health_plan_bcbs')],false);
PERFORM create_custom_account('Custom_Account_4', common_get_table_id_by_name(client, 'client_1'), ARRAY[]::integer[], ARRAY[common_get_table_id_by_name(health_plan, 'health_plan_comm'),common_get_table_id_by_name(health_plan, 'health_plan_comm_1'),common_get_table_id_by_name(health_plan, 'health_plan_bcbs'),common_get_table_id_by_name(health_plan, 'health_plan_ma_1')],false);

success=true;
return success;
END
$$ LANGUAGE plpgsql;