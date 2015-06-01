﻿CREATE OR REPLACE FUNCTION createReportTestData()
RETURNS integer AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer;
  reportExists boolean DEFAULT false;
  reportBussinesId varchar DEFAULT 'TEST REPORT 001';
  reportName varchar DEFAULT 'TEST REPORT NAME 001';
BEGIN

SELECT EXISTS(SELECT 1 FROM reports r WHERE r.business_id=reportBussinesId and r.name=reportName) INTO reportExists;

IF reportExists THEN
	SELECT r.id INTO reportId FROM reports r WHERE r.business_id=reportBussinesId and r.name=reportName; -- IF THE REPORT ALREADY EXISTS GET THE REPORT ID
ELSE
	INSERT INTO reports (business_id,name,is_active,created_at,updated_at) VALUES (reportBussinesId, reportName, true, now(),now()) RETURNING id INTO reportId;  -- CREATE THE REPORT AND GET THE REPORT ID
END IF;

RETURN reportId;
EXCEPTION  when others then
	raise exception 'Error creating report test data';
	RETURN -1;	
END
$$ LANGUAGE plpgsql;