CREATE OR REPLACE FUNCTION common_create_formulary(is_active BOOLEAN, ppd_active BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
formulary_id INTEGER DEFAULT NULL;
BEGIN
	
	--INSERT FORMULARY RECORD
	INSERT INTO formulary(
           isactive, defaultbrandtierfid, defaultgenerictierfid, updatefrequencymonths, 
            lastupdate, lastupdateffuserfid, ppdapplies, publishuserfid, 
            createtimestamp, modifytimestamp, t3_preferred, preferred_brand_tier_id)
    VALUES (CASE when is_active IS NULL THEN TRUE ELSE is_active END , NULL, NULL, NULL, 
            current_timestamp, NULL, CASE when ppd_active IS NULL THEN FALSE ELSE ppd_active END, NULL, 
            current_timestamp, current_timestamp, 0, NULL) RETURNING id INTO formulary_id;

	RETURN formulary_id;

END
$$ LANGUAGE plpgsql;

