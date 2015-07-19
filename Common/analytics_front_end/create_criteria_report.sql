CREATE OR REPLACE FUNCTION create_criteria_report(report_id INTEGER, user_id INTEGER, client_id INTEGER, drug_class_id INTEGER, market_type_id INTEGER, selected_all_markets BOOLEAN, selected_all_drugs BOOLEAN, selected_all_plan_types BOOLEAN, drug_ids INTEGER[], health_plan_type_ids INTEGER[], market_type TEXT, market_ids INTEGER [])--FRONT END
RETURNS INTEGER AS $$
DECLARE
criteria_report_id integer DEFAULT NULL;
intvalue integer;
BEGIN

--VALIDATE MARKET TYPE PARAMETER CONTAINS A VALID VALUE
IF ((market_type = 'State') or (market_type = 'County') or (market_type = 'MetroStatArea') or (market_type = 'National') )  = FALSE THEN  
  SELECT throw_error('INVALID GEOGRAPHY VALUE');
END IF;

--INSERT RECORD INTO CRITERIA REPORTS
INSERT INTO criteria_reports(report_id, user_id, client_id, drug_class_id, created_at, updated_at, market_type_id, selected_all_markets, selected_all_drugs, selected_all_plan_types) 
                      VALUES(report_id, user_id, client_id, drug_class_id, now(), now(), market_type_id, selected_all_markets, selected_all_drugs, selected_all_plan_types) RETURNING id INTO criteria_report_id;

--VALIDATE REPORT ID IS NOT NULL
IF criteria_report_id IS null THEN
  SELECT throw_error('ERROR CREATING CRITERIA REPORT');
ELSE

  --INSERT MARKET DATA
  FOREACH intvalue IN ARRAY market_ids
  LOOP  
    INSERT INTO criteria_reports_markets(market_id,market_type,criteria_report_id) VALUES(intvalue,market_type,criteria_report_id); 
  END LOOP;

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
     
END IF;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;
