CREATE OR REPLACE FUNCTION test_data_health_plans() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

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
provider_004_id INTEGER;

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
    SELECT p.id FROM provider p WHERE p.name='TEST_PROVIDER_004' INTO provider_004_id;

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
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='HEALTH_PLAN_TYPE_001' INTO health_plan_type_001_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='HEALTH_PLAN_TYPE_002' INTO health_plan_type_002_id;
    SELECT hpt.id FROM healthplantype hpt WHERE hpt.name='HEALTH_PLAN_TYPE_003' INTO health_plan_type_003_id;

    PERFORM common_create_healthplan(commercial_hpt_id,TRUE,'health_plan_comm',common_create_formulary(TRUE,FALSE,NULL), provider_1_id);
    PERFORM common_create_healthplan(hix_hpt_id,TRUE,'health_plan_hix',common_create_formulary(TRUE,FALSE,3), provider_1_id);
    PERFORM common_create_healthplan(commercial_inactive_hpt_id,FALSE,'health_plan_com_inactive',common_create_formulary(FALSE,FALSE,3), provider_1_id);
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
    PERFORM common_create_healthplan(commercial_hpt_id,TRUE,'health_plan_comm_1',common_create_formulary(TRUE,FALSE,NULL),provider_1_id);
    PERFORM common_create_healthplan(commercial_hpt_id,FALSE,'health_plan_comm_2',NULL,provider_1_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_001', common_create_formulary(TRUE,FALSE,NULL), provider_001_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_002', common_create_formulary(TRUE,FALSE,NULL), provider_001_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_003', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_004', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_003_id, TRUE, 'TEST_PLAN_005', common_create_formulary(TRUE,FALSE,NULL), provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, FALSE, 'TEST_PLAN_006', common_create_formulary(FALSE,FALSE,NULL), provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_007', common_create_formulary(TRUE,FALSE,3), provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_008', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_009', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_010', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_011', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_012', common_create_formulary(TRUE,FALSE,NULL), provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_013', common_create_formulary(TRUE,FALSE,3), provider_003_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_014', common_create_formulary(TRUE,FALSE,NULL), provider_004_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, FALSE,'TEST_PLAN_015', common_create_formulary(FALSE,FALSE,NULL), provider_004_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_016', common_create_formulary(TRUE,FALSE,NULL), provider_004_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_017', common_create_formulary(TRUE,FALSE,3), provider_004_id);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_018', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_019', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_020', common_create_formulary(TRUE,FALSE,NULL), provider_002_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;