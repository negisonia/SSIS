CREATE OR REPLACE FUNCTION test_data_tiers() --FF NEW
RETURNS boolean AS $$
DECLARE
success BOOLEAN:=FALSE;
BEGIN

--CREATE TIERS
PERFORM common_create_tier(TRUE,'tier_1','tier_1');
PERFORM common_create_tier(TRUE,'tier_2','tier_2');
PERFORM common_create_tier(TRUE,'tier_3','tier_3');
PERFORM common_create_tier(TRUE,'tier_3p','tier_3p');
PERFORM common_create_tier(TRUE,'tier_4','tier_4');

success=true;
return success;
END
$$ LANGUAGE plpgsql;