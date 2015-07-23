CREATE OR REPLACE FUNCTION test_001_007_create_ff_new_test_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE
parent_001_id INTEGER;
parent_002_id INTEGER;

provider_001_id INTEGER;
provider_002_id INTEGER;
provider_003_id INTEGER;

health_plan_type_001_id INTEGER;
health_plan_type_002_id INTEGER;
health_plan_type_003_id INTEGER;

formulary_001_id INTEGER;
formulary_002_id INTEGER;
formulary_003_id INTEGER;
formulary_004_id INTEGER;
formulary_005_id INTEGER;
formulary_006_id INTEGER;

health_plan_001_id INTEGER;
health_plan_002_id INTEGER;
health_plan_003_id INTEGER;
health_plan_004_id INTEGER;
health_plan_005_id INTEGER;
health_plan_006_id INTEGER;

drug_001_id INTEGER;
drug_002_id INTEGER;

tier_001_id INTEGER;
tier_002_id INTEGER;

country_001_id INTEGER;
state_001_id INTEGER;
success BOOLEAN:=FALSE;
BEGIN

--INSERT FF_NEW
SELECT common_create_parent('TEST_PARENT_001',TRUE) INTO parent_001_id;
SELECT common_create_parent('TEST_PARENT_002',FALSE) INTO parent_002_id;

SELECT common_create_provider(TRUE, 'TEST_PROVIDER_001', parent_001_id) INTO provider_001_id;
SELECT common_create_provider(TRUE, 'TEST_PROVIDER_002', parent_001_id) INTO provider_002_id;
SELECT common_create_provider(TRUE, 'TEST_PROVIDER_003', parent_001_id) INTO provider_003_id;

SELECT common_create_health_plan_type(TRUE, 'HEALTH_PLAN_TYPE_001', TRUE, FALSE) INTO health_plan_type_001_id;
SELECT common_create_health_plan_type(TRUE, 'HEALTH_PLAN_TYPE_002', FALSE, TRUE) INTO health_plan_type_002_id;
SELECT common_create_health_plan_type(TRUE, 'HEALTH_PLAN_TYPE_003', TRUE, FALSE) INTO health_plan_type_003_id;

SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_001_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_002_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_003_id;
SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_004_id;
SELECT common_create_formulary(TRUE,FALSE,1)    INTO formulary_005_id;
SELECT common_create_formulary(FALSE,FALSE,NULL) INTO formulary_006_id;

SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_001', formulary_001_id, provider_001_id) INTO health_plan_001_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_002', formulary_002_id, provider_001_id) INTO health_plan_002_id;
SELECT common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_003', formulary_003_id, provider_002_id) INTO health_plan_003_id;
SELECT common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_004', formulary_004_id, provider_002_id) INTO health_plan_004_id;
SELECT common_create_healthplan(health_plan_type_003_id, TRUE, 'TEST_PLAN_005', formulary_005_id, provider_003_id) INTO health_plan_005_id;
SELECT common_create_healthplan(health_plan_type_001_id, FALSE, 'TEST_PLAN_006', formulary_006_id, provider_003_id) INTO health_plan_006_id;

SELECT common_create_drug(TRUE, FALSE, 'DRUG_001') INTO drug_001_id;
SELECT common_create_drug(TRUE, FALSE, 'DRUG_002') INTO drug_002_id;

SELECT common_create_tier(TRUE, 'TIER_001', 'TIER_001') INTO tier_001_id;
SELECT common_create_tier(TRUE, 'TIER_002', 'TIER_002') INTO tier_002_id;

PERFORM common_create_formulary_entry(formulary_001_id, drug_001_id, tier_001_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_002_id, drug_002_id, tier_001_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_003_id, drug_001_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_004_id, drug_002_id, tier_002_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_005_id, drug_001_id, tier_001_id, 0, FALSE);
PERFORM common_create_formulary_entry(formulary_006_id, drug_002_id, tier_002_id, 0, FALSE);

SELECT common_create_country('COUNTRY_001','C_001',TRUE) INTO country_001_id;
SELECT common_create_state('STATE_001','S_001',country_001_id,TRUE) INTO state_001_id;

PERFORM common_create_health_plan_county_lives(health_plan_001_id, state_001_id, NULL, NULL, 100);
PERFORM common_create_health_plan_county_lives(health_plan_002_id, state_001_id, NULL, NULL, 100);
PERFORM common_create_health_plan_county_lives(health_plan_003_id, state_001_id, NULL, NULL, 50);
PERFORM common_create_health_plan_county_lives(health_plan_004_id, state_001_id, NULL, NULL, 50);
PERFORM common_create_health_plan_county_lives(health_plan_005_id, state_001_id, NULL, NULL, 100);
PERFORM common_create_health_plan_county_lives(health_plan_006_id, state_001_id, NULL, NULL, 50);

success=true;
return success;
END
$$ LANGUAGE plpgsql;
