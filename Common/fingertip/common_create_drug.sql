CREATE OR REPLACE FUNCTION common_create_drug(is_active BOOLEAN, is_generic BOOLEAN, drug_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
drug_id INTEGER DEFAULT NULL;
BEGIN
	
SELECT d.id INTO drug_id FROM drug d WHERE d.name=drug_name LIMIT 1;
RAISE NOTICE 'drugid: %', drug_id;

--VALIDATE IF THE DRUG ALREADY EXISTS
IF drug_id IS NULL THEN
	--INSERT FORMULARY RECORD
	INSERT INTO drug(
            isactive, isgeneric, name, chemicalname, webname, rewritename, 
            bookname, manufacturerfid, genericdrugfid, informationurl, fdaverifydate, 
            legacyfid, createtimestamp, lastupdate, lastupdateffuserfid, 
            displayid, druglabelfid, isfeatured, is_multi_source, strengths, 
            notes, global_na_default, is_medical_benefits, is_injectable, 
            global_nc_rc_40_default)
    VALUES (CASE when is_active IS NULL THEN TRUE ELSE is_active END,CASE when is_generic IS NULL THEN TRUE ELSE is_generic END, drug_name, drug_name, drug_name, drug_name, 
            NULL, NULL, NULL, NULL, current_timestamp, 
            NULL, current_timestamp, current_timestamp, NULL, 
            NEXTVAL('drug_display_id_seq'), NULL, 0, 0, NULL, 
            NULL, FALSE, FALSE, FALSE, 
            FALSE) RETURNING id INTO drug_id;

	RETURN drug_id;
ELSE
	RETURN drug_id;
END IF;

END
$$ LANGUAGE plpgsql;

