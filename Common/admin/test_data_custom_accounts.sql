CREATE OR REPLACE FUNCTION test_data_custom_accounts() --FF NEW
RETURNS boolean AS $$
DECLARE
client VARCHAR:='clients';
provider VARCHAR:='provider_import';
health_plan VARCHAR:='health_plan_import';

success BOOLEAN:=FALSE;
BEGIN

--CREATE CUSTOM ACCOUNTS
PERFORM create_custom_account('Custom_Account_1', common_get_table_id_by_name(client, 'Client_1'), ARRAY[common_get_table_id_by_name(provider, 'provider_1')], ARRAY[common_get_table_id_by_name(health_plan, 'health_plan_comm'),common_get_table_id_by_name(health_plan, 'health_plan_comm_1')]);
PERFORM create_custom_account('Custom_Account_2', common_get_table_id_by_name(client, 'Client_2'), ARRAY[common_get_table_id_by_name(provider, 'provider_1')], ARRAY[common_get_table_id_by_name(health_plan, 'health_plan_comm'),common_get_table_id_by_name(health_plan, 'health_plan_hix')]);
PERFORM create_custom_account('Custom_Account_3', common_get_table_id_by_name(client, 'Client_1'), ARRAY[common_get_table_id_by_name(provider, 'provider_1'),common_get_table_id_by_name(provider, 'provider_7')], ARRAY[common_get_table_id_by_name(health_plan, 'health_plan_comm'),common_get_table_id_by_name(health_plan, 'health_plan_bcbs')]);

success=true;
return success;
END
$$ LANGUAGE plpgsql;