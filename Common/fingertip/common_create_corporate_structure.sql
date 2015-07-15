CREATE OR REPLACE FUNCTION common_create_corporate_structure(cs_name varchar, order_id INTEGER)--FF_NEW DB
RETURNS INTEGER AS $$
DECLARE
corporateStructureId INTEGER DEFAULT NULL;
BEGIN

SELECT c.id INTO corporateStructureId FROM corporate_structure c WHERE c.name =cs_name LIMIT 1;

--VALIDATE IF THE CORPORATE STRUCTURE ALREADY EXISTS
IF corporateStructureId IS NULL  THEN		
	--INSERT CORPORATE STRUCTURE RECORD
	INSERT INTO corporate_structure(name, orderid)
	VALUES (cs_name, CASE when order_id = NULL THEN 0 ELSE order_id END)  RETURNING id INTO corporateStructureId;        
	RETURN corporateStructureId;
ELSE
	RETURN corporateStructureId;
END IF;
END
$$ LANGUAGE plpgsql;





