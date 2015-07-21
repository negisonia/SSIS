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

BEGIN

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

--ITERATE DRUGS NAMES
FOREACH textValue IN ARRAY drug_names
LOOP

	
	
END LOOP;

success=true;
return success;
END
$$ LANGUAGE plpgsql;