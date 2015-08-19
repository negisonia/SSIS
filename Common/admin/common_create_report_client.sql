CREATE OR REPLACE FUNCTION common_create_report_client(new_report_id INTEGER, new_client_id INTEGER) --ADMIN DB
RETURNS INTEGER AS $$
DECLARE
  report_client_id INTEGER DEFAULT NULL;
  valueExists BOOLEAN DEFAULT FALSE;
BEGIN

      SELECT EXISTS (SELECT 1 FROM reports r where r.id=new_report_id) INTO valueExists;
      IF valueExists IS FALSE THEN
        select throw_error('REPORT PASSED AS ARGUMENT DOES NOT EXISTS');
      ELSE
        SELECT EXISTS (SELECT 1 FROM clients c where c.id=new_client_id) INTO valueExists;
        IF valueExists IS FALSE THEN
                select throw_error('CLIENT PASSED AS ARGUMENT DOES NOT EXISTS');
        ELSE
              SELECT rc.id INTO report_client_id FROM report_clients rc where rc.report_id=new_report_id and rc.client_id = new_client_id;
              IF report_client_id IS  NULL THEN
                INSERT INTO report_clients(report_id, client_id)
                VALUES (new_report_id, new_client_id) RETURNING id INTO report_client_id;
              END IF;
        END IF;
      END IF;

      RETURNS report_client_id;
END
$$ LANGUAGE plpgsql;