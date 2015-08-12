CREATE OR REPLACE FUNCTION test_data_formularies() --FF NEW
RETURNS boolean AS $$
DECLARE

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

ql_qualifier INTEGER;
pa_qualifier INTEGER;
st_qualifier INTEGER;
or_qualifier INTEGER;

tier_1 INTEGER;
tier_2 INTEGER;
tier_3 INTEGER;
tier_3p INTEGER;
tier_4 INTEGER;

health_plan_type_commercial INTEGER;
health_plan_type_hix INTEGER;

reason_code_1 INTEGER;
reason_code_2 INTEGER;
reason_code_3 INTEGER;
reason_code_4 INTEGER;
reason_code_5 INTEGER;
reason_code_6 INTEGER;

formularyId INTEGER;
formularyEntryId INTEGER;
success BOOLEAN:=FALSE;

BEGIN


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

--RETRIEVE QUALIFIERS
SELECT q.id INTO ql_qualifier FROM qualifier q WHERE q.name='Quantity Limits';
SELECT q.id INTO pa_qualifier FROM qualifier q WHERE q.name='Prior Authorization';
SELECT q.id INTO st_qualifier FROM qualifier q WHERE q.name='Step Therapy';
SELECT q.id INTO or_qualifier FROM qualifier q WHERE q.name='Other Restrictions';

raise notice ''+ql_qualifier;
raise notice ''+pa_qualifier;
raise notice ''+st_qualifier;
raise notice ''+or_qualifier;

--RETRIEVE REASON CODES
SELECT r.id INTO reason_code_1 FROM  reasoncode r WHERE r.code='92';
SELECT r.id INTO reason_code_2 FROM  reasoncode r WHERE r.code='40';
SELECT r.id INTO reason_code_3 FROM  reasoncode r WHERE r.code='42';
SELECT r.id INTO reason_code_4 FROM  reasoncode r WHERE r.code='90';
SELECT r.id INTO reason_code_5 FROM  reasoncode r WHERE r.code='41';
SELECT r.id INTO reason_code_6 FROM  reasoncode r WHERE r.code='60';

--RETRIEVE TIERS
SELECT t.id INTO tier_1 FROM tier t WHERE t.name='tier_1' ;
SELECT t.id INTO tier_2 FROM tier t WHERE t.name='tier_2' ;
SELECT t.id INTO tier_3 FROM tier t WHERE t.name='tier_3' ;
SELECT t.id INTO tier_3p FROM tier t WHERE t.name='tier_3p' ;
SELECT t.id INTO tier_4 FROM tier t WHERE t.name='tier_4' ;


--CREATE FORMULARIES
--FORMULARY 1
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    --FORMULARY ENTRY
    SELECT common_create_formulary_entry(formularyId,drug_1,tier_1,reason_code_1,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    UPDATE healthplan SET formularyfid=formularyId WHERE name='health_plan_comm';

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,ql_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_2,tier_3,reason_code_3,NULL) INTO formularyEntryId;
    SELECT common_create_formulary_entry(formularyId,drug_5,tier_4,reason_code_3,NULL) INTO formularyEntryId;
    SELECT common_create_formulary_entry(formularyId,drug_6,tier_4,NULL,NULL) INTO formularyEntryId;
    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,ql_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_7,tier_4,NULL,NULL) INTO formularyEntryId;
    SELECT common_create_formulary_entry(formularyId,drug_2,tier_3p,NULL,NULL) INTO formularyEntryId;
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);

--FORMULARY 2
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;

    --FORMULARY ENTRY
    SELECT common_create_formulary_entry(formularyId,drug_2,tier_2,reason_code_1,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    UPDATE healthplan SET formularyfid=formularyId WHERE name='health_plan_hix';

    --FORMULARY ENTRY QUALIFIERS
        PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);
        PERFORM common_create_formulary_entry_qualifier(formularyEntryId,st_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_1,tier_3p,reason_code_4,NULL) INTO formularyEntryId;
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,ql_qualifier);
// rename this file to formulary_entry
// SELECT formularyfid del healthplan del nombre xxx
// inser formularyenttry
// inser formularyentryqualifer

    SELECT common_create_formulary_entry(formularyId,drug_3,tier_4,reason_code_5,NULL) INTO formularyEntryId;
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,ql_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_4,tier_4,reason_code_6,NULL) INTO formularyEntryId;
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,st_qualifier);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,or_qualifier);


    SELECT common_create_formulary_entry(formularyId,drug_11_inactive,tier_4,NULL,NULL) INTO formularyEntryId;
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);

--FORMULARY 3
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;

    --FORMULARY ENTRY
    SELECT common_create_formulary_entry(formularyId,drug_1,tier_1,reason_code_4,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    UPDATE healthplan SET formularyfid=formularyId WHERE name='health_plan_comm_2';

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,pa_qualifier);

    SELECT common_create_formulary_entry(formularyId,drug_2,tier_3p,NULL,NULL) INTO formularyEntryId;

success=true;
return success;
END
$$ LANGUAGE plpgsql;