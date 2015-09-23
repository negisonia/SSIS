CREATE OR REPLACE FUNCTION test_data_health_plan_county_lives() --FF NEW
RETURNS boolean AS $$
DECLARE

state_001_id INTEGER;
state_002_id INTEGER;
state_003_id INTEGER;
state_ma_id INTEGER;
state_ct_id INTEGER;

county_001_id INTEGER;
county_002_id INTEGER;
county_003_id INTEGER;
county_004_id INTEGER;
county_005_id INTEGER;
county_006_id INTEGER;
county_007_id INTEGER;
county_008_id INTEGER;
county_middlesex_ma_id INTEGER;
county_bristol_ma_id INTEGER;
county_new_london_ct_id INTEGER;
county_franklin_ma_id INTEGER;
county_middlesex_ct_id INTEGER;

metro_stat_area_001_id INTEGER;
metro_stat_area_002_id INTEGER;
metro_stat_area_003_id INTEGER;

health_plan VARCHAR:='healthplan';
state VARCHAR:='state';
metrostatarea VARCHAR:='metrostatarea';

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE STATES
    SELECT common_get_table_id_by_name(state, 'STATE_001') INTO state_001_id;
    SELECT common_get_table_id_by_name(state, 'STATE_002') INTO state_002_id;
    SELECT common_get_table_id_by_name(state, 'STATE_003') INTO state_003_id;
    SELECT common_get_table_id_by_name(state, 'Massachusetts') INTO state_ma_id;
    SELECT common_get_table_id_by_name(state, 'Connecticut') INTO state_ct_id;

--RETRIEVE COUNTIES
    SELECT common_get_county_id_by_name_and_state('COUNTY_001','STATE_002') INTO county_001_id;
    SELECT common_get_county_id_by_name_and_state('COUNTY_002','STATE_002') INTO county_002_id;
    SELECT common_get_county_id_by_name_and_state('COUNTY_003','STATE_003') INTO county_003_id;
    SELECT common_get_county_id_by_name_and_state('COUNTY_004','STATE_003') INTO county_004_id;
    SELECT common_get_county_id_by_name_and_state('COUNTY_005','STATE_001') INTO county_005_id;
    SELECT common_get_county_id_by_name_and_state('COUNTY_006','STATE_001') INTO county_006_id;
    SELECT common_get_county_id_by_name_and_state('COUNTY_007','STATE_001') INTO county_007_id;
    SELECT common_get_county_id_by_name_and_state('COUNTY_008','STATE_001') INTO county_008_id;
    SELECT common_get_county_id_by_name_and_state('Middlesex','Massachusetts') INTO county_middlesex_ma_id;
    SELECT common_get_county_id_by_name_and_state('Bristol','Massachusetts') INTO county_bristol_ma_id;
    SELECT common_get_county_id_by_name_and_state('New London','Connecticut') INTO county_new_london_ct_id;
    SELECT common_get_county_id_by_name_and_state('Franklin','Massachusetts') INTO county_franklin_ma_id;
    SELECT common_get_county_id_by_name_and_state('Middlesex','Connecticut') INTO county_middlesex_ct_id;

--RETRIEVE MSAS
    SELECT common_get_table_id_by_name(metrostatarea, 'MSA_001') INTO metro_stat_area_001_id;
    SELECT common_get_table_id_by_name(metrostatarea, 'MSA_002') INTO metro_stat_area_002_id;
    SELECT common_get_table_id_by_name(metrostatarea, 'MSA_003') INTO metro_stat_area_003_id;

    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_001'), state_001_id, county_006_id, metro_stat_area_002_id, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_002'), state_001_id, county_005_id, metro_stat_area_002_id, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_003'), state_001_id, county_006_id, metro_stat_area_002_id, 50);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_004'), state_001_id, county_005_id, metro_stat_area_002_id, 50);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_005'), state_001_id, county_006_id, metro_stat_area_002_id, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_006'), state_001_id, county_004_id, metro_stat_area_002_id, 50);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_007'), state_001_id, county_006_id, metro_stat_area_002_id, 30);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_008'), state_002_id, county_002_id, NULL, 20);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_009'), state_002_id, county_001_id, metro_stat_area_001_id, 85.25);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_010'), state_002_id, county_001_id, metro_stat_area_001_id, 85.25);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_011'), state_003_id, county_003_id, NULL, 25);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_012'), state_002_id, county_001_id, metro_stat_area_001_id, 85.25);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_013'), state_002_id, county_002_id, NULL, 20);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_014'), state_003_id, county_004_id, metro_stat_area_001_id, 75.5);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_015'), state_003_id, county_003_id, NULL, 25);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_016'), state_003_id, county_004_id, metro_stat_area_001_id, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_017'), state_002_id, county_002_id, NULL, 40);

    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_comm'), state_ma_id, county_middlesex_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_hix'), state_ma_id, county_middlesex_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_bcbs'), state_ma_id, county_bristol_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_empl'), state_ct_id, county_new_london_ct_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_ma'), state_ma_id, county_middlesex_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_sn'), state_ma_id, county_middlesex_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_pdp'), state_ma_id, county_bristol_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_state'), state_ma_id, county_bristol_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_dpp'), state_ma_id, county_middlesex_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_com_med'), state_ct_id, county_new_london_ct_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_union'), state_ma_id, county_bristol_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_mun'), state_ma_id, county_franklin_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_pbm'), state_ma_id, county_franklin_ma_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_comm_1'), state_ct_id, county_middlesex_ct_id, NULL, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'health_plan_comm_2'), state_ma_id, county_bristol_ma_id, NULL, 100);
    
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_018'), state_002_id, county_001_id, NULL, 25);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_019'), state_002_id, county_001_id, NULL, 50);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_020'), state_001_id, county_005_id, metro_stat_area_002_id, 100);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_021'), state_001_id, county_007_id, metro_stat_area_003_id, 150);
    PERFORM common_create_health_plan_county_lives(common_get_table_id_by_name(health_plan, 'TEST_PLAN_022'), state_001_id, county_008_id, metro_stat_area_003_id, 50);

success=true;
return success;
END
$$ LANGUAGE plpgsql;