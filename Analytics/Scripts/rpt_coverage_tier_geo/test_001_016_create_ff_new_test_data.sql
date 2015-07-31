CREATE OR REPLACE FUNCTION ana_rpt_coverage_tier_drug_test_001_016_create_ff_new_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE
parent_001_id INTEGER;
parent_002_id INTEGER;

provider_004_id INTEGER;
provider_005_id INTEGER;

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


success BOOLEAN:=FALSE;
BEGIN

--INSERT FF_NEW

SELECT common_create_provider(TRUE, 'TEST_PROVIDER_004', parent_001_id) INTO provider_004_id;
SELECT common_create_provider(TRUE, 'TEST_PROVIDER_005', parent_001_id) INTO provider_005_id;

SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_008_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_009_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_010_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_011_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_012_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_013_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_014_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_015_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_016_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_017_id;

SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_008', formulary_008_id, provider_001_id) INTO health_plan_008_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_009', formulary_009_id, provider_001_id) INTO health_plan_009_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_010', formulary_010_id, provider_002_id) INTO health_plan_010_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_011', formulary_011_id, provider_002_id) INTO health_plan_011_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_012', formulary_012_id, provider_003_id) INTO health_plan_012_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_013', formulary_013_id, provider_003_id) INTO health_plan_013_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_014', formulary_014_id, provider_004_id) INTO health_plan_014_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_015', formulary_015_id, provider_004_id) INTO health_plan_015_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_016', formulary_016_id, provider_005_id) INTO health_plan_016_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_017', formulary_017_id, provider_005_id) INTO health_plan_017_id;

SELECT common_create_drug(TRUE, FALSE, 'DRUG_003') INTO drug_003_id;
SELECT common_create_drug(TRUE, FALSE, 'DRUG_004') INTO drug_004_id;

PERFORM common_create_formulary_entry(formulary_008_id, drug_003_id, tier_001_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_009_id, drug_003_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_010_id, drug_003_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_011_id, drug_004_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_012_id, drug_003_id, tier_001_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_013_id, drug_004_id, tier_003P******_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_014_id, drug_004_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_015_id, drug_003_id, tier_003_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_016_id, drug_003_id, tier_003_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_017_id, drug_003_id, tier_003P******3_id, 0, FALSE);

SELECT common_create_country('COUNTRY_001','C_001',TRUE) INTO country_001_id;
SELECT common_create_state('STATE_001','S_001',country_001_id,TRUE) INTO state_001_id;

PERFORM common_create_health_plan_county_lives(health_plan_001_id, state_001_id, NULL, NULL, 100);
PERFORM common_create_health_plan_county_lives(health_plan_002_id, state_001_id, NULL, NULL, 100);
PERFORM common_create_health_plan_county_lives(health_plan_003_id, state_001_id, NULL, NULL, 50);
PERFORM common_create_health_plan_county_lives(health_plan_004_id, state_001_id, NULL, NULL, 50);
PERFORM common_create_health_plan_county_lives(health_plan_005_id, state_001_id, NULL, NULL, 100);
PERFORM common_create_health_plan_county_lives(health_plan_006_id, state_001_id, NULL, NULL, 50);
PERFORM common_create_health_plan_county_lives(health_plan_007_id, state_001_id, NULL, NULL, 30);

PERFORM common_create_health_plan_state(health_plan_001_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_002_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_003_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_004_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_005_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_006_id, state_001_id);
PERFORM common_create_health_plan_state(health_plan_007_id, state_001_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;
