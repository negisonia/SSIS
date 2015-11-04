CREATE OR REPLACE FUNCTION  test_data_custom_criteria_groups()--ADMIN DB
RETURNS BOOLEAN AS $$
DECLARE
success BOOLEAN DEFAULT FALSE;
BEGIN


--REPORT 1 GROUPS
PERFORM common_create_custom_criteria_group('rep_1_group_1', 'indication_1',FALSE);
PERFORM common_create_custom_criteria_group('rep_1_group_2', 'indication_1',FALSE);
PERFORM common_create_custom_criteria_group('rep_1_group_3', 'indication_1',FALSE);
PERFORM common_create_custom_criteria_group('rep_1_group_single', 'indication_1',FALSE);
PERFORM common_create_custom_criteria_group('rep_1_group_all', 'indication_1',FALSE);
PERFORM common_create_custom_criteria_group('rep_1_group_both', 'indication_1',FALSE);
PERFORM common_create_custom_criteria_group('rep_1_group_steps', 'indication_1',FALSE);

--REPORT 3 GROUPS
PERFORM common_create_custom_criteria_group('rep_3_group_1', 'indication_1',TRUE);
PERFORM common_create_custom_criteria_group('rep_3_group_1', 'indication_3',TRUE);
PERFORM common_create_custom_criteria_group('rep_3_group_2', 'indication_1',TRUE);
PERFORM common_create_custom_criteria_group('rep_3_group_2', 'indication_3',TRUE);
--REPORT 4 GROUPS
PERFORM common_create_custom_criteria_group('rep_4_group_1', 'indication_1',FALSE);

success:= TRUE;
RETURN success;

END
$$ LANGUAGE plpgsql;

