﻿CREATE OR REPLACE FUNCTION test002validategroups(reportId integer) --FRONT END
RETURNS void AS $$
DECLARE
  success boolean DEFAULT false;
  aux record;
  intValue integer;
  
BEGIN

   IF reportId = NULL THEN
       select throw_error('report id is required');
   END IF;
   
   FOR aux IN SELECT * FROM criteria_restriction_selection crs where crs.report_id=reportId
   LOOP
	  --IF RECORD IS A PHARMACY RESTRICTION
	  IF aux.benefit_name ='Pharmacy' THEN

			  -- IF RECORD IS A NORMAL RESTRICTION  
			  IF aux.dim_criterion_type_id=1 THEN
			    	SELECT COUNT(*) INTO intValue FROM custom_criteron_selection ccs WHERE ccs.restriction_name=aux.restriction_name AND ccs.report_id=reportId and ccs.indication_id=aux.indication_id and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=6
				IF intValue <> 1 THEN
				    SELECT throw_error('INVALID RECORD COUNT WAS GENERATED FOR RESTRICTION ' || aux.dim_criteria_restriction_id || ' INDICATION ' || aux.indication_id || ' TYPE PHARMACY ' || ' CRITERION TYPE ' || aux.dim_criterion_type_id);
				END IF;
			  -- IF RECORD IS A STEPS RESTRICTION
			  ELSIF aux.dim_criterion_type=2
				CASE aux.dim_restriction_type_id
				   WHEN 1 THEN --IS A PA RESTRICTION (6 Y 1)
				   WHEN 3 THEN --IS QUANTITY LIMIT
			        END CASE;   
			  END IF;
		
	  --IF RECORD IS A MEDICAL RESTRICTION
	  ELSEIF aux.benefit_name ='Medical' THEN		     
		           -- IF RECORD IS A NORMAL RESTRICTION  
			  IF aux.dim_criterion_type_id=1 THEN
			      CASE aux.dim_restriction_type_id
				   WHEN 2 THEN --IS A MEDICAL RESTRICTION				   
			      END CASE;
			  -- IF RECORD IS A STEPS RESTRICTION
			  ELSIF aux.dim_criterion_type=2
				CASE aux.dim_restriction_type_id
				   WHEN 2 THEN --IS A MEDICAL RESTRICTION
			        END CASE;   
			  END IF;
	  END IF
  END LOOP;

	










	--VALIDATE THAT GROUP1 EXISTS IN FRONT END DATABASE (must exist only one record) 
	SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group1Name || '%';
	IF groupCount <> 1 THEN
		select throw_error( 'INVALID GROUP COUNT FOR ' || group1Name );
	 ELSE
		--VALIDATE THAT GROUP1 criterion type is equals 3 and restriction type equals 6  		
		IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group1Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=6) = false) THEN
			select throw_error(group1Name || ' CONTAINS INVALID DATA');	
		END IF;	
	END IF;			

	
	--VALIDATE THAT GROUP2 EXISTS IN FRONT END DATABASE (must exist only one record) 
	SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group2Name || '%';
	IF groupCount <> 1 THEN
		select throw_error( 'INVALID GROUP COUNT FOR ' || group2Name );
	 ELSE
		--VALIDATE THAT GROUP2 criterion type must be 3 and restriction type must be 2			 
		IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group2Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=2) = false) THEN
			select throw_error(group2Name || ' CONTAINS INVALID DATA');	
		END IF;	
	END IF;		


	--VALIDATE THAT GROUP3 EXISTS IN FRONT END DATABASE ( should exist 2 custom groups only )		
	SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group3Name || '%';
	IF groupCount <> 2 THEN
		select throw_error( 'INVALID GROUP COUNT FOR ' || group3Name );
	ELSE
		--VALIDATE that both contain criterion type = 3 and one contains restriction type = 2 for Medical and the other restriction type =6 for Pharmacy restrictions
		IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group3Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=2) = false) or
		   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group3Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=6) = false)
		THEN
		    select throw_error(group3Name || ' GROUP DOES NOT EXISTS');			
		END IF;	
	END IF;

	--VALIDATE THAT GROUP4 EXISTS IN FRONT END DATABASE THERE SHOULD EXIST 3 RECORDS ONLY 
	SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group4Name || '%';
	IF groupCount <> 3 THEN
		select throw_error( 'INVALID GROUP COUNT FOR ' || group4Name );
	ELSE
		--VALIDATE that records contain (criterion type=5 and restriction type = 6 and 1)
		IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group4Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=6) = false) or
		   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group4Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=1) = false)
		THEN
		    select throw_error(group4Name || ' GROUP DOES NOT EXISTS');			
		END IF;	
	END IF;


	--VALIDATE THAT GROUP5 EXISTS IN FRONT END DATABASE THERE SHOULD EXIST 9 RECORDS ONLY 
	SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group5Name || '%';
	IF groupCount <> 9 THEN
		select throw_error( 'INVALID GROUP COUNT FOR ' || group5Name );
	ELSE
		--VALIDATE that Single steps records are grouped and contains (criterion type=5 and restriction type = 6 and 1)	
	       SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group5Name || ' - Single%';
		IF groupCount <> 2 THEN
			select throw_error( 'INVALID GROUP COUNT FOR ' || group5Name || ' SINGLE STEPS');
		ELSE   
			IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group5Name || ' - Single%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=6) = false) or
			   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group5Name || ' - Single%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=1) = false)
			THEN
				select throw_error(group5Name || ' GROUP INVALID SINGLE STEPS GROUPING VALUES');			
			END IF;						
		END IF;
					
		--VALIDATE that Double steps records are grouped and contains (criterion type=5 and restriction type = 6 and 1)	
	       SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group5Name || ' - Double%';
		IF groupCount <> 2 THEN
			select throw_error( 'INVALID GROUP COUNT FOR ' || group5Name || 'DOUBLE STEPS'); 
		ELSE   
			IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group5Name || ' - Double%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=6) = false) or
			   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group5Name || ' - Double%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=1) = false)
			THEN
				select throw_error(group5Name || ' GROUP INVALID DOUBLE STEPS GROUPING VALUES');			
			END IF;						
		END IF;

		--VALIDATE that Triple steps records are grouped and contains (criterion type=5 and restriction type = 6 and 1)	
	       SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group5Name || ' - Triple%';
		IF groupCount <> 2 THEN
			select throw_error( 'INVALID GROUP COUNT FOR ' || group5Name || ' TRIPLE STEPS');
		ELSE   
			IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group5Name || ' - Triple%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=6) = false) or
			   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group5Name || ' - Triple%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=1) = false)
			THEN
				select throw_error(group5Name || ' GROUP INVALID TRIPLE STEPS GROUPING VALUES');			
			END IF;						
		END IF;	

		--VALIDATE that Quadruple steps records are grouped and contains (criterion type=5 and restriction type = 6 and 1)	
	       SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group5Name || ' - Quadruple%';
		IF groupCount <> 2 THEN
			select throw_error( 'INVALID GROUP COUNT FOR ' || group5Name || ' SINGLE QUADRUPLE STEPS');
		ELSE   
			IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group5Name || ' - Quadruple%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=6) = false) or
			   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group5Name || ' - Quadruple%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=1) = false)
			THEN
				select throw_error(group5Name || ' GROUP INVALID QUADRUPLE STEPS GROUPING VALUES');			
			END IF;						
		END IF;	
	END IF;

	--VALIDATE THAT GROUP6 EXISTS IN FRONT END DATABASE THERE SHOULD EXIST 2 RECORDS ONLY 
	SELECT COUNT(*) INTO groupCount FROM custom_criteron_selection ccs WHERE ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.restriction_name like group6Name || '%';
	IF groupCount <> 2 THEN
		select throw_error( 'INVALID GROUP COUNT FOR ' || group6Name );
	ELSE
		--VALIDATE one record contains (criterion type=3 and restriction type = 2)
		IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group6Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=2) = false) 			   
		THEN
		    select throw_error(group6Name || ' GROUP DOES NOT EXISTS');			
		END IF;	
		--VALIDATE that records contain (criterion type=5 and restriction type = 2)
		IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group6Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=2) = false) 			   
		THEN
		    select throw_error(group6Name || ' GROUP DOES NOT EXISTS');			
		END IF;	
	END IF;

	--VALIDATE THAT GROUP7 EXISTS IN FRONT END DATABASE  MEDICAL AND PHARMACY GROUPS		
	IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group7Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=2) = false) and
	   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group7Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=6) = false)
	THEN
	    select throw_error(group7Name || ' GROUP DOES NOT EXISTS');			
	ELSE
			IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group7Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=6) = false) and
			   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group7Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=1) = false) and
			   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group7Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=2) = false)
			THEN
				select throw_error(group7Name || ' GROUP INVALID STEPS GROUPING VALUES');			
			END IF;	
	END IF;	

	--VALIDATE THAT GROUP8 EXISTS IN FRONT END DATABASE  MEDICAL AND PHARMACY GROUPS		
	IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group8Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=2) = false) and
	   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name=group8Name AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=3 and ccs.dim_restriction_type_id=6) = false)
	THEN
	    select throw_error(group8Name || ' GROUP DOES NOT EXISTS');			
	ELSE
			IF (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group8Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=6) = false) and
			   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group8Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=1) = false) and
			   (SELECT EXISTS ( SELECT 1 FROM custom_criteron_selection ccs WHERE ccs.restriction_name like group8Name || ' -%' AND ccs.report_id=reportId and ccs.indication_id=reportIndication and ccs.dim_criterion_type_id=5 and ccs.dim_restriction_type_id=2) = false)
			THEN
				select throw_error(group8Name || ' GROUP INVALID STEPS GROUPING VALUES');			
			END IF;	
	END IF;			
END
$$ LANGUAGE plpgsql;