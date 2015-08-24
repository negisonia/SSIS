CREATE OR REPLACE FUNCTION common_create_report_drug(new_report_id INTEGER, new_indication_id INTEGER, new_drug_id INTEGER) --ADMIN DB
RETURNS BOOLEAN AS $$
DECLARE
  success BOOLEAN DEFAULT false;
  valueExists BOOLEAN DEFAULT FALSE;
BEGIN


    SELECT EXISTS (SELECT 1 FROM drug_indications di where di.drug_id=new_drug_id and di.indication_id=new_indication_id) INTO valueExists;
      IF valueExists IS FALSE THEN
        select throw_error('DRUG ID DOES NOT EXISTS FOR SPECIFIED INDICATION');
        success:=false;
        RETURN success;
      ELSE
        SELECT EXISTS ( SELECT 1 FROM report_drugs rd WHERE rd.report_id= new_report_id and rd.indication_id= new_indication_id and rd.drug_id = new_drug_id ) INTO valueExists;

        IF valueExists IS FALSE THEN
            INSERT INTO report_drugs(report_id, indication_id, drug_id)
            VALUES (new_report_id, new_indication_id, new_drug_id);
        END IF;

        success :=TRUE;
        RETURN success;
      END IF;
END
$$ LANGUAGE plpgsql;