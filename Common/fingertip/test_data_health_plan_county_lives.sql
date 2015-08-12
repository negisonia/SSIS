CREATE OR REPLACE FUNCTION test_data_health_plan_county_lives() --FF NEW
RETURNS boolean AS $$
DECLARE

health_plan_001_id INTEGER;
health_plan_002_id INTEGER;
health_plan_003_id INTEGER;
health_plan_004_id INTEGER;
health_plan_005_id INTEGER;
health_plan_006_id INTEGER;
health_plan_007_id INTEGER;
health_plan_008_id INTEGER;
health_plan_009_id INTEGER;
health_plan_010_id INTEGER;
health_plan_011_id INTEGER;
health_plan_012_id INTEGER;
health_plan_013_id INTEGER;
health_plan_014_id INTEGER;
health_plan_015_id INTEGER;
health_plan_016_id INTEGER;
health_plan_017_id INTEGER;

state_001_id INTEGER;
state_002_id INTEGER;
state_003_id INTEGER;

county_001_id INTEGER;
county_002_id INTEGER;
county_003_id INTEGER;
county_004_id INTEGER;

metro_stat_area_001_id INTEGER;

success BOOLEAN:=FALSE;

BEGIN

--RETRIEVE HEALTH PLANS
    SELECT h.id into health_plan_001_id FROM healthplan h WHERE h.name='TEST_PLAN_001';
    SELECT h.id into health_plan_002_id FROM healthplan h WHERE h.name='TEST_PLAN_002';
    SELECT h.id into health_plan_003_id FROM healthplan h WHERE h.name='TEST_PLAN_003';
    SELECT h.id into health_plan_004_id FROM healthplan h WHERE h.name='TEST_PLAN_004';
    SELECT h.id into health_plan_005_id FROM healthplan h WHERE h.name='TEST_PLAN_005';
    SELECT h.id into health_plan_006_id FROM healthplan h WHERE h.name='TEST_PLAN_006';
    SELECT h.id into health_plan_007_id FROM healthplan h WHERE h.name='TEST_PLAN_007';
    SELECT h.id into health_plan_008_id FROM healthplan h WHERE h.name='TEST_PLAN_008';
    SELECT h.id into health_plan_009_id FROM healthplan h WHERE h.name='TEST_PLAN_009';
    SELECT h.id into health_plan_010_id FROM healthplan h WHERE h.name='TEST_PLAN_010';
    SELECT h.id into health_plan_011_id FROM healthplan h WHERE h.name='TEST_PLAN_011';
    SELECT h.id into health_plan_012_id FROM healthplan h WHERE h.name='TEST_PLAN_012';
    SELECT h.id into health_plan_013_id FROM healthplan h WHERE h.name='TEST_PLAN_013';
    SELECT h.id into health_plan_014_id FROM healthplan h WHERE h.name='TEST_PLAN_014';
    SELECT h.id into health_plan_015_id FROM healthplan h WHERE h.name='TEST_PLAN_015';
    SELECT h.id into health_plan_016_id FROM healthplan h WHERE h.name='TEST_PLAN_016';
    SELECT h.id into health_plan_017_id FROM healthplan h WHERE h.name='TEST_PLAN_017';

--RETRIEVE STATES
    SELECT s.id into state_001_id FROM state s WHERE s.name='STATE_001';
    SELECT s.id into state_002_id FROM state s WHERE s.name='STATE_002';
    SELECT s.id into state_003_id FROM state s WHERE s.name='STATE_003';

--RETRIEVE COUNTIES
    SELECT c.id into county_001_id FROM county c WHERE c.name='COUNTY_001';
    SELECT c.id into county_002_id FROM county c WHERE c.name='COUNTY_002';
    SELECT c.id into county_003_id FROM county c WHERE c.name='COUNTY_003';
    SELECT c.id into county_004_id FROM county c WHERE c.name='COUNTY_004';

--RETRIEVE MSAS
    SELECT m.id into metro_stat_area_001_id FROM metrostatarea m WHERE m.name='MSA_001';

    PERFORM common_create_health_plan_county_lives(health_plan_001_id, state_001_id, NULL, NULL, 100);
    PERFORM common_create_health_plan_county_lives(health_plan_002_id, state_001_id, NULL, NULL, 100);
    PERFORM common_create_health_plan_county_lives(health_plan_003_id, state_001_id, NULL, NULL, 50);
    PERFORM common_create_health_plan_county_lives(health_plan_004_id, state_001_id, NULL, NULL, 50);
    PERFORM common_create_health_plan_county_lives(health_plan_005_id, state_001_id, NULL, NULL, 100);
    PERFORM common_create_health_plan_county_lives(health_plan_006_id, state_001_id, NULL, NULL, 50);
    PERFORM common_create_health_plan_county_lives(health_plan_007_id, state_001_id, NULL, NULL, 30);
    PERFORM common_create_health_plan_county_lives(health_plan_008_id, state_002_id, county_002_id, NULL, 20);
    PERFORM common_create_health_plan_county_lives(health_plan_009_id, state_002_id, county_001_id, metro_stat_area_001_id, 85.25);
    PERFORM common_create_health_plan_county_lives(health_plan_010_id, state_002_id, county_001_id, metro_stat_area_001_id, 85.25);
    PERFORM common_create_health_plan_county_lives(health_plan_011_id, state_003_id, county_003_id, NULL, 25);
    PERFORM common_create_health_plan_county_lives(health_plan_012_id, state_002_id, county_001_id, metro_stat_area_001_id, 85.25);
    PERFORM common_create_health_plan_county_lives(health_plan_013_id, state_002_id, county_002_id, NULL, 20);
    PERFORM common_create_health_plan_county_lives(health_plan_014_id, state_003_id, county_004_id, metro_stat_area_001_id, 75.5);
    PERFORM common_create_health_plan_county_lives(health_plan_015_id, state_003_id, county_003_id, NULL, 25);
    PERFORM common_create_health_plan_county_lives(health_plan_016_id, state_003_id, county_004_id, metro_stat_area_001_id, 100);
    PERFORM common_create_health_plan_county_lives(health_plan_017_id, state_002_id, county_002_id, NULL, 40);    

success=true;
return success;
END
$$ LANGUAGE plpgsql;