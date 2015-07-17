CREATE OR REPLACE FUNCTION common_create_drugclass(is_active BOOLEAN, drug_class_name VARCHAR, web_name VARCHAR, rewrite_name VARCHAR, book_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
drug_class_id INTEGER DEFAULT NULL;
BEGIN

SELECT d.id INTO drug_class_id FROM drugclass d WHERE (d.name=drug_class_name) or (d.webname=web_name) or (d.rewritename=rewrite_name) or (d.bookname=book_name) LIMIT 1;

--VALIDATE IF JCODE ALREADY EXISTS
IF drug_class_id IS NULL THEN
	--INSERT NEW JCODE
	INSERT INTO drugclass(isactive, name, webname, rewritename, bookname, legacyfid,lastupdate, lastupdateffuserfid, drugclassusetypefid, comments,ehs_code_1, ehs_code_2)
        VALUES (CASE  WHEN is_active IS NULL THEN TRUE ELSE is_active END, drug_class_name, web_name, rewrite_name, book_name, NULL,current_timestamp, NULL, NULL, NULL, NULL, NULL) RETURNING id INTO drug_class_id;
	RETURN drug_class_id;
ELSE
	--RETURN EXISTING JCODE ID
	RETURN drug_class_id;
END IF;

END
$$ LANGUAGE plpgsql;