CREATE OR REPLACE FUNCTION create_criteria_report( new_report_id INTEGER, user_id INTEGER, view_type_id INTEGER, drug_class_id INTEGER, market_type_id INTEGER, selected_all_markets BOOLEAN, selected_all_drugs BOOLEAN, selected_all_plan_types BOOLEAN, drug_ids INTEGER[], health_plan_type_ids INTEGER[], market_type TEXT, market_ids INTEGER [], custom_account_id INTEGER, restriction_ids INTEGER[],states_ids INTEGER [], msa_ids INTEGER [], countie_ids INTEGER [])--FRONT END
RETURNS INTEGER AS $$
DECLARE
criteria_report_id integer DEFAULT NULL;
intvalue integer;
recordExist BOOLEAN DEFAULT FALSE;
recordExist2 BOOLEAN DEFAULT FALSE;
BEGIN
-- MARKET TYPES IDS  1County 2State 3MSA 4National 5CBS
------------VALIDATE PARAMETERS
--VALIDATE MARKET TYPE PARAMETER CONTAINS A VALID VALUE
IF ((market_type = 'State') or (market_type = 'County') or (market_type = 'MetroStatArea') or (market_type = 'National') )  = FALSE THEN  
  SELECT throw_error('INVALID MARKET TYPE  VALUE');
END IF;

--VALIDATE VIEW TYPE CONTAINS VALID VALUE ( 1 CRITERIA, 2 STEP CRITERIA, 3 A20 coverage report)
IF ((view_type_id = 1) or (view_type_id = 2) or (view_type_id = 3)) =false THEN
	SELECT throw_error('INVALID VIEW TYPE VALUE');
END IF;

IF new_report_id IS NOT NULL THEN
	--VALIDATE THAT DRUGS PASSED AS PARAMETER ARE VALID DRUGS FOR THE REPORT
	IF drug_ids IS NOT NULL THEN
        FOREACH intvalue IN ARRAY drug_ids
        LOOP
        SELECT EXISTS(SELECT 1 FROM criteria_restriction_drugs crd WHERE crd.report_id=new_report_id AND crd.drug_id=intvalue) INTO recordExist;
            IF recordExist = FALSE THEN
                SELECT throw_error(format('DRUG: %s IS NOT A VALID DRUG FOR THE REPORT %s',intvalue, new_report_id));
            END IF;
        END LOOP;
	END IF;


	--VALIDATE THAT HEALTH PLANS PASSED AS PARAMETER ARE VALID  FOR THE REPORT
	IF health_plan_type_ids IS NOT NULL THEN
        FOREACH intvalue IN ARRAY health_plan_type_ids
        LOOP
        SELECT EXISTS(select 1 from criteria_restriction_health_plan_types crh where crh.report_id=new_report_id and crh.health_plan_type_id = intvalue) INTO recordExist;
            IF recordExist = FALSE THEN
                SELECT throw_error(format('HEALTH PLAN %s IS NOT A VALID HEALTH PLAN FOR THE REPORT %s',intvalue, new_report_id));
            END IF;
        END LOOP;
	END IF;

	--VALIDATE THAT RESTRICTIONS PASSED AS PARAMETER ARE VALID  FOR THE REPORT
	IF restriction_ids IS NOT NULL THEN
		FOREACH intvalue IN ARRAY restriction_ids
		LOOP
			SELECT EXISTS(select 1 from criteria_restriction_selection crs where crs.report_id=new_report_id and crs.dim_criteria_restriction_id=intvalue) INTO recordExist;
			SELECT EXISTS(select 1 from custom_criteron_selection ccs where ccs.report_id=new_report_id and ccs.dim_criteria_restriction_id=intvalue) INTO recordExist2;
			IF (recordExist OR recordExist2)  IS FALSE THEN
				SELECT throw_error(format('RESTRICTION %s IS NOT A VALID RESTRICTION FOR THE REPORT %s',intvalue,new_report_id));
			END IF;
		END LOOP;
	END IF;

	--VALIDATE MARKET DATA IS VALID
    CASE WHEN market_type = 'State' AND states_ids IS NOT NULL  THEN
    	 IF array_length(states_ids, 0) <=0 THEN
    		SELECT throw_error('STATE IDS ARE REQUIRED FOR STATE MARKET TYPE');
    	 ELSE
    		--VALIDATE STATES IDS ARE VALID
    		FOREACH intvalue IN ARRAY states_ids
    		LOOP
    			IF (SELECT EXISTS (SELECT 1 FROM states s WHERE s.id=intvalue) = FALSE) THEN
    				SELECT throw_error(format('STATE ID %s IS NOT VALID', intvalue));
    			END IF;
    		END LOOP;
    	 END IF;
         WHEN market_type = 'MetroStatArea' AND msa_ids IS NOT NULL THEN
    	IF array_length(msa_ids, 0) <=0 THEN
    		SELECT throw_error('MSA IDS ARE REQUIRED FOR MSA MARKET TYPE');
    	 ELSE
    		--VALIDATE MSA IDS ARE VALID
    		FOREACH intvalue IN ARRAY msa_ids
    		LOOP
    			IF (SELECT EXISTS (SELECT 1 FROM metro_stat_areas msa WHERE msa.id=intvalue) = FALSE) THEN
    				SELECT throw_error(format('MSA ID %s IS NOT VALID',intvalue));
    			END IF;
    		END LOOP;
    	 END IF;
         WHEN market_type = 'County' AND countie_ids IS NOT NULL THEN
    	IF array_length(countie_ids, 0) <=0 THEN
    		SELECT throw_error('COUNTY IDS ARE REQUIRED FOR COUNTY MARKET TYPE');
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
INSERT INTO criteria_reports(report_id, user_id, view_type_id, drug_class_id, created_at, updated_at, market_type_id, selected_all_markets, selected_all_drugs, selected_all_plan_types, custom_account_id)
                      VALUES(CASE WHEN new_report_id IS NOT NULL THEN new_report_id ELSE 0 END, user_id, COALESCE(view_type_id,0), drug_class_id, current_timestamp, current_timestamp, market_type_id, COALESCE(selected_all_markets,false), COALESCE(selected_all_drugs,false), COALESCE(selected_all_plan_types,false), custom_account_id) RETURNING id INTO criteria_report_id;

