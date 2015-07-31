CREATE OR REPLACE FUNCTION common_create_restriction(restriction_name VARCHAR, restriction_category VARCHAR) --DATA ENTRY
RETURNS INTEGER AS $$
DECLARE
restriction_id INTEGER DEFAULT NULL;
BEGIN

SELECT r.id INTO restriction_id FROM restrictions r WHERE r.name=restriction_name AND c.category=restriction_category LIMIT 1;

--VALIDATE IF THE RESTRICTION ALREADY EXISTS
IF restriction_id IS NULL THEN
  --INSERT RESTRICTION RECORD
  INSERT INTO restrictions(name, category, created_at, updated_at)
  VALUES ( restriction_name, restriction_category, current_timestamp,current_timestamp) RETURNING id INTO restriction_id;
  RETURN restriction_id;
ELSE
  RETURN restriction_id;
END IF;

END
$$ LANGUAGE plpgsql;
