CREATE OR REPLACE FUNCTION res_ca_etl_test_create_report_1_criteria_report_data() --FF NEW DB
RETURNS INTEGER AS $$
DECLARE

drug_1_id INTEGER;
drug_2_id INTEGER;
criteria_report_id INTEGER;

new_report_id INTEGER;
existing_client_id INTEGER;
existing_custom_account_id INTEGER;

drugs CONSTANT VARCHAR:='drugs';

BEGIN

--GET the input data

SELECT common_get_table_id_by_name(drugs, 'drug_1') INTO drug_1_id;
SELECT common_get_table_id_by_name(drugs, 'drug_2') INTO drug_2_id;

SELECT report_id from criteria_restriction_reports where report_name = 'report_1' INTO new_report_id;
SELECT common_get_table_id_by_name('clients', 'client_2') INTO existing_client_id;
SELECT custom_account_id from custom_accounts where name = 'Custom_Account_2' and client_id = existing_client_id INTO existing_custom_account_id;

SELECT create_criteria_report(new_report_id,0,NULL,0,4,FALSE,FALSE,FALSE,ARRAY[drug_1_id,drug_2_id],ARRAY[]::integer[],'National',ARRAY[]::integer[],existing_custom_account_id,'national',NULL,NULL,NULL,NULL) INTO criteria_report_id;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;