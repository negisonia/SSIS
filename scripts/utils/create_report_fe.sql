CREATE OR REPLACE FUNCTION create_report(reportId integer,userid integer,viewtype integer,geography varchar, drugids integer[],health_plan_ids integer[], states_ids integer [], msa_ids integer [], countie_ids integer [], restriction_ids integer[] )--FRONT END
RETURNS INTEGER AS $$
DECLARE
reportfeid integer DEFAULT NULL;
intvalue integer;
recordExist BOOLEAN DEFAULT FALSE;

BEGIN

--VALIDATE PARAMETERS ARE NOT NULL
IF (reportid = null) or (userid = null) or (viewtype=null) or (geography = null) or (drugids = null)  or (health_plan_ids = null) or (restriction_ids= null) THEN
	SELECT throw_error('PARAMETERS reportid, userid, viewtype, geography and restrictions are required');
END IF;

--VALIDATE REPORT PASSED AS ARGUMENT EXISTS
SELECT EXISTS( SELECT 1 FROM criteria_restriction_reports c WHERE c.report_id=reportid) INTO recordExist;
IF recordExist = false THEN
	SELECT throw_error('REPORT ID PASSED AS ARGUMENT DOES NOT EXISTS');
END IF;	

--VALIDATE GEOGRAPHY PARAMETER CONTAINS A VALID VALUE
IF ((geography = 'national') or (geography = 'state') or (geography = 'msa') or (geography = 'county') )  = FALSE THEN	
	SELECT throw_error('INVALID GEOGRAPHY VALUE');
END IF;

--VALIDATE VIEW TYPE CONTAINS VALID VALUE ( 1 CRITERIA, 2 STEP CRITERIA)
IF ((viewtype = 1) or (viewtype = 2)) =false THEN
	SELECT throw_error('INVALID VIEW TYPE VALUE');
END IF;

--VALIDATE THAT DRUGS PASSED AS PARAMETER ARE VALID DRUGS FOR THE REPORT
FOREACH intvalue IN ARRAY drugids
LOOP
SELECT EXISTS(SELECT 1 FROM criteria_restriction_drugs crd WHERE crd.report_id=reportid AND crd.drug_id=intvalue) INTO recordExist;
	IF recordExist = FALSE THEN
		SELECT throw_error('DRUG '|| intvalue ||' IS NOT A VALID DRUG FOR THE REPORT '|| reportid);
	END IF;	
END LOOP;


--VALIDATE THAT HEALTH PLANS PASSED AS PARAMETER ARE VALID  FOR THE REPORT
FOREACH intvalue IN ARRAY health_plan_ids
LOOP
SELECT EXISTS(select 1 from criteria_restriction_health_plan_types crh where crh.report_id=reportid and crh.health_plan_type_id = intvalue) INTO recordExist;
	IF recordExist = FALSE THEN
		SELECT throw_error('HEALTH PLAN '|| intvalue ||' IS NOT A VALID HEALTH PLAN FOR THE REPORT '|| reportid);
	END IF;	
END LOOP;


--VALIDATE THAT RESTRICTIONS PASSED AS PARAMETER ARE VALID  FOR THE REPORT
IF restriction_ids !=NULL THEN
	FOREACH intvalue IN ARRAY restriction_ids
	LOOP
		SELECT EXISTS(select 1 from criteria_restriction_selection crs where crs.report_id=reportid and crs.dim_criteria_restriction_id=intvalue) INTO recordExist;
		IF recordExist = FALSE THEN
			SELECT throw_error('RESTRICTION '|| intvalue ||' IS NOT A VALID RESTRICTION FOR THE REPORT '|| reportid);
		END IF;	
	END LOOP;
END IF;


