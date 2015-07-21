CREATE OR REPLACE FUNCTION common_create_qualifier(is_active BOOLEAN, qualifier_name VARCHAR, code_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
qualifier_id INTEGER DEFAULT NULL;
BEGIN

SELECT q.id INTO qualifier_id FROM qualifier q WHERE q.name=qualifier_name or q.codename=code_name LIMIT 1;

--VALIDATE IF THE QUALIFIER ALREADY EXISTS
IF qualifier_id IS NULL THEN
	--INSERT QUALIFIER RECORD
	 INSERT INTO qualifier(
                 isactive, name, codename, explanationtext, orderindex, restrictionsindex,
                 restrictionsreportindex)
         VALUES ( CASE WHEN is_active IS NULL THEN TRUE ELSE is_active END, qualifier_name, code_name, NULL,NEXTVAL('tier_order_index_id_seq'), NULL,
                 NULL) RETURNING id INTO qualifier_id;
	RETURN qualifier_id;
ELSE
	RETURN qualifier_id;
END IF;

END
$$ LANGUAGE plpgsql;

