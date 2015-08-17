CREATE OR REPLACE FUNCTION test_data_formulary_entry() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
formulary_entry_id INTEGER;

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
drug_001_id INTEGER;
drug_002_id INTEGER;
drug_003_id INTEGER;

reason_code_92 INTEGER;
reason_code_40 INTEGER;
reason_code_42 INTEGER;
reason_code_90 INTEGER;
reason_code_41 INTEGER;
reason_code_60 INTEGER;

tier_1 INTEGER;
tier_2 INTEGER;
tier_3 INTEGER;
tier_4 INTEGER;

ql_qualifier INTEGER;
pa_qualifier INTEGER;
st_qualifier INTEGER;
or_qualifier INTEGER;

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

BEGIN

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
    SELECT d.id into drug_001_id FROM drug d WHERE d.name='DRUG_001';
    SELECT d.id into drug_002_id FROM drug d WHERE d.name='DRUG_002';
    SELECT d.id into drug_003_id FROM drug d WHERE d.name='DRUG_003';

    --RETRIEVE TIERS
    SELECT t.id INTO tier_1 FROM tier t WHERE t.name='tier_1' ;
    SELECT t.id INTO tier_2 FROM tier t WHERE t.name='tier_2' ;
    SELECT t.id INTO tier_3 FROM tier t WHERE t.name='tier_3' ;
    SELECT t.id INTO tier_4 FROM tier t WHERE t.name='tier_4' ;

    --RETRIEVE QUALIFIERS
    SELECT q.id INTO ql_qualifier FROM qualifier q WHERE q.name='Quantity Limits';
    SELECT q.id INTO pa_qualifier FROM qualifier q WHERE q.name='Prior Authorization';
    SELECT q.id INTO st_qualifier FROM qualifier q WHERE q.name='Step Therapy';
    SELECT q.id INTO or_qualifier FROM qualifier q WHERE q.name='Other Restrictions';

    --RETRIEVE FORMULARIES
    SELECT h.formularyfid INTO formulary_comm_id FROM healthplan h WHERE h.name='health_plan_comm';
    SELECT h.formularyfid INTO formulary_hix_id FROM healthplan h WHERE h.name='health_plan_hix';
    SELECT h.formularyfid INTO formulary_com_inactive_id FROM healthplan h WHERE h.name='health_plan_com_inactive';
    SELECT h.formularyfid INTO formulary_001_id FROM healthplan h WHERE h.name='TEST_PLAN_001';
    SELECT h.formularyfid INTO formulary_002_id FROM healthplan h WHERE h.name='TEST_PLAN_002';
    SELECT h.formularyfid INTO formulary_003_id FROM healthplan h WHERE h.name='TEST_PLAN_003';
    SELECT h.formularyfid INTO formulary_004_id FROM healthplan h WHERE h.name='TEST_PLAN_004';
    SELECT h.formularyfid INTO formulary_005_id FROM healthplan h WHERE h.name='TEST_PLAN_005';
    SELECT h.formularyfid INTO formulary_006_id FROM healthplan h WHERE h.name='TEST_PLAN_006';
    SELECT h.formularyfid INTO formulary_007_id FROM healthplan h WHERE h.name='TEST_PLAN_007';
    SELECT h.formularyfid INTO formulary_008_id FROM healthplan h WHERE h.name='TEST_PLAN_008';
    SELECT h.formularyfid INTO formulary_009_id FROM healthplan h WHERE h.name='TEST_PLAN_009';
    SELECT h.formularyfid INTO formulary_010_id FROM healthplan h WHERE h.name='TEST_PLAN_010';
    SELECT h.formularyfid INTO formulary_011_id FROM healthplan h WHERE h.name='TEST_PLAN_011';
    SELECT h.formularyfid INTO formulary_012_id FROM healthplan h WHERE h.name='TEST_PLAN_012';
    SELECT h.formularyfid INTO formulary_013_id FROM healthplan h WHERE h.name='TEST_PLAN_013';
    SELECT h.formularyfid INTO formulary_014_id FROM healthplan h WHERE h.name='TEST_PLAN_014';
    SELECT h.formularyfid INTO formulary_015_id FROM healthplan h WHERE h.name='TEST_PLAN_015';
    SELECT h.formularyfid INTO formulary_016_id FROM healthplan h WHERE h.name='TEST_PLAN_016';
    SELECT h.formularyfid INTO formulary_017_id FROM healthplan h WHERE h.name='TEST_PLAN_017';

    --INSERT FORMULARY ENTRIES
    PERFORM common_create_formulary_entry(formulary_001_id, drug_001_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_002_id, drug_002_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_003_id, drug_001_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_004_id, drug_002_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_005_id, drug_001_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_006_id, drug_002_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_007_id, drug_001_id, tier_3, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_008_id, drug_003_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_009_id, drug_003_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_010_id, drug_003_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_011_id, drug_003_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_012_id, drug_003_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_013_id, drug_003_id, tier_3, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_014_id, drug_003_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_015_id, drug_003_id, tier_3, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_016_id, drug_003_id, tier_3, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_017_id, drug_003_id, tier_3, 0, FALSE);

    SELECT common_create_formulary_entry(formulary_comm_id, drug_1, tier_1, reason_code_92, NULL) INTO formulary_entry_id;--formulary entry 1
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,pa_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,ql_qualifier);
    --INSERT MV_ACTIVE_FORMULARIES
    PERFORM common_create_mv_active_formularies(formulary_comm_id , drug_1 , tier_1 , TRUE, TRUE, FALSE,FALSE, NULL);

    PERFORM common_create_formulary_entry(formulary_comm_id, drug_2, tier_3, reason_code_42, NULL);--formulary entry 3
    PERFORM common_create_formulary_entry(formulary_comm_id, drug_5, tier_4, reason_code_42, NULL);--formulary entry 7
    SELECT common_create_formulary_entry(formulary_comm_id, drug_6, tier_4, NULL, NULL) INTO formulary_entry_id;--formulary entry 8
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, ql_qualifier);
    PERFORM common_create_mv_active_formularies(formulary_comm_id, drug_6, tier_4, TRUE, TRUE, FALSE,FALSE, NULL);

    PERFORM common_create_formulary_entry(formulary_comm_id, drug_7, tier_4, NULL, NULL);--formulary entry 9
    SELECT common_create_formulary_entry(formulary_comm_id, drug_11_inactive,tier_4, NULL, NULL) INTO formulary_entry_id;--formulary entry 13
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
    PERFORM common_create_mv_active_formularies(formulary_comm_id, drug_11_inactive, tier_4, FALSE, TRUE, FALSE,FALSE, NULL);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_2, tier_2, reason_code_40, NULL) INTO formulary_entry_id;--formulary entry 2
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, st_qualifier);
    PERFORM common_create_mv_active_formularies(formulary_hix_id, drug_2, tier_2, FALSE, TRUE, TRUE,FALSE, NULL);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_1, tier_3p, reason_code_90, NULL) INTO formulary_entry_id;--formulary entry 4
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
    PERFORM common_create_mv_active_formularies(formulary_hix_id, drug_1, tier_3p, FALSE, TRUE, FALSE,FALSE, NULL);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_3, tier_4, reason_code_41, NULL) INTO formulary_entry_id;--formulary entry 5
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, ql_qualifier);
    PERFORM common_create_mv_active_formularies(formulary_hix_id, drug_3, tier_4, TRUE, FALSE, FALSE,FALSE, NULL);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_4, tier_4, reason_code_60, NULL) INTO formulary_entry_id;--formulary entry 6
    --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, st_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, or_qualifier);
    PERFORM common_create_mv_active_formularies(formulary_hix_id, drug_4, tier_4, FALSE, FALSE, TRUE,TRUE, NULL);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_11_inactive, tier_2, NULL, NULL) INTO formulary_entry_id;--formulary entry 12
    --INSERT FORMULARY ENTRY
    SELECT common_create_formulary_entry(formulary_com_inactive_id, drug_1, tier_1, reason_code_90, NULL) INTO formulary_entry_id;--formulary entry 11
     --INSERT FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
    PERFORM common_create_mv_active_formularies(formulary_com_inactive_id, drug_1, tier_1, FALSE,TRUE, FALSE,FALSE, NULL);

    PERFORM common_create_formulary_entry(formulary_com_inactive_id, drug_2, tier_3p, NULL, NULL);

success=true;
return success;
END
$$ LANGUAGE plpgsql;