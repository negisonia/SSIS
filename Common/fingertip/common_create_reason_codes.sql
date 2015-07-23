CREATE OR REPLACE FUNCTION common_create_reason_codes(is_active INTEGER, reason_code VARCHAR, reason_text VARCHAR, qualifier_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
reason_code_id INTEGER DEFAULT NULL;
BEGIN

SELECT rc.id INTO reason_code_id FROM reasoncode rc WHERE rc.code=reason_code LIMIT 1;

--VALIDATE IF THE TIER ALREADY EXISTS
IF reason_code_id IS NULL THEN
	--INSERT TIER RECORD
	INSERT INTO reasoncode(
                code, text, webtext, isactive, createtimestamp, modifytimestamp,
                modifiedby, webtext_sp, qualifier_id)
        VALUES (reason_code, reason_text, reason_text, CASE WHEN is_active IS NULL THEN 1 ELSE is_active END, current_timestamp, current_timestamp,
                1, reason_text, qualifier_id) RETURNING id INTO reason_code_id;
	RETURN reason_code_id;
ELSE
	RETURN reason_code_id;
END IF;

END
$$ LANGUAGE plpgsql;

