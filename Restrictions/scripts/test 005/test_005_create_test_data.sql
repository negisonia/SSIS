CREATE OR REPLACE FUNCTION restrictions_test_005_create_test_data() --FF NEW DB
RETURNS boolean AS $$
DECLARE
tier_1 INTEGER;
tier_2 INTEGER;
tier_3 INTEGER;
tier_3p INTEGER;
tier_4 INTEGER;

qualifier_1 INTEGER;
qualifier_2 INTEGER;
qualifier_3 INTEGER;
qualifier_4 INTEGER;

reason_code_1 INTEGER;
reason_code_2 INTEGER;
reason_code_3 INTEGER;
reason_code_4 INTEGER;
reason_code_5 INTEGER;
reason_code_6 INTEGER;

drug_1 INTEGER;
drug_2 INTEGER;
drug_3 INTEGER;
drug_4 INTEGER;
drug_5 INTEGER;
drug_6 INTEGER;
drug_7 INTEGER;
drug_8 INTEGER;
drug_9 INTEGER;
drug_10 INTEGER;
drug_11 INTEGER;

health_plan_type_commercial INTEGER;
health_plan_type_hix INTEGER;

formularyId INTEGER;
formularyEntryId INTEGER;

drug_names VARCHAR[] := ARRAY['restrictions_drug_1','restrictions_drug_2','restrictions_drug_3','restrictions_drug_4','restrictions_drug_5','restrictions_drug_6','restrictions_drug_7','restrictions_drug_8','restrictions_drug_9','restrictions_drug_10','restrictions_drug_11'];
health_plan_types VARCHAR[] := ARRAY['restrictions_test_commercial','restrictions_test_hix','restrictions_test_commercial_bcbs','restrictions_test_employer','restrictions_test_medicare_ma','restrictions_test_medicare_sn','restrictions_test_medicare_pdp','restrictions_test_state_medicare','restrictions_test_dpp','restrictions_test_commercial_medicaid','restrictions_test_union','restrictions_test_municipal_plan','restrictions_test_pbm','restrictions_test_commercial_inactive'];

textValue VARCHAR;
success BOOLEAN DEFAULT FALSE;
BEGIN

--RETRIEVE DRUGS IDS
FOREACH textValue IN ARRAY drug_names
LOOP
	CASE textValue
		WHEN 'restrictions_drug_1' THEN
			SELECT d.id INTO drug_1 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_2' THEN
			SELECT d.id INTO drug_2 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_3' THEN
			SELECT d.id INTO drug_3 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_4' THEN
			SELECT d.id INTO drug_4 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_5' THEN
			SELECT d.id INTO drug_5 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_6' THEN
			SELECT d.id INTO drug_6 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_7' THEN
			SELECT d.id INTO drug_7 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_8' THEN
			SELECT d.id INTO drug_8 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_9' THEN
			SELECT d.id INTO drug_9 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_10' THEN
			SELECT d.id INTO drug_10 FROM drug d WHERE d.name=textValue;
		WHEN 'restrictions_drug_11' THEN
			SELECT d.id INTO drug_11 FROM drug d WHERE d.name=textValue;
		ELSE
			RAISE NOTICE 'UNEXPECTED DRUG NAME';
	END CASE;
END LOOP;

--RETRIEVE HEALTH PLAN TYPES
SELECT hpt.id INTO health_plan_type_commercial FROM healthplantype hpt WHERE hpt.name='restrictions_test_commercial' and hpt.isactive IS TRUE LIMIT 1;
SELECT hpt.id INTO health_plan_type_hix  FROM healthplantype hpt WHERE hpt.name='restrictions_test_hix' and hpt.isactive IS TRUE LIMIT 1;


--CREATE TIERS
SELECT common_create_tier(TRUE,'restrictions_tier_1','restrictions_tier_1') INTO tier_1;
SELECT common_create_tier(TRUE,'restrictions_tier_2','restrictions_tier_2') INTO tier_2;
SELECT common_create_tier(TRUE,'restrictions_tier_3','restrictions_tier_3') INTO tier_3;
SELECT common_create_tier(TRUE,'restrictions_tier_3p','restrictions_tier_3p') INTO tier_3p;
SELECT common_create_tier(TRUE,'restrictions_tier_4','restrictions_tier_4') INTO tier_4;

