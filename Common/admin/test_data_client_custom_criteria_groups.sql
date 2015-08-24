CREATE OR REPLACE FUNCTION test_data_client_custom_criteria_groups()--ADMIN DB
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;

client_1 INTEGER;
client_2 INTEGER;
client_3 INTEGER;
client_4 INTEGER;

rep_1_group_1 INTEGER;
rep_1_group_2 INTEGER;
rep_1_group_3 INTEGER;
rep_1_group_single INTEGER;
rep_1_group_all INTEGER;
rep_1_group_both INTEGER;
rep_1_group_steps INTEGER;
rep_3_group_1 INTEGER;
rep_4_group_1 INTEGER;

report_1 INTEGER;
report_2 INTEGER;
report_3 INTEGER;
report_4 INTEGER;

report_1_client_1 INTEGER;
report_1_client_2 INTEGER;
report_4_client_4 INTEGER;
report_2_client_2 INTEGER;
report_3_client_1 INTEGER;
report_3_client_3 INTEGER;

BEGIN

--RETRIEVE CLIENT IDS
SELECT c.id INTO client_1 FROM clients c WHERE c.name='client_1';
SELECT c.id INTO client_2 FROM clients c WHERE c.name='client_2';
SELECT c.id INTO client_3 FROM clients c WHERE c.name='client_3';
SELECT c.id INTO client_4 FROM clients c WHERE c.name='client_4';

--RETRIEVE CUSTOM GROUP IDS
SELECT ccg.id INTO rep_1_group_1 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_1' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_2 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_2' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_3 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_3' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_single FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_single' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_all FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_all' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_both FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_both' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_1_group_steps FROM custom_criteria_groups ccg  WHERE ccg.name='rep_1_group_steps' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_3_group_1 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_3_group_1' and ccg.indication_field_name='indication_1';
SELECT ccg.id INTO rep_4_group_1 FROM custom_criteria_groups ccg  WHERE ccg.name='rep_4_group_1' and ccg.indication_field_name='indication_1';

--RETRIEVE REPORTS
SELECT r.id INTO report_1 FROM reports r WHERE r.name='report_1' and r.business_id ='report_1' LIMIT 1;
SELECT r.id INTO report_2 FROM reports r WHERE r.name='report_2' and r.business_id ='report_2' LIMIT 1;
SELECT r.id INTO report_3 FROM reports r WHERE r.name='report_3' and r.business_id ='report_3' LIMIT 1;
SELECT r.id INTO report_4 FROM reports r WHERE r.name='report_4' and r.business_id ='report_4' LIMIT 1;

--RETRIEVE REPORT CLIENTS
SELECT rc.id INTO report_1_client_1 FROM report_clients rc WHERE rc.report_id=report_1 AND rc.client_id=client_1;
SELECT rc.id INTO report_1_client_2 FROM report_clients rc WHERE rc.report_id=report_1 AND rc.client_id=client_2;
SELECT rc.id INTO report_4_client_4 FROM report_clients rc WHERE rc.report_id=report_4 AND rc.client_id=client_4;
SELECT rc.id INTO report_2_client_2 FROM report_clients rc WHERE rc.report_id=report_2 AND rc.client_id=client_2;
SELECT rc.id INTO report_3_client_1 FROM report_clients rc WHERE rc.report_id=report_3 AND rc.client_id=client_1;
SELECT rc.id INTO report_3_client_3 FROM report_clients rc WHERE rc.report_id=report_3 AND rc.client_id=client_3;

PERFORM common_create_client_custom_criteria_group(report_1_client_1,rep_1_group_1, 1, TRUE);
PERFORM common_create_client_custom_criteria_group(report_1_client_2,rep_1_group_1, 1, TRUE);
PERFORM common_create_client_custom_criteria_group(report_1_client_1,rep_1_group_2, 2, TRUE);
PERFORM common_create_client_custom_criteria_group(report_1_client_2,rep_1_group_3, 2, TRUE);
PERFORM common_create_client_custom_criteria_group(report_1_client_1,rep_1_group_single, 3, TRUE);
PERFORM common_create_client_custom_criteria_group(report_1_client_1,rep_1_group_all, 4, TRUE);
PERFORM common_create_client_custom_criteria_group(report_1_client_1,rep_1_group_both, 5, TRUE);
PERFORM common_create_client_custom_criteria_group(report_1_client_1,rep_1_group_steps, 6, TRUE);
PERFORM common_create_client_custom_criteria_group(report_4_client_4,rep_4_group_1, 1, TRUE);
PERFORM common_create_client_custom_criteria_group(report_3_client_1,rep_3_group_1, 1, TRUE);
PERFORM common_create_client_custom_criteria_group(report_3_client_3,rep_3_group_1, 1, TRUE);


success:= TRUE;
RETURN success;

END
$$ LANGUAGE plpgsql;

