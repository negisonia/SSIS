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


    --INSERT HEALTH PLANS
    PERFORM common_create_healthplan(commercial_hpt_id,TRUE,'health_plan_comm',NULL,provider_1_id);
    PERFORM common_create_healthplan(hix_hpt_id,TRUE,'health_plan_hix',NULL,provider_1_id);
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
    PERFORM common_create_healthplan(commercial_inactive_hpt_id,FALSE,'health_plan_comm_2',NULL,provider_1_id);


//@TODO  insertar el formularyfid
// insert formulary
// inser plan with formularyfid previously created


success=true;
return success;
END
$$ LANGUAGE plpgsql;