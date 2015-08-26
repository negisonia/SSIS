CREATE OR REPLACE FUNCTION common_get_reason_code_id_by_code(reason_code VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE

id_value INTEGER;

BEGIN

  SELECT r.id FROM reasoncode r WHERE r.code=reason_code LIMIT 1 INTO id_value;
 
  IF id_value IS NULL THEN
    SELECT throw_error('CANNOT FIND REASON CODE ID WITH CODE ' || reason_code);
  ELSE
    RETURN id_value;
  END IF; 

END
$$ LANGUAGE plpgsql;