CREATE OR REPLACE FUNCTION test_data_tiers() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE TIERS
PERFORM common_create_tier(TRUE,'tier_1','tier_1');
PERFORM common_create_tier(TRUE,'tier_2','tier_2');
PERFORM common_create_tier(TRUE,'tier_3','tier_3');
PERFORM common_create_tier(TRUE,'tier_4','tier_4');
PERFORM common_create_tier(TRUE,'tier_5','tier_5');
PERFORM common_create_tier(TRUE,'tier_6','tier_6');
PERFORM common_create_tier(TRUE,'tier_7','tier_7');
PERFORM common_create_tier(TRUE,'Not Covered','NC');
PERFORM common_create_tier(TRUE,'N/A','NA');

success=true;
return success;
END
$$ LANGUAGE plpgsql;