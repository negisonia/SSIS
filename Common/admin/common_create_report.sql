CREATE OR REPLACE FUNCTION create_report(new_bussines_id varchar, new_name varchar, new_active BOOLEAN) --ADMIN DB
RETURNS integer AS $$
DECLARE
  success BOOLEAN DEFAULT false;
  reportId INTEGER DEFAULT NULL;
BEGIN

SELECT r.id INTO reportId FROM reports r WHERE r.business_id=new_bussines_id and r.name=new_name LIMIT 1;

IF reportId IS NULL THEN
    INSERT INTO reports (business_id,name,is_active,created_at,updated_at)
    VALUES (new_bussines_id, new_name, new_active, current_timestamp,current_timestamp) RETURNING id INTO reportId;  -- CREATE THE REPORT AND GET THE REPORT ID
END IF;

RETURN reportId;
END
$$ LANGUAGE plpgsql;