CREATE OR REPLACE FUNCTION test_data_formulary_entry() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;

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
drug_004_id INTEGER;

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
tier_5 INTEGER;
tier_6 INTEGER;
tier_nc INTEGER;
tier_na INTEGER;

formulary_comm_id INTEGER;
formulary_hix_id INTEGER;
formulary_com_inactive_id INTEGER;
formulary_comm_1_id INTEGER;
formulary_empl_1_id INTEGER;
formulary_ma_1_id INTEGER;

drug VARCHAR:='drug';
tier VARCHAR:='tier';

BEGIN

    --RETRIEVE REASON CODES
    SELECT common_get_reason_code_id_by_code('92') INTO reason_code_92;
    SELECT common_get_reason_code_id_by_code('40') INTO reason_code_40;
    SELECT common_get_reason_code_id_by_code('42') INTO reason_code_42;
    SELECT common_get_reason_code_id_by_code('90') INTO reason_code_90;
    SELECT common_get_reason_code_id_by_code('41') INTO reason_code_41;
    SELECT common_get_reason_code_id_by_code('60') INTO reason_code_60;

    --RETRIEVE DRUGS
    SELECT common_get_table_id_by_name(drug, 'drug_1') INTO drug_1;
    SELECT common_get_table_id_by_name(drug, 'drug_2') INTO drug_2;
    SELECT common_get_table_id_by_name(drug, 'drug_3') INTO drug_3;
    SELECT common_get_table_id_by_name(drug, 'drug_4') INTO drug_4;
    SELECT common_get_table_id_by_name(drug, 'drug_5') INTO drug_5;
    SELECT common_get_table_id_by_name(drug, 'drug_6') INTO drug_6;
    SELECT common_get_table_id_by_name(drug, 'drug_7') INTO drug_7;
    SELECT common_get_table_id_by_name(drug, 'drug_8') INTO drug_8;
    SELECT common_get_table_id_by_name(drug, 'drug_9') INTO drug_9;
    SELECT common_get_table_id_by_name(drug, 'drug_10_inactive') INTO drug_10_inactive;
    SELECT common_get_table_id_by_name(drug, 'drug_11_inactive') INTO drug_11_inactive;
    SELECT common_get_table_id_by_name(drug, 'DRUG_001') INTO drug_001_id;
    SELECT common_get_table_id_by_name(drug, 'DRUG_002') INTO drug_002_id;
    SELECT common_get_table_id_by_name(drug, 'DRUG_003') INTO drug_003_id;
    SELECT common_get_table_id_by_name(drug, 'DRUG_004') INTO drug_004_id;

    --RETRIEVE TIERS
    SELECT common_get_table_id_by_name(tier, 'tier_1') INTO tier_1;
    SELECT common_get_table_id_by_name(tier, 'tier_2') INTO tier_2;
    SELECT common_get_table_id_by_name(tier, 'tier_3') INTO tier_3;
    SELECT common_get_table_id_by_name(tier, 'tier_4') INTO tier_4;
    SELECT common_get_table_id_by_name(tier, 'tier_5') INTO tier_5;
    SELECT common_get_table_id_by_name(tier, 'tier_6') INTO tier_6;
    SELECT common_get_table_id_by_name(tier, 'Not Covered') INTO tier_nc;
    SELECT common_get_table_id_by_name(tier, 'N/A') INTO tier_na;

    --RETRIEVE FORMULARIES
    SELECT common_get_formulary_id_by_plan_name('health_plan_comm') INTO formulary_comm_id;
    SELECT common_get_formulary_id_by_plan_name('health_plan_hix') INTO formulary_hix_id;
    SELECT common_get_formulary_id_by_plan_name('health_plan_com_inactive') INTO formulary_com_inactive_id;
    SELECT common_get_formulary_id_by_plan_name('health_plan_comm_1') INTO formulary_comm_1_id;
    SELECT common_get_formulary_id_by_plan_name('health_plan_empl_1') INTO formulary_empl_1_id;
    SELECT common_get_formulary_id_by_plan_name('health_plan_ma_1') INTO formulary_ma_1_id;
    
    --INSERT FORMULARY ENTRIES
    -- TEST_PLAN_001
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_001'), drug_001_id, tier_1, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_002
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_002'), drug_002_id, tier_1, NULL, NULL, TRUE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_003
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_003'), drug_001_id, tier_2, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_004
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_004'), drug_002_id, tier_2, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_005
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_005'), drug_001_id, tier_1, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_006
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_006'), drug_002_id, tier_2, NULL, NULL, TRUE, TRUE, FALSE, FALSE);
    -- TEST_PLAN_007
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_007'), drug_001_id, tier_3, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_008
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_008'), drug_003_id, tier_1, NULL, NULL, TRUE, TRUE, FALSE, FALSE);
    -- TEST_PLAN_009
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_009'), drug_003_id, tier_2, NULL, NULL, FALSE, TRUE, TRUE, FALSE);
    -- TEST_PLAN_010
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_010'), drug_003_id, tier_2, NULL, NULL, FALSE, FALSE, TRUE, FALSE);
    -- TEST_PLAN_011
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_011'), drug_003_id, tier_1, NULL, NULL, TRUE, TRUE, TRUE, TRUE);
    -- TEST_PLAN_012
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_012'), drug_003_id, tier_1, NULL, NULL, TRUE, TRUE, TRUE, TRUE);
    -- TEST_PLAN_013
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_013'), drug_003_id, tier_3, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_014
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_014'), drug_003_id, tier_2, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_015
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_015'), drug_003_id, tier_3, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_016
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_016'), drug_003_id, tier_3, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_017
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_017'), drug_003_id, tier_3, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_018
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_018'), drug_003_id, tier_na, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_019
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_019'), drug_003_id, tier_nc, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- TEST_PLAN_020
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_020'), drug_002_id, tier_2, NULL, NULL, TRUE, TRUE, TRUE, FALSE);
    -- TEST_PLAN_021
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_021'), drug_001_id, tier_4, NULL, NULL, FALSE, TRUE, TRUE, FALSE);
    -- TEST_PLAN_022
    PERFORM common_create_formulary_data(common_get_formulary_id_by_plan_name('TEST_PLAN_022'), drug_004_id, tier_2, NULL, NULL, TRUE, FALSE, TRUE, FALSE);
    --PA, ST, QL, OR
    -- formulary_entry 1
    PERFORM common_create_formulary_data(formulary_comm_id, drug_1, tier_1, reason_code_92, NULL, TRUE, FALSE, TRUE, FALSE);
    --formulary entry 2
    PERFORM common_create_formulary_data(formulary_hix_id, drug_2, tier_2, reason_code_40, NULL, TRUE, TRUE, FALSE, FALSE);
    --formulary entry 3
    PERFORM common_create_formulary_data(formulary_comm_id, drug_2, tier_3, reason_code_42, NULL, FALSE, FALSE, FALSE, FALSE);
    --formulary entry 4
    PERFORM common_create_formulary_data(formulary_hix_id, drug_1, tier_3, reason_code_90, NULL, TRUE, FALSE, FALSE, FALSE);
    --formulary entry 5
    PERFORM common_create_formulary_data(formulary_hix_id, drug_3, tier_4, reason_code_41, NULL, FALSE, FALSE, TRUE, FALSE);
    --formulary entry 6
    PERFORM common_create_formulary_data(formulary_hix_id, drug_4, tier_4, reason_code_60, NULL, FALSE, TRUE, FALSE, TRUE);
    --formulary entry 7
    PERFORM common_create_formulary_data(formulary_comm_id, drug_5, tier_4, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    --formulary entry 8
    PERFORM common_create_formulary_data(formulary_comm_id, drug_6, tier_4, NULL, NULL, TRUE, FALSE, TRUE, FALSE);
    --formulary entry 9
    PERFORM common_create_formulary_data(formulary_comm_id, drug_7, tier_4, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    -- formulary entry 10
    PERFORM common_create_formulary_data(formulary_com_inactive_id, drug_2, tier_3, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    --formulary entry 11
    PERFORM common_create_formulary_data(formulary_com_inactive_id, drug_1, tier_1, reason_code_90, NULL, TRUE, FALSE, FALSE, FALSE);
    --formulary entry 12
    PERFORM common_create_formulary_data(formulary_hix_id, drug_11_inactive, tier_2, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    --formulary entry 13
    PERFORM common_create_formulary_data(formulary_comm_id, drug_11_inactive, tier_4, NULL, NULL, TRUE, FALSE, FALSE, FALSE);
    --formulary entry 14
    PERFORM common_create_formulary_data(formulary_comm_1_id, drug_1, tier_1, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    --formulary entry 15
    PERFORM common_create_formulary_data(formulary_comm_1_id, drug_2, tier_2, NULL, NULL, TRUE, TRUE, TRUE, FALSE);
    --formulary entry 16
    PERFORM common_create_formulary_data(formulary_empl_1_id, drug_1, tier_3, NULL, NULL, TRUE, FALSE, TRUE, FALSE);
    --formulary entry 17
    PERFORM common_create_formulary_data(formulary_empl_1_id, drug_2, tier_2, NULL, NULL, FALSE, FALSE, TRUE, FALSE);
    --formulary entry 18
    PERFORM common_create_formulary_data(formulary_empl_1_id, drug_3, tier_6, NULL, NULL, TRUE, FALSE, FALSE, FALSE);
    --formulary entry 19
    PERFORM common_create_formulary_data(formulary_ma_1_id, drug_1, tier_3, reason_code_40, NULL, TRUE, FALSE, FALSE, FALSE);
    --formulary entry 20
    PERFORM common_create_formulary_data(formulary_ma_1_id, drug_2, tier_2, reason_code_41, NULL, FALSE, TRUE, FALSE, FALSE);
    --formulary entry 21
    PERFORM common_create_formulary_data(formulary_ma_1_id, drug_3, tier_1, NULL, NULL, FALSE, FALSE, FALSE, FALSE);
    --formulary entry 22
    PERFORM common_create_formulary_data(formulary_comm_id, drug_3, tier_6, NULL, NULL, TRUE, FALSE, TRUE, FALSE);
    --formulary entry 23
    PERFORM common_create_formulary_data(formulary_comm_1_id, drug_3, tier_4, reason_code_40, NULL, TRUE, FALSE, FALSE, FALSE);
    --formulary entry 24
    PERFORM common_create_formulary_data(formulary_comm_id, drug_9, tier_5, NULL, NULL, TRUE, TRUE, FALSE, FALSE);
    --formulary entry 25
    PERFORM common_create_formulary_data(formulary_comm_1_id, drug_9, tier_3, reason_code_41, NULL, TRUE, FALSE, TRUE, FALSE);
    --formulary entry 26
    PERFORM common_create_formulary_data(formulary_hix_id, drug_9, tier_2, NULL, NULL, TRUE, FALSE, FALSE, FALSE);
    --formulary entry 27
    PERFORM common_create_formulary_data(formulary_empl_1_id, drug_9, tier_1, reason_code_40, NULL, TRUE, TRUE, FALSE, FALSE);
    --formulary entry 28
    PERFORM common_create_formulary_data(formulary_ma_1_id, drug_9, tier_6, NULL, NULL, TRUE, FALSE, FALSE, FALSE);

success=true;
return success;
END
$$ LANGUAGE plpgsql;
