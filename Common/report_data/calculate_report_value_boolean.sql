CREATE OR REPLACE FUNCTION calculate_report_value_boolean(selection_query VARCHAR, from_query VARCHAR, where_query VARCHAR)--ANALYTICS FRONT END
RETURNS boolean AS $$
DECLARE

actual_value boolean;

BEGIN

EXECUTE 'SELECT (' || selection_query || ' :: boolean) FROM '  || from_query || ' WHERE ' || where_query || ' LIMIT 1' INTO actual_value;

return actual_value;

END
$$ LANGUAGE plpgsql;