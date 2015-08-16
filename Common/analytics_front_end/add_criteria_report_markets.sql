CREATE OR REPLACE FUNCTION add_criteria_report_markets(criteria_report_id INTEGER, market_type TEXT, market_ids INTEGER [])--FRONT END
RETURNS INTEGER AS $$
DECLARE
criteriaExists BOOLEAN DEFAULT FALSE;
intvalue integer;
BEGIN

--VALIDATE MARKET TYPE PARAMETER CONTAINS A VALID VALUE
IF ((market_type = 'State') or (market_type = 'County') or (market_type = 'MetroStatArea') or (market_type = 'National') )  = FALSE THEN  
  SELECT throw_error('INVALID GEOGRAPHY VALUE');
END IF;

--INSERT RECORD INTO CRITERIA REPORTS
SELECT EXISTS(SELECT 1 FROM criteria_reports WHERE id = criteria_report_id) INTO criteriaExists;
IF criteriaExists IS FALSE THEN
  SELECT throw_error('INVALID CRITERIA REPORT ID');
ELSE

  --INSERT MARKET DATA
  FOREACH intvalue IN ARRAY market_ids
  LOOP  
    INSERT INTO criteria_reports_markets(market_id,market_type,criteria_report_id) VALUES(intvalue,market_type,criteria_report_id); 
  END LOOP;

END IF;

RETURN criteria_report_id;
END
$$ LANGUAGE plpgsql;
