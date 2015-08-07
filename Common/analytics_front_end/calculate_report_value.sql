CREATE OR REPLACE FUNCTION calculate_report_value(selection_query VARCHAR, from_query VARCHAR, where_query VARCHAR)--ANALYTICS FRONT END
RETURNS double precision AS $$
DECLARE

actual_value double precision;

BEGIN

EXECUTE 'SELECT (' || selection_query || ' :: double precision) FROM '  || from_query || ' WHERE ' || where_query || ' LIMIT 1' INTO actual_value;

return actual_value;

END
$$ LANGUAGE plpgsql;