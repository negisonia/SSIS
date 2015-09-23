-- Dinamically calls the functions found in the table from the passed argument
-- For FF New and Data Entry dbs
CREATE OR REPLACE FUNCTION call_functions_from_table(functions_table VARCHAR)--ADMIN
RETURNS boolean AS $$
DECLARE
success boolean DEFAULT false;
function_name VARCHAR;
BEGIN

 FOR function_name IN
  EXECUTE 'SELECT name from ' || functions_table || ' order by order_id'
 LOOP
  EXECUTE 'SELECT ' || function_name || '()';
 END LOOP;

success:=true;
RETURN success;
END
$$ LANGUAGE plpgsql;