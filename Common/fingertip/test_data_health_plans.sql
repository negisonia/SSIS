CREATE OR REPLACE FUNCTION test_data_health_plans() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

formulary_comm_id INTEGER;
formulary_hix_id INTEGER;
formulary_com_inactive_id INTEGER;
formulary_001_id INTEGER;
formulary_002_id INTEGER;
formulary_003_id INTEGER;
formulary_004_id INTEGER;
formulary_005_id INTEGER;
formulary_006_id INTEGER;
formulary_007_id INTEGER;
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

provider_1_id INTEGER;
provider_2_id INTEGER;
provider_3_id INTEGER;
provider_4_id INTEGER;
provider_5_id INTEGER;
provider_6_id INTEGER;
provider_7_id INTEGER;
provider_8_id INTEGER;
provider_9_id INTEGER;
provider_10_id INTEGER;
provider_001_id INTEGER;
provider_002_id INTEGER;
provider_003_id INTEGER;

commercial_hpt_id INTEGER;
hix_hpt_id INTEGER;
commercial_bcbs_hpt_id INTEGER;
employer_hpt_id INTEGER;
medicare_ma_hpt_id INTEGER;
medicare_sn_hpt_id INTEGER;
medicare_pdp_hpt_id INTEGER;
state_medicare_hpt_id INTEGER;
dpp_hpt_id INTEGER;
commercial_medicaid_hpt_id INTEGER;
union_hpt_id INTEGER;
municipal_plan_hpt_id INTEGER;
pbm_hpt_id INTEGER;
commercial_inactive_hpt_id INTEGER;
health_plan_type_001_id INTEGER;
health_plan_type_002_id INTEGER;
health_plan_type_003_id INTEGER;

BEGIN

    --RETRIEVE PROVIDERS
	SELECT p.id FROM provider p WHERE p.name='provider_1' INTO provider_1_id;
	SELECT p.id FROM provider p WHERE p.name='provider_2' INTO provider_2_id;
	SELECT p.id FROM provider p WHERE p.name='provider_3' INTO provider_3_id;
	SELECT p.id FROM provider p WHERE p.name='provider_4' INTO provider_4_id;
	SELECT p.id FROM provider p WHERE p.name='provider_5' INTO provider_5_id;
	SELECT p.id FROM provider p WHERE p.name='provider_6' INTO provider_6_id;
	SELECT p.id FROM provider p WHERE p.name='provider_7' INTO provider_7_id;
	SELECT p.id FROM provider p WHERE p.name='provider_8' INTO provider_8_id;
	SELECT p.id FROM provider p WHERE p.name='provider_9' INTO provider_9_id;
	SELECT p.id FROM provider p WHERE p.name='provider_10' INTO provider_10_id;
    SELECT p.id FROM provider p WHERE p.name='TEST_PROVIDER_001' INTO provider_001_id;
    SELECT p.id FROM provider p WHERE p.name='TEST_PROVIDER_002' INTO provider_002_id;
    SELECT p.id FROM provider p WHERE p.name='TEST_PROVIDER_003' INTO provider_003_id;

	--RETRIEVE HEALTH PLAN TYPES
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='commercial' INTO commercial_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='hix' INTO hix_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='commercial_bcbs' INTO commercial_bcbs_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='employer' INTO employer_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='medicare_ma' INTO medicare_ma_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='medicare_sn' INTO medicare_sn_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='medicare_pdp' INTO medicare_pdp_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='state_medicare' INTO state_medicare_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='dpp' INTO dpp_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='commercial_medicaid' INTO commercial_medicaid_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='union' INTO union_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='municipal_plan' INTO municipal_plan_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='pbm' INTO pbm_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='commercial_inactive' INTO commercial_inactive_hpt_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='HEALTH_PLAN_TYPE_001', TRUE, FALSE) INTO health_plan_type_001_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='HEALTH_PLAN_TYPE_002', FALSE, TRUE) INTO health_plan_type_002_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='HEALTH_PLAN_TYPE_003', TRUE, FALSE) INTO health_plan_type_003_id;

    --FORMULARIES AND HEALTH PLANS
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_comm_id;--formulary 1
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_hix_id;--formulary 2
    SELECT common_create_formulary(FALSE,FALSE,NULL) INTO formulary_com_inactive_id;--formulary 3
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_001_id;
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_002_id;
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_003_id;
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_004_id;
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formulary_005_id;
    SELECT common_create_formulary(FALSE,FALSE,NULL) INTO formulary_006_id;
    SELECT common_create_formulary(TRUE,FALSE,3) INTO formulary_007_id;
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

    PERFORM common_create_healthplan(commercial_hpt_id,TRUE,'health_plan_comm',formulary_comm_id,provider_1_id);
    PERFORM common_create_healthplan(hix_hpt_id,TRUE,'health_plan_hix',formulary_hix_id,provider_1_id);
    PERFORM common_create_healthplan(commercial_inactive_hpt_id,FALSE,'health_plan_com_inactive',formulary_com_inactive_id,provider_1_id);
    PERFORM common_create_healthplan(commercial_bcbs_hpt_id,TRUE,'health_plan_bcbs',NULL,provider_7_id);
    PERFORM common_create_healthplan(employer_hpt_id,TRUE,'health_plan_empl',NULL,provider_3_id);
    PERFORM common_create_healthplan(medicare_ma_hpt_id,TRUE,'health_plan_ma',NULL,provider_7_id);
    PERFORM common_create_healthplan(medicare_sn_hpt_id,TRUE,'health_plan_sn',NULL,provider_7_id);
    PERFORM common_create_healthplan(medicare_pdp_hpt_id,TRUE,'health_plan_pdp',NULL,provider_6_id);
    PERFORM common_create_healthplan(state_medicare_hpt_id,TRUE,'health_plan_state',NULL,provider_9_id);
    PERFORM common_create_healthplan(dpp_hpt_id,TRUE,'health_plan_dpp',NULL,provider_5_id);
    PERFORM common_create_healthplan(commercial_medicaid_hpt_id,TRUE,'health_plan_com_med',NULL,provider_7_id);
    PERFORM common_create_healthplan(union_hpt_id,TRUE,'health_plan_union',NULL,provider_2_id);
    PERFORM common_create_healthplan(municipal_plan_hpt_id,TRUE,'health_plan_mun',NULL,provider_4_id);
    PERFORM common_create_healthplan(pbm_hpt_id,TRUE,'health_plan_pbm',NULL,provider_10_id);
    PERFORM common_create_healthplan(commercial_hpt_id,TRUE,'health_plan_comm_1',NULL,provider_1_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_001', formulary_001_id, provider_001_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_002', formulary_002_id, provider_001_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_003', formulary_003_id, provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_004', formulary_004_id, provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_003_id, TRUE, 'TEST_PLAN_005', formulary_005_id, provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, FALSE, 'TEST_PLAN_006', formulary_006_id, provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_007', formulary_007_id, provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_008', formulary_008_id, provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_009', formulary_009_id, provider_001_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_010', formulary_010_id, provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_011', formulary_011_id, provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_012', formulary_012_id, provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_013', formulary_013_id, provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_014', formulary_014_id, provider_004_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, FALSE,'TEST_PLAN_015', formulary_015_id, provider_004_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_016', formulary_016_id, provider_004_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_017', formulary_017_id, provider_004_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;