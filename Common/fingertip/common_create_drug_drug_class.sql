CREATE OR REPLACE FUNCTION common_create_drug_drug_class(drug_id INTEGER, drug_class_id INTEGER) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
drug_drug_class_id INTEGER DEFAULT NULL;
BEGIN

SELECT d.id INTO drug_drug_class_id FROM drugdrugclass d WHERE d.drugfid=drug_id and d.drugclassfid=drug_class_id LIMIT 1;

--VALIDATE IF DRUG_JCODE ALREADY EXISTS
IF drug_drug_class_id IS NULL THEN
	--INSERT NEW DRUG JCODE
	INSERT INTO drugdrugclass(drugfid, drugclassfid)
	VALUES (drug_id, drug_class_id) RETURNING id INTO drug_drug_class_id;
	RETURN drug_drug_class_id;
ELSE
	--RETURN EXISTING DRUG JCODE ID
	RETURN drug_drug_class_id;
END IF;

END
$$ LANGUAGE plpgsql;