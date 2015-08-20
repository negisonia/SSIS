CREATE OR REPLACE FUNCTION test_data_custom_accounts() --FF NEW
RETURNS boolean AS $$
DECLARE
client VARCHAR:='clients';
success BOOLEAN:=FALSE;
BEGIN

--CREATE REASON CODES
PERFORM create_custom_account('Custom_Account_1', common_get_table_id_by_name(client, 'Client_1'));
PERFORM create_custom_account('Custom_Account_2', common_get_table_id_by_name(client, 'Client_2'));
PERFORM create_custom_account('Custom_Account_3', common_get_table_id_by_name(client, 'Client_1'));

success=true;
return success;
END
$$ LANGUAGE plpgsql;