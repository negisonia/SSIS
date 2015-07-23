CREATE OR REPLACE FUNCTION common_create_tier(is_active BOOLEAN, tier_name VARCHAR, code_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
tier_id INTEGER DEFAULT NULL;
BEGIN
	
SELECT t.id INTO tier_id FROM tier t WHERE t.name=tier_name AND t.codename=code_name LIMIT 1;

--VALIDATE IF THE TIER ALREADY EXISTS
IF tier_id IS NULL THEN
	--INSERT TIER RECORD
	INSERT INTO tier(isactive, name, codename, explanationtext, orderindex, legacyvalue)
        VALUES (CASE when is_active IS NULL THEN TRUE ELSE is_active END, tier_name, code_name, NULL, NEXTVAL('tier_order_index_id_seq'), NULL) RETURNING id INTO tier_id;
	RETURN tier_id;
ELSE
	RETURN tier_id;
END IF;

END
$$ LANGUAGE plpgsql;