--CREATE QUALIFIERS
SELECT common_create_qualifier(TRUE,'Quantity Limits','QL') INTO qualifier_1;
SELECT common_create_qualifier(TRUE,'Prior Authorization','PA') INTO qualifier_2;
SELECT common_create_qualifier(TRUE,'Step Therapy','ST') INTO qualifier_3;
SELECT common_create_qualifier(TRUE,'Other Restrictions','OR') INTO qualifier_4;


--CREATE REASON CODES
SELECT common_create_reason_codes(1,'92','PA required if recommended dose duration exceeded.',qualifier_2) INTO reason_code_1;
SELECT common_create_reason_codes(1,'40','Covered under medical benefit.',NULL) INTO reason_code_2;
SELECT common_create_reason_codes(1,'42','Non-preferred under medical benefit.',NULL) INTO reason_code_3;
SELECT common_create_reason_codes(1,'90','PA not required on initial fill.',qualifier_2) INTO reason_code_4;
SELECT common_create_reason_codes(1,'41','Preferred under medical benefit',NULL) INTO reason_code_5;
SELECT common_create_reason_codes(1,'60','Age restriction, PA may be required.',NULL) INTO reason_code_6;


--CREATE FORMULARIES
--FORMULARY 1
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    --FORMULARY ENTRY
    SELECT common_create_formulary_entry(formularyId,drug_1,tier_1,reason_code_1,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_commercial,TRUE,'restrictions_test_05_commercial_1',formularyId,NULL);

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_2);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_1);

--FORMULARY 2
    --FORMULARY ENTRY
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_2,tier_2,reason_code_2,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_hix,TRUE,'restrictions_test_05_hix_1',formularyId,NULL);

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_2);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_3);

--FORMULARY 3
    --FORMULARY ENTRY
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_2,tier_3,reason_code_3,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_commercial,TRUE,'restrictions_test_05_commercial_2',formularyId,NULL);

--FORMULARY 4
    --FORMULARY ENTRY
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_1,tier_3p,reason_code_4,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_hix,TRUE,'restrictions_test_05_hix_2',formularyId,NULL);

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_2);

--FORMULARY 5
    --FORMULARY ENTRY
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_3,tier_4,reason_code_5,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_hix,TRUE,'restrictions_test_05_hix_3',formularyId,NULL);

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_1);

--FORMULARY 6
    --FORMULARY ENTRY
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_4,tier_4,reason_code_6,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_hix,TRUE,'restrictions_test_05_hix_4',formularyId,NULL);

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_3);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_4);

--FORMULARY 7
    --FORMULARY ENTRY
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_5,tier_4,reason_code_3,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_commercial,TRUE,'restrictions_test_05_commercial_3',formularyId,NULL);

--FORMULARY 8
    --FORMULARY ENTRY
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_6,tier_4,NULL,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_commercial,TRUE,'restrictions_test_05_commercial_4',formularyId,NULL);

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_1);
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_2);


--FORMULARY 9
    --FORMULARY ENTRY
    SELECT common_create_formulary(TRUE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_7,tier_4,NULL,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_commercial,TRUE,'restrictions_test_05_commercial_5',formularyId,NULL);

--FORMULARY 10
    --FORMULARY ENTRY
    SELECT common_create_formulary(FALSE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_2,tier_3p,NULL,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_commercial,FALSE,'restrictions_test_05_commercial_6',formularyId,NULL);

--FORMULARY 11
    --FORMULARY ENTRY
    SELECT common_create_formulary(FALSE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_1,tier_1,reason_code_4,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_commercial,FALSE,'restrictions_test_05_commercial_7',formularyId,NULL);

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_2);

--FORMULARY 12
    --FORMULARY ENTRY
    SELECT common_create_formulary(FALSE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_11,tier_2,NULL,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_hix,TRUE,'restrictions_test_05_hix_5',formularyId,NULL);


--FORMULARY 13
    --FORMULARY ENTRY
    SELECT common_create_formulary(FALSE,FALSE,NULL) INTO formularyId;
    SELECT common_create_formulary_entry(formularyId,drug_11,tier_4,NULL,NULL) INTO formularyEntryId;

    --HEALTHPLAN
    PERFORM common_create_healthplan(health_plan_type_commercial,TRUE,'restrictions_test_05_commercial_8',formularyId,NULL);

    --FORMULARY ENTRY QUALIFIERS
    PERFORM common_create_formulary_entry_qualifier(formularyEntryId,qualifier_2);

success=true;
return success;
END
$$ LANGUAGE plpgsql;