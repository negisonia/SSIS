CREATE OR REPLACE FUNCTION  create_report_client(reportId integer, clientName varchar) --ADMIN DB
RETURNS integer AS $$
DECLARE
clientExists boolean;
reportExists boolean;
reportClientExists boolean;
clientId integer;
reportClientId integer;
BEGIN

SELECT EXISTS( SELECT 1 FROM reports r WHERE r.id=reportId) INTO reportExists;
SELECT create_client(clientName) INTO clientId;

IF reportExists  THEN
	SELECT EXISTS( SELECT 1 FROM report_clients rc WHERE rc.report_id=reportId AND rc.client_id=clientId) INTO reportClientExists;

	IF reportClientExists = false THEN
		INSERT INTO report_clients (report_id,client_id) VALUES(reportId,clientId) RETURNING id INTO reportClientId;	
	ELSE
		SELECT rc.id INTO reportClientId FROM report_clients rc WHERE rc.report_id=reportId AND rc.client_id=clientId;		
	END IF;
		
ELSE 
	select throw_error('REPORT ID PASSED AS ARGUMENT DOES NOT EXISTS');	 
        RETURN -1;
END IF;

RETURN reportClientId;

--EXCEPTION  when others then
--	select throw_error('Error creating client test data');	
--	RETURN -1;	
END
$$ LANGUAGE plpgsql;

