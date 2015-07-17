CREATE OR REPLACE FUNCTION common_create_drug_jcodes(drug_id INTEGER, jcode_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
drug_jcode_id INTEGER DEFAULT NULL;
BEGIN

SELECT d.id INTO drug_jcode_id FROM drugs_jcodes d WHERE d.drug_id=drug_id and d.jcode_id=jcode_id LIMIT 1;

--VALIDATE IF DRUG_JCODE ALREADY EXISTS
IF drug_jcode_id IS NULL THEN
	--INSERT NEW DRUG JCODE
	INSERT INTO drugs_jcodes(drug_id, jcode_id, created_at, updated_at)
	VALUES (drug_id, jcode_id, current_timestamp, current_timestamp) RETURNING id INTO drug_jcode_id;
	RETURN drug_jcode_id;
ELSE
	--RETURN EXISTING DRUG JCODE ID
	RETURN drug_jcode_id;
END IF;

END
$$ LANGUAGE plpgsql;