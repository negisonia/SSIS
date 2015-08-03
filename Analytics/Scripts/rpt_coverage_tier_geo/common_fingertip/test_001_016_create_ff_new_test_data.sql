CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_geo_test_001_016_create_ff_new_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE
parent_001_id INTEGER;

provider_001_id INTEGER;
provider_002_id INTEGER;
provider_003_id INTEGER;
provider_004_id INTEGER;

formulary_008_id INTEGER;
formulary_009_id INTEGER;
formulary_010_id INTEGER;
formulary_011_id INTEGER;
formulary_012_id INTEGER;
formulary_013_id INTEGER;
formulary_014_id INTEGER;
formulary_015_id INTEGER;
formulary_016_id INTEGER;
formulary_017_id INTEGER;

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

health_plan_type_001_id INTEGER;
health_plan_type_002_id INTEGER;

drug_003_id INTEGER;
drug_004_id INTEGER;

country_001_id INTEGER;

state_001_id INTEGER;
state_002_id INTEGER;
state_003_id INTEGER;

county_001_id INTEGER;
county_002_id INTEGER;
county_003_id INTEGER;
county_004_id INTEGER;

metro_stat_area_001_id INTEGER;

tier_001_id integer;
tier_002_id integer;
tier_003_id integer;

success BOOLEAN:=FALSE;
BEGIN

--INSERT FF_NEW
--Find
SELECT common_create_parent('TEST_PARENT_001',TRUE) INTO parent_001_id;
SELECT common_create_provider(TRUE, 'TEST_PROVIDER_001', parent_001_id) INTO provider_001_id;
SELECT common_create_provider(TRUE, 'TEST_PROVIDER_002', parent_001_id) INTO provider_002_id;
SELECT common_create_provider(TRUE, 'TEST_PROVIDER_003', parent_001_id) INTO provider_003_id;

SELECT common_create_provider(TRUE, 'TEST_PROVIDER_004', parent_001_id) INTO provider_004_id;

SELECT common_create_formulary(TRUE,FALSE,NULL)   INTO formulary_008_id;
SELECT common_create_formulary(TRUE,FALSE,NULL)   INTO formulary_009_id;
SELECT common_create_formulary(TRUE,FALSE,NULL)   INTO formulary_010_id;
SELECT common_create_formulary(TRUE,FALSE,NULL)   INTO formulary_011_id;
SELECT common_create_formulary(TRUE,FALSE,NULL)   INTO formulary_012_id;
SELECT common_create_formulary(TRUE,FALSE,3)      INTO formulary_013_id;
SELECT common_create_formulary(TRUE,FALSE,NULL)   INTO formulary_014_id;
SELECT common_create_formulary(FALSE,FALSE,NULL)  INTO formulary_015_id;
SELECT common_create_formulary(TRUE,FALSE,NULL)   INTO formulary_016_id;
SELECT common_create_formulary(TRUE,FALSE,3)      INTO formulary_017_id;

--Find
SELECT common_create_health_plan_type(TRUE, 'HEALTH_PLAN_TYPE_001', TRUE, FALSE) INTO health_plan_type_001_id;
SELECT common_create_health_plan_type(TRUE, 'HEALTH_PLAN_TYPE_002', FALSE, TRUE) INTO health_plan_type_002_id;

SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_008', formulary_008_id, provider_002_id) INTO health_plan_008_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_009', formulary_009_id, provider_001_id) INTO health_plan_009_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_010', formulary_010_id, provider_002_id) INTO health_plan_010_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_011', formulary_011_id, provider_002_id) INTO health_plan_011_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_012', formulary_012_id, provider_003_id) INTO health_plan_012_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_013', formulary_013_id, provider_003_id) INTO health_plan_013_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_014', formulary_014_id, provider_004_id) INTO health_plan_014_id;
SELECT common_create_healthplan(health_plan_type_001_id, FALSE,'TEST_PLAN_015', formulary_015_id, provider_004_id) INTO health_plan_015_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_016', formulary_016_id, provider_004_id) INTO health_plan_016_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_017', formulary_017_id, provider_004_id) INTO health_plan_017_id;

SELECT common_create_drug(TRUE, FALSE, 'DRUG_003') INTO drug_003_id;
SELECT common_create_drug(TRUE, FALSE, 'DRUG_004') INTO drug_004_id;

