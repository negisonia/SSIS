CREATE OR REPLACE FUNCTION common_create_report_criteria(new_report_id INTEGER, new_criteria_restriction_id INTEGER) --ADMIN
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
valueExists BOOLEAN DEFAULT FALSE;
BEGIN

 SELECT EXISTS (SELECT 1 FROM reports r where r.id=new_report_id) INTO valueExists;
      IF valueExists IS FALSE THEN
        select throw_error('REPORT PASSED AS ARGUMENT DOES NOT EXISTS');
      ELSE
        SELECT EXISTS (SELECT 1 FROM criteria_restriction cr where cr.id=new_criteria_restriction_id) INTO valueExists;
        IF valueExists IS FALSE THEN
                select throw_error('CRITERIA RESTRICTION PASSED AS ARGUMENT DOES NOT EXISTS');
        ELSE
              SELECT EXISTS(SELECT 1 FROM report_criterias rc where rc.report_id=new_report_id and rc.criteria_restriction_id = new_criteria_restriction_id LIMIT 1) INTO valueExists;
              IF valueExists IS FALSE THEN
                INSERT INTO report_criterias(report_id, criteria_restriction_id)
                VALUES (new_report_id, new_criteria_restriction_id);
              END IF;
        END IF;
      END IF;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;