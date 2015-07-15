CREATE OR REPLACE FUNCTION throw_error(text)
  RETURNS void AS $$
 BEGIN 
	RAISE EXCEPTION '%', $1; 
 END; 
$$ LANGUAGE plpgsql;