--VALIDATE REPORT ID IS NOT NULL
IF criteria_report_id IS NULL THEN
  SELECT throw_error('ERROR CREATING CRITERIA REPORT');
ELSE

    --INSERT MARKET DATA
    PERFORM add_criteria_report_markets(criteria_report_id, market_type, market_ids);

    --INSERT HEALTH PLAN TYPES DATA
    IF health_plan_type_ids IS NOT NULL THEN
        FOREACH intvalue IN ARRAY health_plan_type_ids
        LOOP
        INSERT INTO criteria_reports_health_plan_types(health_plan_type_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
        END LOOP;
    END IF;
     
    --INSERT DRUGS DATA
    IF drug_ids IS NOT NULL THEN
        FOREACH intvalue IN ARRAY drug_ids
        LOOP
        INSERT INTO criteria_reports_drugs(drug_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
        END LOOP;
    END IF;

    --INSERT RESTRICTIONS DATA
    IF restriction_ids IS NOT NULL THEN
        FOREACH intvalue IN ARRAY restriction_ids
        LOOP
            INSERT INTO criteria_reports_dim_criteria_restriction(dim_criteria_restriction_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
        END LOOP;
	END IF;

    --INSERT MARKET DATA
    CASE WHEN market_type = 'State' AND states_ids IS NOT NULL THEN
            --INSERT A RECORD IN TO CRITERIA_REPORTS_STATES FOR EACH STATE ID PASSED AS PARAMETER
        FOREACH intvalue IN ARRAY states_ids
        LOOP
            INSERT INTO criteria_reports_states(state_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
        END LOOP;
         WHEN market_type = 'MetroStatArea' AND msa_ids IS NOT NULL THEN
            --INSERT A RECORD IN TO CRITERIA_REPORTS_METRO_STAT_AREAS FOR EACH MSA ID PASSED AS PARAMETER
            FOREACH intvalue IN ARRAY msa_ids
            LOOP
                INSERT INTO criteria_reports_metro_stat_areas(metro_stat_area_id,criteria_report_id) VALUES(intvalue,criteria_report_id);
            END LOOP;
         WHEN market_type = 'County' AND countie_ids IS NOT NULL THEN
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
