CREATE OR REPLACE FUNCTION test_data_tiers() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE TIERS
PERFORM common_create_tier(1, TRUE,'tier_1','tier_1');
PERFORM common_create_tier(2, TRUE,'tier_2','tier_2');
PERFORM common_create_tier(3, TRUE,'tier_3','tier_3');
PERFORM common_create_tier(4, TRUE,'tier_4','tier_4');
PERFORM common_create_tier(5, TRUE,'tier_5','tier_5');
PERFORM common_create_tier(6, TRUE,'tier_6','tier_6');
PERFORM common_create_tier(7, TRUE,'tier_7','tier_7');
PERFORM common_create_tier(10, TRUE,'Not Covered','NC');
PERFORM common_create_tier(8, TRUE,'N/A','NA');

success=true;
return success;
END
$$ LANGUAGE plpgsql;