CREATE OR REPLACE FUNCTION common_get_county_id_by_name_and_state(county_name VARCHAR, state_name VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE

id_value INTEGER;
state_id INTEGER;

BEGIN

  SELECT common_get_table_id_by_name('state', state_name) INTO state_id;
  EXECUTE SELECT c.id FROM county c WHERE c.name=county_name and c.statefid=state_id LIMIT 1 INTO id_value;
 
  IF id_value IS NULL THEN
    SELECT throw_error('CANNOT FIND COUNTY WITH NAME ' || county_name || ' FOR STATE ' || state_name);
  ELSE
    RETURN id_value;
  END IF; 

END
$$ LANGUAGE plpgsql;