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
provider_11_id INTEGER;
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
provider VARCHAR:='provider';
healthplantype VARCHAR:='healthplantype';
BEGIN

    --RETRIEVE PROVIDERS
	SELECT common_get_table_id_by_name(provider, 'provider_1') INTO provider_1_id;
	SELECT common_get_table_id_by_name(provider, 'provider_2') INTO provider_2_id;
	SELECT common_get_table_id_by_name(provider, 'provider_3') INTO provider_3_id;
	SELECT common_get_table_id_by_name(provider, 'provider_4') INTO provider_4_id;
	SELECT common_get_table_id_by_name(provider, 'provider_5') INTO provider_5_id;
	SELECT common_get_table_id_by_name(provider, 'provider_6') INTO provider_6_id;
	SELECT common_get_table_id_by_name(provider, 'provider_7') INTO provider_7_id;
	SELECT common_get_table_id_by_name(provider, 'provider_8') INTO provider_8_id;
	SELECT common_get_table_id_by_name(provider, 'provider_9') INTO provider_9_id;
	SELECT common_get_table_id_by_name(provider, 'provider_10') INTO provider_10_id;
    SELECT common_get_table_id_by_name(provider, 'provider_11') INTO provider_11_id;
    SELECT common_get_table_id_by_name(provider, 'TEST_PROVIDER_001') INTO provider_001_id;
    SELECT common_get_table_id_by_name(provider, 'TEST_PROVIDER_002') INTO provider_002_id;
    SELECT common_get_table_id_by_name(provider, 'TEST_PROVIDER_003') INTO provider_003_id;
    SELECT common_get_table_id_by_name(provider, 'TEST_PROVIDER_004') INTO provider_004_id;

	--RETRIEVE HEALTH PLAN TYPES
    SELECT common_get_table_id_by_name(healthplantype, 'commercial') INTO commercial_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'hix') INTO hix_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'commercial_bcbs') INTO commercial_bcbs_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'employer') INTO employer_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'medicare_ma') INTO medicare_ma_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'medicare_sn') INTO medicare_sn_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'medicare_pdp') INTO medicare_pdp_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'state_medicare') INTO state_medicare_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'dpp') INTO dpp_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'commercial_medicaid') INTO commercial_medicaid_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'union') INTO union_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'municipal_plan') INTO municipal_plan_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'pbm') INTO pbm_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'commercial_inactive') INTO commercial_inactive_hpt_id;
    SELECT common_get_table_id_by_name(healthplantype, 'HEALTH_PLAN_TYPE_001') INTO health_plan_type_001_id;
    SELECT common_get_table_id_by_name(healthplantype, 'HEALTH_PLAN_TYPE_002') INTO health_plan_type_002_id;
    SELECT common_get_table_id_by_name(healthplantype, 'HEALTH_PLAN_TYPE_003') INTO health_plan_type_003_id;

    PERFORM common_create_healthplan(commercial_hpt_id,TRUE,'health_plan_comm',common_create_formulary(TRUE,FALSE,NULL), provider_1_id,'https://health_plan_comm/test.pdf');
    PERFORM common_create_healthplan(hix_hpt_id,TRUE,'health_plan_hix',common_create_formulary(TRUE,FALSE,3), provider_1_id,'https://health_plan_hix/test.pdf');
    PERFORM common_create_healthplan(commercial_inactive_hpt_id,FALSE,'health_plan_com_inactive',common_create_formulary(FALSE,FALSE,3), provider_1_id,null);
    PERFORM common_create_healthplan(commercial_bcbs_hpt_id,TRUE,'health_plan_bcbs',common_create_formulary(TRUE,FALSE,NULL),provider_7_id,'https://health_plan_bcbs/test.pdf');
    PERFORM common_create_healthplan(employer_hpt_id,TRUE,'health_plan_empl',common_create_formulary(TRUE,FALSE,NULL),provider_3_id,'https://health_plan_empl/test.pdf');
    PERFORM common_create_healthplan(medicare_ma_hpt_id,TRUE,'health_plan_ma',common_create_formulary(TRUE,FALSE,NULL),provider_7_id,'https://health_plan_ma/test.pdf');
    PERFORM common_create_healthplan(medicare_sn_hpt_id,TRUE,'health_plan_sn',common_create_formulary(TRUE,FALSE,NULL),provider_7_id,'https://health_plan_sn/test.pdf');
    PERFORM common_create_healthplan(medicare_pdp_hpt_id,TRUE,'health_plan_pdp',common_create_formulary(TRUE,FALSE,NULL),provider_6_id,'https://health_plan_pdp/test.pdf');
    PERFORM common_create_healthplan(state_medicare_hpt_id,TRUE,'health_plan_state',common_create_formulary(TRUE,FALSE,NULL),provider_9_id,'https://health_plan_state/test.pdf');
    PERFORM common_create_healthplan(dpp_hpt_id,TRUE,'health_plan_dpp',common_create_formulary(TRUE,FALSE,NULL),provider_5_id,'https://health_plan_dpp/test.pdf');
    PERFORM common_create_healthplan(commercial_medicaid_hpt_id,TRUE,'health_plan_com_med',common_create_formulary(TRUE,FALSE,NULL),provider_7_id,'https://health_plan_com_med/test.pdf');
    PERFORM common_create_healthplan(union_hpt_id,TRUE,'health_plan_union',common_create_formulary(TRUE,FALSE,NULL),provider_2_id,'https://health_plan_union/test.pdf');
    PERFORM common_create_healthplan(municipal_plan_hpt_id,TRUE,'health_plan_mun',common_create_formulary(TRUE,FALSE,NULL),provider_4_id,null);
    PERFORM common_create_healthplan(pbm_hpt_id,TRUE,'health_plan_pbm',common_create_formulary(TRUE,FALSE,NULL),provider_10_id,null);
    PERFORM common_create_healthplan(commercial_hpt_id,TRUE,'health_plan_comm_1',common_create_formulary(TRUE,FALSE,NULL),provider_1_id,'https://health_plan_comm_1/test.pdf');
    PERFORM common_create_healthplan(commercial_hpt_id,FALSE,'health_plan_comm_2',common_create_formulary(TRUE,FALSE,NULL),provider_1_id, null);
    PERFORM common_create_healthplan(employer_hpt_id,TRUE,'health_plan_empl_1',common_create_formulary(TRUE,FALSE,NULL),provider_11_id, 'https://health_plan_empl_1/test.pdf');
    PERFORM common_create_healthplan(medicare_ma_hpt_id,TRUE,'health_plan_ma_1',common_create_formulary(TRUE,FALSE,2),provider_11_id, 'https://health_plan_ma_1/test.pdf');
    
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_001', common_create_formulary(TRUE,FALSE,NULL), provider_001_id , null);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_002', common_create_formulary(TRUE,FALSE,NULL), provider_001_id , null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_003', common_create_formulary(TRUE,FALSE,NULL), provider_002_id , null);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_004', common_create_formulary(TRUE,FALSE,NULL), provider_002_id , null);
    PERFORM common_create_healthplan(health_plan_type_003_id, TRUE, 'TEST_PLAN_005', common_create_formulary(TRUE,FALSE,NULL), provider_003_id , null);
    PERFORM common_create_healthplan(health_plan_type_001_id, FALSE, 'TEST_PLAN_006', common_create_formulary(FALSE,FALSE,NULL), provider_003_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_007', common_create_formulary(TRUE,FALSE,3), provider_003_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_008', common_create_formulary(TRUE,FALSE,NULL), provider_002_id, null);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_009', common_create_formulary(TRUE,FALSE,NULL), provider_002_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_010', common_create_formulary(TRUE,FALSE,NULL), provider_002_id, null);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_011', common_create_formulary(TRUE,FALSE,NULL), provider_002_id, null);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_012', common_create_formulary(TRUE,FALSE,NULL), provider_003_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_013', common_create_formulary(TRUE,FALSE,3), provider_003_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_014', common_create_formulary(TRUE,FALSE,NULL), provider_004_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, FALSE,'TEST_PLAN_015', common_create_formulary(FALSE,FALSE,NULL), provider_004_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_016', common_create_formulary(TRUE,FALSE,NULL), provider_004_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_017', common_create_formulary(TRUE,FALSE,3), provider_004_id, null);
    PERFORM common_create_healthplan(health_plan_type_001_id, TRUE, 'TEST_PLAN_018', common_create_formulary(TRUE,FALSE,NULL), provider_002_id, null);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_019', common_create_formulary(TRUE,FALSE,NULL), provider_002_id, null);
    PERFORM common_create_healthplan(health_plan_type_002_id, TRUE, 'TEST_PLAN_020', common_create_formulary(TRUE,FALSE,NULL), provider_002_id, null);
    PERFORM common_create_healthplan(health_plan_type_003_id, TRUE, 'TEST_PLAN_021', common_create_formulary(TRUE,FALSE,NULL), provider_001_id, null);
    PERFORM common_create_healthplan(health_plan_type_003_id, TRUE, 'TEST_PLAN_022', common_create_formulary(TRUE,FALSE,NULL), provider_001_id, null);

success=true;
return success;
END
$$ LANGUAGE plpgsql;