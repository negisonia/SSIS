CREATE OR REPLACE FUNCTION create_report_drugs(reportId integer, drugsIds integer[],indicationId integer) --ADMIN DB
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
reportExists boolean DEFAULT false;
drugExists boolean DEFAULT false;
reportDrugExists boolean DEFAULT false;
drugid integer;
BEGIN

SELECT EXISTS (SELECT 1 FROM reports r WHERE r.id=reportId) INTO reportExists;

--VALIDATE IF THE REPORT ID PASSED AS ARGUMENT EXISTS
IF reportExists = false THEN
	select throw_error('REPORT ID DOES NOT EXISTS');
	success:=false; 
	RETURN success;	
ELSE
	--VALIDATE THAT EACH DRUG ID PASSED AS ARGUMENT EXISTS 
	FOREACH drugid IN ARRAY drugsIds
	LOOP
	  SELECT EXISTS (SELECT 1 FROM drug_indications di where di.drug_id=drugid and di.indication_id=indicationId) INTO drugExists;	
	  IF drugExists = false THEN
		select throw_error('DRUG ID DOES NOT EXISTS FOR SPECIFIED INDICATION');
		success:=false; 
		RETURN success;	
	  END IF;
	END LOOP;
	
	
	--INSERT ALL THE DRUGS IN TO THE REPORT_DRUGS TABLE
		FOREACH drugid IN ARRAY drugsIds
		LOOP
			SELECT EXISTS (SELECT 1 FROM report_drugs rd WHERE rd.report_id=reportId AND rd.indication_id=indicationId AND rd.drug_id=drugid) INTO reportDrugExists;
			--VALIDATE THAT THE RECORD TO INSERT DOES NOT EXISTS TO AVOID DATA DUPLICATION
			IF reportDrugExists = FALSE THEN
				INSERT INTO report_drugs (report_id,indication_id,drug_id) VALUES(reportId,indicationId,drugid);		
			END IF;			
	
		END LOOP;
END IF;


success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;

