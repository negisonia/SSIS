-- Gets the table id from the name field
-- For Data Entry and FF New dbs
CREATE OR REPLACE FUNCTION common_get_table_id_by_name(model_name VARCHAR, name_value VARCHAR) --FF_NEW DB
RETURNS INTEGER AS $$
DECLARE

id_value INTEGER;

BEGIN

  EXECUTE 'SELECT m.id FROM '  || model_name || ' m WHERE m.name= ''' || name_value || ''' LIMIT 1' INTO id_value;
 
  IF id_value IS NULL THEN
    SELECT throw_error('CANNOT FIND '|| model_name ||' WITH NAME ' || name_value);
  ELSE
    RETURN id_value;
  END IF; 

END
$$ LANGUAGE plpgsql;