--VALIDATE GEOGRAPHY DATA IS VALID
CASE geography
     WHEN 'state' THEN
	 IF (states_ids = NULL) OR (array_length(states_ids, 0) <=0) THEN
		SELECT throw_error('STATE IDS ARE REQUIRED FOR STATE GEOGRAPHY');
	 ELSE
		--VALIDATE STATES IDS ARE VALID
		FOREACH intvalue IN ARRAY states_ids
		LOOP
			IF (SELECT EXISTS (SELECT 1 FROM states s WHERE s.id=intvalue) = FALSE) THEN
				SELECT throw_error('STATE ID '|| intvalue || ' IS NOT VALID');
			END IF;
		END LOOP;
	 END IF;
     WHEN 'msa' THEN
	IF (msa_ids = NULL) OR (array_length(msa_ids, 0) <=0) THEN
		SELECT throw_error('MSA IDS ARE REQUIRED FOR MSA GEOGRAPHY');
	 ELSE
		--VALIDATE MSA IDS ARE VALID
		FOREACH intvalue IN ARRAY msa_ids
		LOOP
			IF (SELECT EXISTS (SELECT 1 FROM metro_stat_areas msa WHERE msa.id=intvalue) = FALSE) THEN
				SELECT throw_error('MSA ID '|| intvalue || ' IS NOT VALID');
			END IF;
		END LOOP;
	 END IF;	
     WHEN 'county' THEN
	IF (countie_ids = NULL) OR (array_length(countie_ids, 0) <=0) THEN
		SELECT throw_error('COUNTY IDS ARE REQUIRED FOR COUNTY GEOGRAPHY');
	 ELSE
		--VALIDATE COUNTY IDS ARE VALID
		FOREACH intvalue IN ARRAY countie_ids
		LOOP
			IF (SELECT EXISTS (SELECT 1 FROM counties c WHERE c.id=intvalue) = FALSE) THEN
				SELECT throw_error('COUNTY ID '|| intvalue || ' IS NOT VALID');
			END IF;
		END LOOP;
	 END IF;
     ELSE
END CASE;


--INSERT RECORD INTO CRITERIA REPORTS
INSERT INTO criteria_reports(report_id,user_id,view_type_id,created_at,updated_at,geography) VALUES(reportId,userid,viewtype,now(),now(),geography) RETURNING id INTO reportfeid;

--VALIDATE REPORT ID IS NOT NULL
IF reportfeid = null THEN
	SELECT throw_error('ERROR CREATING CRITERIA REPORT ');
ELSE

        --INSERT GEOGRAPHY DATA
	CASE geography
	     WHEN 'state' THEN
	        --INSERT A RECORD IN TO CRITERIA_REPORTS_STATES FOR EACH STATE ID PASSED AS PARAMETER 
		FOREACH intvalue IN ARRAY states_ids
		LOOP
			INSERT INTO criteria_reports_states(state_id,criteria_report_id) VALUES(intvalue,reportfeid);
		END LOOP;
	     WHEN 'msa' THEN
		--INSERT A RECORD IN TO CRITERIA_REPORTS_METRO_STAT_AREAS FOR EACH MSA ID PASSED AS PARAMETER 
		FOREACH intvalue IN ARRAY msa_ids
		LOOP
			INSERT INTO criteria_reports_metro_stat_areas(metro_stat_area_id,criteria_report_id) VALUES(intvalue,reportfeid);
		END LOOP;
	     WHEN 'county' THEN
		--INSERT A RECORD IN TO CRITERIA_RESTRICTION_COUNTIES FOR EACH COUNTY ID PASSED AS PARAMETER 
		FOREACH intvalue IN ARRAY countie_ids
		LOOP
			INSERT INTO counties_criteria_reports(county_id,criteria_report_id) VALUES(intvalue,reportfeid);
		END LOOP;
	     ELSE
	END CASE;

	--INSERT HEALTH PLAN DATA
	FOREACH intvalue IN ARRAY health_plan_ids
	LOOP	
		INSERT INTO criteria_reports_health_plan_types(health_plan_type_id,criteria_report_id) VALUES(intvalue,reportfeid); 
	END LOOP;
     
        --INSERT DRUGS DATA
        FOREACH intvalue IN ARRAY drugids
	LOOP	
		INSERT INTO criteria_reports_drugs(drug_id,criteria_report_id) VALUES(intvalue,reportfeid); 
	END LOOP;


	--INSERT RESTRICTIONS DATA
	FOREACH intvalue IN ARRAY restriction_ids
	LOOP	
		INSERT INTO criteria_reports_dim_criteria_restriction(dim_criteria_restriction_id,criteria_report_id) VALUES(intvalue,reportfeid); 
	END LOOP;
	
     
END IF;

RETURN reportfeid;
END
$$ LANGUAGE plpgsql;




