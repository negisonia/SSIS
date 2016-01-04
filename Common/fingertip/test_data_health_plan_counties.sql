CREATE OR REPLACE FUNCTION test_data_health_plan_counties() --FF NEW
RETURNS boolean AS $$
DECLARE

county_001_id INTEGER;
county_002_id INTEGER;
county_003_id INTEGER;
county_004_id INTEGER;
county_middlesex_ma_id INTEGER;
county_bristol_ma_id INTEGER;
county_new_london_ct_id INTEGER;
county_franklin_ma_id INTEGER;
county_middlesex_ct_id INTEGER;
county_strafford_nh_id INTEGER;
county_hartford_ct_id INTEGER;
county_005_id INTEGER;
county_006_id INTEGER;
county_007_id INTEGER;
county_008_id INTEGER;

health_plan VARCHAR:='healthplan';
county VARCHAR:='county';

success BOOLEAN:=FALSE;

BEGIN
    
--RETRIEVE COUNTIES
    SELECT common_get_table_id_by_name(county,'COUNTY_001') INTO county_001_id;
    SELECT common_get_table_id_by_name(county,'COUNTY_002') INTO county_002_id;
    SELECT common_get_table_id_by_name(county,'COUNTY_003') INTO county_003_id;
    SELECT common_get_table_id_by_name(county,'COUNTY_004') INTO county_004_id;
    SELECT common_get_county_id_by_name_and_state('Middlesex','Massachusetts') INTO county_middlesex_ma_id;
    SELECT common_get_county_id_by_name_and_state('Bristol','Massachusetts') INTO county_bristol_ma_id;
    SELECT common_get_county_id_by_name_and_state('New London','Connecticut') INTO county_new_london_ct_id;
    SELECT common_get_county_id_by_name_and_state('Franklin','Massachusetts') INTO county_franklin_ma_id;
    SELECT common_get_county_id_by_name_and_state('Middlesex','Connecticut') INTO county_middlesex_ct_id;
    SELECT common_get_county_id_by_name_and_state('Strafford','New Hampshire') INTO county_strafford_nh_id;
    SELECT common_get_county_id_by_name_and_state('Hartford','Connecticut') INTO county_hartford_ct_id;
    SELECT common_get_table_id_by_name(county,'COUNTY_005') INTO county_005_id;
    SELECT common_get_table_id_by_name(county,'COUNTY_006') INTO county_006_id;
    SELECT common_get_table_id_by_name(county,'COUNTY_007') INTO county_007_id;
    SELECT common_get_table_id_by_name(county,'COUNTY_008') INTO county_008_id;

    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_001'), county_006_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_002'), county_005_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_003'), county_006_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_004'), county_005_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_005'), county_006_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_006'), county_005_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_007'), county_006_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_008'), county_002_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_009'), county_001_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_010'), county_001_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_011'), county_003_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_012'), county_001_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_013'), county_002_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_014'), county_004_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_015'), county_003_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_016'), county_004_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_017'), county_002_id);

    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_comm'), county_middlesex_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_hix'), county_middlesex_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_bcbs'), county_bristol_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_empl'), county_new_london_ct_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_ma'), county_middlesex_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_sn'), county_middlesex_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_pdp'), county_bristol_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_state'), county_bristol_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_dpp'), county_middlesex_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_com_med'), county_new_london_ct_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_union'), county_bristol_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_mun'), county_franklin_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_pbm'), county_franklin_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_comm_1'), county_middlesex_ct_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_comm_2'), county_bristol_ma_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_empl_1'), county_strafford_nh_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_ma_1'), county_hartford_ct_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'health_plan_ma_1'), county_new_london_ct_id);

    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_018'), county_001_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_019'), county_001_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_020'), county_005_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_021'), county_007_id);
    PERFORM common_create_health_plan_county(common_get_table_id_by_name(health_plan, 'TEST_PLAN_022'), county_008_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;
