CREATE OR REPLACE FUNCTION  common_create_client(clientName varchar) --ADMIN DB
RETURNS integer AS $$
DECLARE
clientId INTEGER DEFAULT NULL;
BEGIN

SELECT c.id INTO clientId FROM clients c WHERE c.name=clientName LIMIT 1;

IF clientId IS NULL THEN
	INSERT INTO clients (name) VALUES (clientName) RETURNING id INTO clientId;;
END IF;

RETURN clientId;
END
$$ LANGUAGE plpgsql;

