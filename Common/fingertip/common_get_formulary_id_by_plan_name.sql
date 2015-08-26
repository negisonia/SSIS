CREATE OR REPLACE FUNCTION common_get_formulary_id_by_plan_name(health_plan_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE

id_value INTEGER;

BEGIN

  SELECT h.formularyfid FROM healthplan h WHERE h.name=health_plan_name LIMIT 1 INTO id_value;
 
  IF id_value IS NULL THEN
    SELECT throw_error('CANNOT FIND FORMULARY ID FOR HEALTH PLAN NAMED ' || health_plan_name);
  ELSE
    RETURN id_value;
  END IF; 

END
$$ LANGUAGE plpgsql;