--Find 
SELECT common_create_tier(TRUE, 'TIER_001', 'TIER_001') INTO tier_001_id;
SELECT common_create_tier(TRUE, 'TIER_002', 'TIER_002') INTO tier_002_id;
SELECT common_create_tier(TRUE, 'TIER_003', 'TIER_003') INTO tier_003_id;

PERFORM common_create_formulary_entry(formulary_008_id, drug_003_id, tier_001_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_009_id, drug_003_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_010_id, drug_003_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_011_id, drug_003_id, tier_001_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_012_id, drug_003_id, tier_001_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_013_id, drug_004_id, tier_003_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_014_id, drug_003_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_015_id, drug_003_id, tier_003_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_016_id, drug_003_id, tier_003_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_017_id, drug_003_id, tier_003_id, 0, FALSE);

--Find
SELECT common_create_country('COUNTRY_001','C_001',TRUE) INTO country_001_id;
SELECT common_create_state('STATE_001','S_001',country_001_id,TRUE) INTO state_001_id;

SELECT common_create_state('STATE_002','S_002',country_001_id,TRUE) INTO state_002_id;
SELECT common_create_state('STATE_003','S_003',country_001_id,TRUE) INTO state_003_id;

SELECT common_create_metro_stat_area('MSA_001','MSA_001') INTO metro_stat_area_001_id;

SELECT common_create_county('COUNTY_001',0,state_001_id,metro_stat_area_001_id) INTO county_001_id;
SELECT common_create_county('COUNTY_002',0,state_001_id,metro_stat_area_001_id) INTO county_002_id;
SELECT common_create_county('COUNTY_003',0,state_002_id,NULL) INTO county_003_id;
SELECT common_create_county('COUNTY_004',0,state_002_id,NULL) INTO county_004_id;

PERFORM common_create_health_plan_county_lives(health_plan_008_id, state_001_id, NULL, NULL, 125.25);
PERFORM common_create_health_plan_county_lives(health_plan_009_id, state_001_id, county_001_id, NULL, 85.25);
PERFORM common_create_health_plan_county_lives(health_plan_010_id, state_001_id, county_001_id, metro_stat_area_001_id, 127.75);
PERFORM common_create_health_plan_county_lives(health_plan_010_id, state_001_id, county_002_id, metro_stat_area_001_id, 127.75);
PERFORM common_create_health_plan_county_lives(health_plan_011_id, state_002_id, NULL, NULL, 175.5);
PERFORM common_create_health_plan_county_lives(health_plan_012_id, state_001_id, county_001_id, NULL, 85.25);
PERFORM common_create_health_plan_county_lives(health_plan_013_id, state_001_id, county_002_id, NULL, 40);
PERFORM common_create_health_plan_county_lives(health_plan_014_id, state_002_id, NULL, NULL, 100);
PERFORM common_create_health_plan_county_lives(health_plan_015_id, state_002_id, county_003_id, NULL, 50);
PERFORM common_create_health_plan_county_lives(health_plan_016_id, state_002_id, county_004_id, NULL, 175.5);
PERFORM common_create_health_plan_county_lives(health_plan_017_id, state_001_id, county_002_id, NULL, 40);

PERFORM common_create_health_plan_state(health_plan_008_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_009_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_010_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_011_id, state_002_id);
PERFORM common_create_health_plan_state(health_plan_012_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_013_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_014_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_015_id, state_002_id);
PERFORM common_create_health_plan_state(health_plan_016_id, state_002_id);
PERFORM common_create_health_plan_state(health_plan_017_id, state_001_id);

PERFORM common_create_health_plan_county(health_plan_009_id, county_001_id);
PERFORM common_create_health_plan_county(health_plan_010_id, county_001_id);
PERFORM common_create_health_plan_county(health_plan_010_id, county_004_id);
PERFORM common_create_health_plan_county(health_plan_012_id, county_001_id);
PERFORM common_create_health_plan_county(health_plan_013_id, county_002_id);
PERFORM common_create_health_plan_county(health_plan_015_id, county_003_id);
PERFORM common_create_health_plan_county(health_plan_016_id, county_004_id);
PERFORM common_create_health_plan_county(health_plan_017_id, county_002_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;
