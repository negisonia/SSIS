CREATE OR REPLACE FUNCTION test_data_health_plans() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
formularyEntryId INTEGER;
formularyId INTEGER;

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

drug_1 INTEGER;
drug_2 INTEGER;
drug_3 INTEGER;
drug_4 INTEGER;
drug_5 INTEGER;
drug_6 INTEGER;
drug_7 INTEGER;
drug_8 INTEGER;
drug_9 INTEGER;
drug_10_inactive INTEGER;
drug_11_inactive INTEGER;

reason_code_92 INTEGER;
reason_code_40 INTEGER;
reason_code_42 INTEGER;
reason_code_90 INTEGER;
reason_code_41 INTEGER;
reason_code_60 INTEGER;

tier_1 INTEGER;
tier_2 INTEGER;
tier_3 INTEGER;
tier_3p INTEGER;
tier_4 INTEGER;

ql_qualifier INTEGER;
pa_qualifier INTEGER;
st_qualifier INTEGER;
or_qualifier INTEGER;

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

    --RETRIEVE REASON CODES
    SELECT r.id INTO reason_code_92 FROM  reasoncode r WHERE r.code='92';
    SELECT r.id INTO reason_code_40 FROM  reasoncode r WHERE r.code='40';
    SELECT r.id INTO reason_code_42 FROM  reasoncode r WHERE r.code='42';
    SELECT r.id INTO reason_code_90 FROM  reasoncode r WHERE r.code='90';
    SELECT r.id INTO reason_code_41 FROM  reasoncode r WHERE r.code='41';
    SELECT r.id INTO reason_code_60 FROM  reasoncode r WHERE r.code='60';


    --RETRIEVE DRUGS
    SELECT d.id into drug_1 FROM drug d WHERE d.name='drug_1';
    SELECT d.id into drug_2 FROM drug d WHERE d.name='drug_2';
    SELECT d.id into drug_3 FROM drug d WHERE d.name='drug_3';
    SELECT d.id into drug_4 FROM drug d WHERE d.name='drug_4';
    SELECT d.id into drug_5 FROM drug d WHERE d.name='drug_5';
    SELECT d.id into drug_6 FROM drug d WHERE d.name='drug_6';
    SELECT d.id into drug_7 FROM drug d WHERE d.name='drug_7';
    SELECT d.id into drug_8 FROM drug d WHERE d.name='drug_8';
    SELECT d.id into drug_9 FROM drug d WHERE d.name='drug_9';
    SELECT d.id into drug_10_inactive FROM drug d WHERE d.name='drug_10_inactive';
    SELECT d.id into drug_11_inactive FROM drug d WHERE d.name='drug_11_inactive';

    --RETRIEVE TIERS
    SELECT t.id INTO tier_1 FROM tier t WHERE t.name='tier_1' ;
    SELECT t.id INTO tier_2 FROM tier t WHERE t.name='tier_2' ;
    SELECT t.id INTO tier_3 FROM tier t WHERE t.name='tier_3' ;
    SELECT t.id INTO tier_3p FROM tier t WHERE t.name='tier_3p' ;
    SELECT t.id INTO tier_4 FROM tier t WHERE t.name='tier_4' ;

    --RETRIEVE QUALIFIERS
    SELECT q.id INTO ql_qualifier FROM qualifier q WHERE q.name='Quantity Limits';
    SELECT q.id INTO pa_qualifier FROM qualifier q WHERE q.name='Prior Authorization';
    SELECT q.id INTO st_qualifier FROM qualifier q WHERE q.name='Step Therapy';
    SELECT q.id INTO or_qualifier FROM qualifier q WHERE q.name='Other Restrictions';

    --INSERT HEALTH PLANS

    ------INSERT FORMULARY 1------
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;--formulary 1
    --INSERT FORMULARY ENTRIES
    SELECT common_create_formulary_entry(formularyId,drug_1,tier_1,reason_code_92,NULL) INTO formularyEntryId;--formulary entry 1
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,ql_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_2,tier_3,reason_code_42,NULL) INTO formularyEntryId;--formulary entry 2
    SELECT common_create_formulary_entry(formularyId,drug_5,tier_4,reason_code_42,NULL) INTO formularyEntryId;--formulary entry 3
    SELECT common_create_formulary_entry(formularyId,drug_6,tier_4,NULL,NULL) INTO formularyEntryId;--formulary entry 4
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,ql_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_7,tier_4,NULL,NULL) INTO formularyEntryId;--formulary entry 5
    SELECT common_create_formulary_entry(formularyId,drug_11_inactive,tier_4,NULL,NULL) INTO formularyEntryId;--formulary entry 6
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);

    --INSERT HEALTH PLAN

    PERFORM common_create_healthplan(commercial_hpt_id,TRUE,'health_plan_comm',formularyId,provider_1_id);


    ------INSERT FORMULARY 2------
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;--formulary 2
    --INSERT FORMULARY ENTRIES
    SELECT common_create_formulary_entry(formularyId,drug_2,tier_2,reason_code_40,NULL) INTO formularyEntryId;--formulary entry 7
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,st_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_1,tier_3p,reason_code_90,NULL) INTO formularyEntryId;--formulary entry 8
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_3,tier_4,reason_code_41,NULL) INTO formularyEntryId;--formulary entry 9
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,ql_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_4,tier_4,reason_code_60,NULL) INTO formularyEntryId;--formulary entry 10
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,st_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,or_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_11_inactive,tier_2,NULL,NULL) INTO formularyEntryId;--formulary entry 11

    PERFORM common_create_healthplan(hix_hpt_id,TRUE,'health_plan_hix',formularyId,provider_1_id);

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

    --INSERT FORMULARY 3
    SELECT common_create_formulary(FALSE,FALSE,NULL) INTO formularyId;--formulary 3
    --INSERT FORMULARY ENTRY
    SELECT common_create_formulary_entry(formularyId,drug_1,tier_1,reason_code_90,NULL) INTO formularyEntryId;--formulary entry 12
     --INSERT FORMULARY ENTRY QUALIFIERS
     PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_2,tier_3p,NULL,NULL) INTO formularyEntryId;

    PERFORM common_create_healthplan(commercial_inactive_hpt_id,FALSE,'health_plan_com_inactive',formularyId,provider_1_id);

success=true;
return success;
END
$$ LANGUAGE plpgsql;