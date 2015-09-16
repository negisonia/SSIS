CREATE OR REPLACE FUNCTION test_data_formulary_entry() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
formulary_entry_id INTEGER;

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
tier_nc INTEGER;
tier_na INTEGER;

ql_qualifier INTEGER;
pa_qualifier INTEGER;
st_qualifier INTEGER;
or_qualifier INTEGER;

formulary_comm_id INTEGER;
formulary_hix_id INTEGER;
formulary_com_inactive_id INTEGER;
formulary_comm_1_id INTEGER;

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

drug VARCHAR:='drug';
tier VARCHAR:='tier';
qualifier VARCHAR:='qualifier';

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

    --RETRIEVE TIERS
    SELECT common_get_table_id_by_name(tier, 'tier_1') INTO tier_1;
    SELECT common_get_table_id_by_name(tier, 'tier_2') INTO tier_2;
    SELECT common_get_table_id_by_name(tier, 'tier_3') INTO tier_3;
    SELECT common_get_table_id_by_name(tier, 'tier_4') INTO tier_4;
    SELECT common_get_table_id_by_name(tier, 'Not Covered') INTO tier_nc;
    SELECT common_get_table_id_by_name(tier, 'N/A') INTO tier_na;

    --RETRIEVE QUALIFIERS
    SELECT common_get_table_id_by_name(qualifier, 'Quantity Limits') INTO ql_qualifier;
    SELECT common_get_table_id_by_name(qualifier, 'Prior Authorization') INTO pa_qualifier;
    SELECT common_get_table_id_by_name(qualifier, 'Step Therapy') INTO st_qualifier;
    SELECT common_get_table_id_by_name(qualifier, 'Other Restrictions') INTO or_qualifier;

    --RETRIEVE FORMULARIES
    SELECT common_get_formulary_id_by_plan_name('health_plan_comm') INTO formulary_comm_id;
    SELECT common_get_formulary_id_by_plan_name('health_plan_hix') INTO formulary_hix_id;
    SELECT common_get_formulary_id_by_plan_name('health_plan_com_inactive') INTO formulary_com_inactive_id;
    SELECT common_get_formulary_id_by_plan_name('health_plan_comm_1') INTO formulary_comm_1_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_001') INTO formulary_001_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_002') INTO formulary_002_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_003') INTO formulary_003_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_004') INTO formulary_004_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_005') INTO formulary_005_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_006') INTO formulary_006_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_007') INTO formulary_007_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_008') INTO formulary_008_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_009') INTO formulary_009_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_010') INTO formulary_010_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_011') INTO formulary_011_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_012') INTO formulary_012_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_013') INTO formulary_013_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_014') INTO formulary_014_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_015') INTO formulary_015_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_016') INTO formulary_016_id;
    SELECT common_get_formulary_id_by_plan_name('TEST_PLAN_017') INTO formulary_017_id;

    --INSERT FORMULARY ENTRIES
    PERFORM common_create_formulary_entry(formulary_001_id, drug_001_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_002_id, drug_002_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_003_id, drug_001_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_004_id, drug_002_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_005_id, drug_001_id, tier_1, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_006_id, drug_002_id, tier_2, 0, FALSE);
    PERFORM common_create_formulary_entry(formulary_007_id, drug_001_id, tier_3, 0, FALSE);
    SELECT common_create_formulary_entry(formulary_008_id, drug_003_id, tier_1, 0, FALSE) INTO formulary_entry_id;
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,pa_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,st_qualifier);

    SELECT common_create_formulary_entry(formulary_009_id, drug_003_id, tier_2, 0, FALSE) INTO formulary_entry_id;
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,st_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,ql_qualifier);

    SELECT common_create_formulary_entry(formulary_010_id, drug_003_id, tier_2, 0, FALSE) INTO formulary_entry_id;
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,ql_qualifier);
        PERFORM common_create_formulary_entry(formulary_011_id, drug_003_id, tier_1, 0, FALSE);

    SELECT common_create_formulary_entry(formulary_012_id, drug_003_id, tier_1, 0, FALSE) INTO formulary_entry_id;

        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,pa_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,ql_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,st_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,or_qualifier);

        PERFORM common_create_formulary_entry(formulary_013_id, drug_003_id, tier_3, 0, FALSE);
        PERFORM common_create_formulary_entry(formulary_014_id, drug_003_id, tier_2, 0, FALSE);
        PERFORM common_create_formulary_entry(formulary_015_id, drug_003_id, tier_3, 0, FALSE);
        PERFORM common_create_formulary_entry(formulary_016_id, drug_003_id, tier_3, 0, FALSE);
        PERFORM common_create_formulary_entry(formulary_017_id, drug_003_id, tier_3, 0, FALSE);

    SELECT common_create_formulary_entry(formulary_comm_id, drug_1, tier_1, reason_code_92, NULL) INTO formulary_entry_id;--formulary entry 1
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,pa_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id,ql_qualifier);

        PERFORM common_create_formulary_entry(formulary_comm_id, drug_2, tier_3, reason_code_42, NULL);--formulary entry 3
        PERFORM common_create_formulary_entry(formulary_comm_id, drug_5, tier_4, reason_code_42, NULL);--formulary entry 7
    SELECT common_create_formulary_entry(formulary_comm_id, drug_6, tier_4, NULL, NULL) INTO formulary_entry_id;--formulary entry 8
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, ql_qualifier);

        PERFORM common_create_formulary_entry(formulary_comm_id, drug_7, tier_4, NULL, NULL);--formulary entry 9
    SELECT common_create_formulary_entry(formulary_comm_id, drug_11_inactive,tier_4, NULL, NULL) INTO formulary_entry_id;--formulary entry 13
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_2, tier_2, reason_code_40, NULL) INTO formulary_entry_id;--formulary entry 2
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, st_qualifier);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_1, tier_3, reason_code_90, NULL) INTO formulary_entry_id;--formulary entry 4
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_3, tier_4, reason_code_41, NULL) INTO formulary_entry_id;--formulary entry 5
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, ql_qualifier);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_4, tier_4, reason_code_60, NULL) INTO formulary_entry_id;--formulary entry 6
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, st_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, or_qualifier);

    SELECT common_create_formulary_entry(formulary_hix_id, drug_11_inactive, tier_2, NULL, NULL) INTO formulary_entry_id;--formulary entry 12
    SELECT common_create_formulary_entry(formulary_com_inactive_id, drug_1, tier_1, reason_code_90, NULL) INTO formulary_entry_id;--formulary entry 11
        --INSERT FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);

        PERFORM common_create_formulary_entry(formulary_com_inactive_id, drug_2, tier_3, NULL, NULL);
        PERFORM common_create_formulary_entry(common_get_formulary_id_by_plan_name('TEST_PLAN_018'), drug_003_id, tier_na, NULL, NULL);
        PERFORM common_create_formulary_entry(common_get_formulary_id_by_plan_name('TEST_PLAN_019'), drug_003_id, tier_nc, NULL, NULL);
        PERFORM common_create_formulary_entry(common_get_formulary_id_by_plan_name('TEST_PLAN_020'), drug_002_id, tier_2, NULL, NULL);


    SELECT common_create_formulary_entry(formulary_comm_1_id, drug_1, tier_1, NULL, NULL) INTO formulary_entry_id;--formulary entry 14
    SELECT common_create_formulary_entry(formulary_comm_1_id, drug_2, tier_2, NULL, NULL) INTO formulary_entry_id;--formulary entry 15

        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, pa_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, st_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formulary_entry_id, ql_qualifier);

success=true;
return success;
END
$$ LANGUAGE plpgsql;