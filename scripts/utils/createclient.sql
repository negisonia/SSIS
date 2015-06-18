CREATE OR REPLACE FUNCTION  createClient(clientName varchar)
RETURNS integer AS $$
DECLARE
clientExists boolean;
reportExists boolean;
reportClientExists boolean;
clientId integer;
BEGIN

SELECT EXISTS( SELECT 1 FROM clients c WHERE c.name=clientName) INTO clientExists;

	IF clientExists = false THEN
		INSERT INTO clients (name) VALUES (clientName);
	END IF;

	SELECT c.id INTO clientId FROM clients c WHERE c.name=clientName;
	

RETURN clientId;

EXCEPTION  when others then
	select throw_eror('Error creating client test data');	
	RETURN -1;	
END
$$ LANGUAGE plpgsql;

