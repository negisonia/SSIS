CREATE OR REPLACE FUNCTION create_criteria_report( new_report_id INTEGER, user_id INTEGER, view_type_id INTEGER, drug_class_id INTEGER, market_type_id INTEGER, selected_all_markets BOOLEAN, selected_all_drugs BOOLEAN, selected_all_plan_types BOOLEAN, drug_ids INTEGER[], health_plan_type_ids INTEGER[], market_type TEXT, market_ids INTEGER [], custom_account_id INTEGER, geography TEXT,restriction_ids INTEGER[],states_ids INTEGER [], msa_ids INTEGER [], countie_ids INTEGER [])--FRONT END
RETURNS INTEGER AS $$
DECLARE
criteria_report_id integer DEFAULT NULL;
intvalue integer;
recordExist BOOLEAN DEFAULT FALSE;
BEGIN

------------VALIDATE PARAMETERS
--VALIDATE MARKET TYPE PARAMETER CONTAINS A VALID VALUE
IF ((market_type = 'State') or (market_type = 'County') or (market_type = 'MetroStatArea') or (market_type = 'National') )  = FALSE THEN  
  SELECT throw_error('INVALID GEOGRAPHY VALUE');
END IF;

--VALIDATE GEOGRAPHY PARAMETER CONTAINS A VALID VALUE
IF ((geography = 'national') or (geography = 'state') or (geography = 'msa') or (geography = 'county') )  = FALSE THEN
	SELECT throw_error('INVALID GEOGRAPHY VALUE');
END IF;

--VALIDATE VIEW TYPE CONTAINS VALID VALUE ( 1 CRITERIA, 2 STEP CRITERIA)
IF ((view_type_id = 1) or (view_type_id = 2)) =false THEN
	SELECT throw_error('INVALID VIEW TYPE VALUE');
END IF;


IF new_report_id IS NOT NULL THEN
	--VALIDATE THAT DRUGS PASSED AS PARAMETER ARE VALID DRUGS FOR THE REPORT
	FOREACH intvalue IN ARRAY drug_ids
	LOOP
	SELECT EXISTS(SELECT 1 FROM criteria_restriction_drugs crd WHERE crd.report_id=new_report_id AND crd.drug_id=intvalue) INTO recordExist;
		IF recordExist = FALSE THEN
			SELECT throw_error(format('DRUG: %s IS NOT A VALID DRUG FOR THE REPORT %s',intvalue, new_report_id));
		END IF;
	END LOOP;


	--VALIDATE THAT HEALTH PLANS PASSED AS PARAMETER ARE VALID  FOR THE REPORT
	FOREACH intvalue IN ARRAY health_plan_type_ids
	LOOP
	SELECT EXISTS(select 1 from criteria_restriction_health_plan_types crh where crh.report_id=new_report_id and crh.health_plan_type_id = intvalue) INTO recordExist;
		IF recordExist = FALSE THEN
			SELECT throw_error(format('HEALTH PLAN %s IS NOT A VALID HEALTH PLAN FOR THE REPORT %s',intvalue, new_report_id));
		END IF;
	END LOOP;

	--VALIDATE THAT RESTRICTIONS PASSED AS PARAMETER ARE VALID  FOR THE REPORT
	IF restriction_ids !=NULL THEN
		FOREACH intvalue IN ARRAY restriction_ids
		LOOP
			SELECT EXISTS(select 1 from criteria_restriction_selection crs where crs.report_id=new_report_id and crs.dim_criteria_restriction_id=intvalue) INTO recordExist;
			IF recordExist = FALSE THEN
				SELECT throw_error(format('RESTRICTION %s IS NOT A VALID RESTRICTION FOR THE REPORT %s',intvalue,new_report_id));
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
    				SELECT throw_error(format('STATE ID %s IS NOT VALID', intvalue));
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
    				SELECT throw_error(format('MSA ID %s IS NOT VALID',intvalue));
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
    				SELECT throw_error(format('COUNTY ID %s IS NOT VALID',intvalue));
    			END IF;
    		END LOOP;
    	 END IF;
    	 ELSE
    END CASE;
END IF;


--INSERT RECORD INTO CRITERIA REPORTS
INSERT INTO criteria_reports(report_id, user_id, view_type_id, drug_class_id, created_at, updated_at, market_type_id, selected_all_markets, selected_all_drugs, selected_all_plan_types, custom_account_id, geography)
                      VALUES(CASE WHEN new_report_id IS NOT NULL THEN new_report_id ELSE 0 END, user_id, view_type_id, drug_class_id, current_timestamp, current_timestamp, market_type_id, selected_all_markets, selected_all_drugs, selected_all_plan_types, custom_account_id, geography) RETURNING id INTO criteria_report_id;

--VALIDATE REPORT ID IS NOT NULL
IF criteria_report_id IS NULL THEN
  SELECT throw_error('ERROR CREATING CRITERIA REPORT');
ELSE

    --INSERT MARKET DATA
    PERFORM add_criteria_report_markets(criteria_report_id, market_type, market_ids);

    --INSERT HEALTH PLAN TYPES DATA
    FOREACH intvalue IN ARRAY health_plan_type_ids
    LOOP
    INSERT INTO criteria_reports_health_plan_types(health_plan_type_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
    END LOOP;
     
    --INSERT DRUGS DATA
    FOREACH intvalue IN ARRAY drug_ids
    LOOP
    INSERT INTO criteria_reports_drugs(drug_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
    END LOOP;

    --INSERT RESTRICTIONS DATA
	FOREACH intvalue IN ARRAY restriction_ids
	LOOP
		INSERT INTO criteria_reports_dim_criteria_restriction(dim_criteria_restriction_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
	END LOOP;

    --INSERT GEOGRAPHY DATA
    CASE geography
         WHEN 'state' THEN
            --INSERT A RECORD IN TO CRITERIA_REPORTS_STATES FOR EACH STATE ID PASSED AS PARAMETER
        FOREACH intvalue IN ARRAY states_ids
        LOOP
            INSERT INTO criteria_reports_states(state_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
        END LOOP;
         WHEN 'msa' THEN
        --INSERT A RECORD IN TO CRITERIA_REPORTS_METRO_STAT_AREAS FOR EACH MSA ID PASSED AS PARAMETER
        FOREACH intvalue IN ARRAY msa_ids
        LOOP
            INSERT INTO criteria_reports_metro_stat_areas(metro_stat_area_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
        END LOOP;
         WHEN 'county' THEN
        --INSERT A RECORD IN TO CRITERIA_RESTRICTION_COUNTIES FOR EACH COUNTY ID PASSED AS PARAMETER
        FOREACH intvalue IN ARRAY countie_ids
        LOOP
            INSERT INTO counties_criteria_reports(county_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
        END LOOP;
        ELSE
    END CASE;
END IF;


RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;
