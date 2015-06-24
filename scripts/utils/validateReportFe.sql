--VALIDATES THAT THE REPORT WITH THE SPECIFIES PARAMETER EXISTS IN THE FRONT END DATABASE
CREATE OR REPLACE FUNCTION validatereport(reportBussinesId integer,reportName varchar,drugids integer[], restrictionids integer[], customgroups varchar[]) --FRONT END
RETURNS boolean AS $$
DECLARE
  success boolean DEFAULT false;
  reportId integer;
  drugid integer;
  restrictionid integer;
  customgroup varchar;
  
BEGIN
	--GET THE TEST REPORT ID
	SELECT crr.report_id FROM criteria_restriction_reports crr WHERE crr.business_id=reportBussinesId and  crr.report_name=reportName INTO reportId;

	--VALIDATE THAT THE TEST REPORT IS AVAILABLE IN THE FRONT END DATABASE
	IF reportId = null THEN
		SELECT throw_error('TEST REPORT DOES NOT EXISTS');
	ELSE
	
		--VALIDATE THAT THE TEST REPORT DRUGS IN THE FRONT END DATABASE ARE THE SAME AS THE REPORT DRUGS IN THE ADMIN DATABASE
		 FOREACH drugid IN ARRAY drugIds
		 LOOP
		   IF (SELECT EXISTS (SELECT 1 FROM criteria_restriction_drugs crd WHERE crd.report_id=reportId AND crd.drug_id=drugid) = false) THEN
			select throw_error('TEST REPORT DRUG DOES NOT EXISTS');
		   END IF;
		 END LOOP;
		
		--VALIDATE THAT THE TEST REPORT RESTRICTIONS IN THE FRONT END DATABASE ARE THE SAME AS ADMIN  DATABASE
		 FOREACH restrictionid IN ARRAY restrictionsIds
		 LOOP
		   IF (SELECT EXISTS (SELECT 1 FROM criteria_restriction_selection  crs WHERE crs.report_id=reportId and crs.dim_criteria_restriction_id=restrictionid) = false) THEN
			select throw_error('TEST REPORT RESTRICTION DOES NOT EXISTS');
		  END IF;
		 END LOOP;

		 --VALIDATE THAT THE TEST REPORT CUSTOM GROUPS EXISTS IN THE FRONT END DATABASE
		 FOREACH customgroup IN ARRAY customgroups
		 LOOP
		   IF (SELECT EXISTS (SELECT 1 FROM custom_criteron_selection  ccs WHERE ccs.report_id=reportId and ccs.dim_criterion_type_id=3 and ccs.restriction_name=customgroup) = false) THEN
			select throw_error('CUSTOM GROUP '|| customgroup ||' NOT EXISTS');
		  END IF;
		 END LOOP;		

       END IF;

success:=true;
RETURN success;	  
	
END
$$ LANGUAGE plpgsql;