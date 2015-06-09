CREATE OR REPLACE FUNCTION  test001createReportClientTestData(reportId integer)
RETURNS integer AS $$
DECLARE
clientExists boolean;
reportExists boolean;
reportClientExists boolean;
clientId integer;
clientName varchar DEFAULT 'TEST CLIENT 01';
reportClientId integer;
BEGIN

SELECT EXISTS( SELECT 1 FROM clients c WHERE c.name=clientName) INTO clientExists;
SELECT EXISTS( SELECT 1 FROM reports r WHERE r.id=reportId) INTO reportExists;

IF reportExists  THEN
	IF clientExists = false THEN
		INSERT INTO clients (name) VALUES (clientName);
	END IF;

	SELECT c.id INTO clientId FROM clients c WHERE c.name=clientName;
	SELECT EXISTS( SELECT 1 FROM report_clients rc WHERE rc.report_id=reportId AND rc.client_id=clientId) INTO reportClientExists;

	IF reportClientExists = false THEN
		INSERT INTO report_clients (report_id,client_id) VALUES(reportId,clientId) RETURNING id INTO reportClientId;	
	ELSE
		SELECT rc.id INTO reportClientId FROM report_clients rc WHERE rc.report_id=reportId AND rc.client_id=clientId;		
	END IF;


		
ELSE 
	RAISE EXCEPTION 'REPORT ID PASSED AS ARGUMENT DOES NOT EXISTS';	 
        RETURN -1;
END IF;

RETURN reportClientId;

EXCEPTION  when others then
	RAISE EXCEPTION 'Error creating client test data';	
	RETURN -1;	
END
$$ LANGUAGE plpgsql;

