CREATE OR REPLACE FUNCTION common_create_formulary_entry(formulary_id INTEGER,drug_id INTEGER, tier_id INTEGER, is_reset_mode BOOLEAN, reason_code_id INTEGER,specialty_copay BOOLEAN) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
formulary_entry_id INTEGER DEFAULT NULL;
BEGIN
	
SELECT fe.id INTO formulary_entry_id FROM formularyentry fe WHERE fe.formularyfid=formulary_id and drugfid=drug_id LIMIT 1;

--VALIDATE IF THE FORMULARY ENTRY ALREADY EXISTS
IF formulary_entry_id IS NULL THEN
	--INSERT FORMULARY ENTRY RECORD
	INSERT INTO formularyentry(
        formularyfid, drugfid, tierfid, isresetmode, legacyfid, reasoncodefid, 
        updated_at, updated_by, specialty_copay, preferred, restriction_comments)
        VALUES (formulary_id, drug_id, tier_id, CASE when is_reset_mode IS NULL THEN FALSE ELSE is_reset_mode END, NULL, reason_code_id, 
        current_timestamp, NULL, CASE when specialty_copay IS NULL THEN FALSE ELSE specialty_copay END, NULL, NULL) RETURNING id INTO formulary_entry_id;

	RETURN formulary_entry_id;
ELSE
	RETURN formulary_entry_id;
END IF;

END
$$ LANGUAGE plpgsql;

